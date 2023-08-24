# Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved.
#

import argparse
import imageio.v3 as IIO
import numpy as NP

# ---------------------------------------------------------------------------- #
# Reads an image from a file on disk and returns an ndarray.
def load_image(file_name):
    img = IIO.imread(file_name)
    if img.dtype != NP.dtype(NP.uint8):
        raise Exception("Unexpected data type of pixel data in source image!")

    if img.shape[2] != 3:
        raise Exception("Unexpected byte count per pixel in source image!")

    return img
# ---------------------------------------------------------------------------- #
# Retrieves the color for a given pixel.
def get_color(img_data, x, y):
    return (img_data[y][x][0], img_data[y][x][1], img_data[y][x][2])
# ---------------------------------------------------------------------------- #
# Maps each unique color in the source image to an integer between 0 and N-1,
# where N is the number of unique colors in the source image.
def generate_color_mapping(img_data):
    if type(img_data) != NP.ndarray:
        raise Exception("Unexpected container type for source image data!")

    colors_map = dict()
    current_id = 0
    for w in range(img_data.shape[1]):
        for h in range(img_data.shape[0]):
            color = get_color(img_data, w, h)
            if color not in colors_map:
                colors_map[color] = current_id
                current_id = current_id + 1

    return colors_map
# ---------------------------------------------------------------------------- #
FileHeader = '''\
/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

/* ============================================================================================= *
 * WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
 * This file is auto-generated.  Do not edit this directly.  Instead, re-run the
 * preprocess-image.py script.
 * ============================================================================================= */
'''
# ---------------------------------------------------------------------------- #
CPPHeaderFile = '''\
#include "stdafx.h"

namespace MaterialIDs
{{

constexpr uint32_t    ImageWidthInPixels  = {Width};
constexpr uint32_t    ImageHeightInPixels = {Height};
constexpr DXGI_FORMAT ImageFormat         = DXGI_FORMAT_R32_UINT;

extern const void* GetImagePixelData();
}}
'''
# ---------------------------------------------------------------------------- #
CPPSourceFileHeader = '''\
#include "g_MaterialIDs.h"

namespace MaterialIDs
{

static const uint32_t kImageData[] =
{
'''
# ---------------------------------------------------------------------------- #
CPPSourceFileFooter = '''\
};

const void* GetImagePixelData()
{
    return kImageData;
}

}
'''
# ---------------------------------------------------------------------------- #
HLSLFileHeader = '''\
Texture2D<uint4>    MaterialIDs: register(t0);
RWTexture2D<float4> OutputUAV:   register(u0);

struct EntryRecord
{
    uint2 gridDimension: SV_DispatchGrid;
};
struct PixelRecord
{
    uint2 pixelID;
};
'''
# ---------------------------------------------------------------------------- #
HLSLCodeSeparator = '''\
/* ============================================================================================= */
'''
# ---------------------------------------------------------------------------- #
ClassifyNodeTemplate = '''[Shader("node")]
[NodeLaunch("Broadcasting")]
[NumThreads(8, 8, 1)]
[NodeID("ClassifyPixels", 0)]
[NodeMaxDispatchGrid(65535,65535,65535)]
[NodeIsProgramEntry]
void ClassifyPixels(
    in uint3 globalThreadID : SV_DispatchThreadID,
    in uint  groupIndex     : SV_GroupIndex,

    DispatchNodeInputRecord<EntryRecord> inputData,

    [NodeID("ShadePixels", 0)]
    [MaxRecords(256)]
    [NodeArraySize({MaterialCount})]
    NodeOutputArray<PixelRecord> outputData)
{{
    uint width;
    uint height;
    MaterialIDs.GetDimensions(width, height);
    const uint materialID = MaterialIDs.Load(globalThreadID.xyz).x;
    const bool thisThreadOutputsData =
        ((globalThreadID.x < width) && (globalThreadID.y < height) && (materialID < {MaterialCount}));

    ThreadNodeOutputRecords<PixelRecord> record =
        outputData[materialID].GetThreadNodeOutputRecords(thisThreadOutputsData ? 1 : 0);
    if (thisThreadOutputsData)
    {{
        record.Get().pixelID = globalThreadID.xy;
    }}
    record.OutputComplete();
}}
'''
# ---------------------------------------------------------------------------- #
ShadePixelsNodeTemplate = '''[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", {ShaderId})]
void ShadePixels_{ShaderId}(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{{
    const float4 materialColor = float4({Red}.0f / 255.0f, {Green}.0f / 255.0f, {Blue}.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {{
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }}
}}
'''
# ---------------------------------------------------------------------------- #
# Generates HLSL describing a work graph which classifies and shades each
# material.
def generate_workgraph_hlsl(colors_map, file_name):
    with open("shaders/" + file_name + ".hlsl", 'w') as wf:
        wf.write(FileHeader + "\n")
        wf.write(HLSLFileHeader + "\n")
        wf.write(HLSLCodeSeparator)
        wf.write(ClassifyNodeTemplate.format(MaterialCount=len(colors_map)))
        for color in colors_map:
            wf.write(HLSLCodeSeparator)
            wf.write(ShadePixelsNodeTemplate.format(
                ShaderId=colors_map[color],
                Red=color[0],
                Green=color[1],
                Blue=color[2]))
# ---------------------------------------------------------------------------- #
# Generates C++ header and source files containing data for an image containing
# material IDs for each pixel.
def generate_material_ids_cpp(img_data, colors_map, file_name):
    width  = img_data.shape[1]
    height = img_data.shape[0]

    with open("inc/" + file_name + ".h", 'w') as wf:
        wf.write(FileHeader + "\n")
        wf.write(CPPHeaderFile.format(Width=width, Height=height))

    with open("src/" + file_name + ".cpp", 'w') as wf:
        wf.write(FileHeader + "\n")
        wf.write(CPPSourceFileHeader + "\n")

        for h in range(height):
            wf.write("    ")
            for w in range(width):
                color = (img_data[h][w][0], img_data[h][w][1], img_data[h][w][2])
                material_id = colors_map[color]
                if w == (width - 1):
                    wf.write("{0},\n".format(material_id))
                else:
                    wf.write("{0}, ".format(material_id))

        wf.write(CPPSourceFileFooter)
# ---------------------------------------------------------------------------- #
# Parses command-line arguments.
def parse_arguments():
    parser = argparse.ArgumentParser(description="Image Preprocessor Script")

    parser.add_argument("-i","--in_file", default=".\\material-ids.png")

    return parser.parse_args();
# ---------------------------------------------------------------------------- #
def main():
    args       = parse_arguments()
    img_data   = load_image(args.in_file)
    colors_map = generate_color_mapping(img_data)

    #write_palette_header(colors_map, args.palette_file)
    #write_material_ids(img_data, colors_map, args.data_file)

    generate_workgraph_hlsl(colors_map, "g_ClassifyAndShade")
    generate_material_ids_cpp(img_data, colors_map, "g_MaterialIDs")

main()
