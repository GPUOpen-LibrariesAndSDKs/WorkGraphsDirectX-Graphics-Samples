/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

/* ============================================================================================= *
 * WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
 * This file is auto-generated.  Do not edit this directly.  Instead, re-run the
 * preprocess-image.py script.
 * ============================================================================================= */

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

/* ============================================================================================= */
[Shader("node")]
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
    [NodeArraySize(111)]
    NodeOutputArray<PixelRecord> outputData)
{
    uint width;
    uint height;
    MaterialIDs.GetDimensions(width, height);
    const uint materialID = MaterialIDs.Load(globalThreadID.xyz).x;
    const bool thisThreadOutputsData =
        ((globalThreadID.x < width) && (globalThreadID.y < height) && (materialID < 111));

    ThreadNodeOutputRecords<PixelRecord> record =
        outputData[materialID].GetThreadNodeOutputRecords(thisThreadOutputsData ? 1 : 0);
    if (thisThreadOutputsData)
    {
        record.Get().pixelID = globalThreadID.xy;
    }
    record.OutputComplete();
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 0)]
void ShadePixels_0(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(0.0f / 255.0f, 0.0f / 255.0f, 0.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 1)]
void ShadePixels_1(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(202.0f / 255.0f, 157.0f / 255.0f, 139.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 2)]
void ShadePixels_2(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(92.0f / 255.0f, 185.0f / 255.0f, 216.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 3)]
void ShadePixels_3(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(157.0f / 255.0f, 39.0f / 255.0f, 38.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 4)]
void ShadePixels_4(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(88.0f / 255.0f, 71.0f / 255.0f, 2.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 5)]
void ShadePixels_5(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(9.0f / 255.0f, 53.0f / 255.0f, 246.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 6)]
void ShadePixels_6(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(2.0f / 255.0f, 53.0f / 255.0f, 111.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 7)]
void ShadePixels_7(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(215.0f / 255.0f, 15.0f / 255.0f, 135.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 8)]
void ShadePixels_8(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(40.0f / 255.0f, 12.0f / 255.0f, 52.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 9)]
void ShadePixels_9(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(23.0f / 255.0f, 137.0f / 255.0f, 58.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 10)]
void ShadePixels_10(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(107.0f / 255.0f, 177.0f / 255.0f, 82.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 11)]
void ShadePixels_11(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(120.0f / 255.0f, 32.0f / 255.0f, 20.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 12)]
void ShadePixels_12(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(82.0f / 255.0f, 205.0f / 255.0f, 29.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 13)]
void ShadePixels_13(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(25.0f / 255.0f, 32.0f / 255.0f, 248.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 14)]
void ShadePixels_14(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(62.0f / 255.0f, 202.0f / 255.0f, 199.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 15)]
void ShadePixels_15(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(80.0f / 255.0f, 218.0f / 255.0f, 213.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 16)]
void ShadePixels_16(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(162.0f / 255.0f, 152.0f / 255.0f, 37.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 17)]
void ShadePixels_17(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(213.0f / 255.0f, 15.0f / 255.0f, 114.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 18)]
void ShadePixels_18(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(128.0f / 255.0f, 54.0f / 255.0f, 230.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 19)]
void ShadePixels_19(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(140.0f / 255.0f, 155.0f / 255.0f, 101.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 20)]
void ShadePixels_20(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(86.0f / 255.0f, 2.0f / 255.0f, 67.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 21)]
void ShadePixels_21(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(147.0f / 255.0f, 91.0f / 255.0f, 149.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 22)]
void ShadePixels_22(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(11.0f / 255.0f, 202.0f / 255.0f, 164.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 23)]
void ShadePixels_23(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(100.0f / 255.0f, 148.0f / 255.0f, 187.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 24)]
void ShadePixels_24(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(27.0f / 255.0f, 161.0f / 255.0f, 123.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 25)]
void ShadePixels_25(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(194.0f / 255.0f, 61.0f / 255.0f, 88.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 26)]
void ShadePixels_26(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(151.0f / 255.0f, 145.0f / 255.0f, 198.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 27)]
void ShadePixels_27(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(189.0f / 255.0f, 155.0f / 255.0f, 62.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 28)]
void ShadePixels_28(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(20.0f / 255.0f, 155.0f / 255.0f, 172.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 29)]
void ShadePixels_29(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(105.0f / 255.0f, 137.0f / 255.0f, 152.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 30)]
void ShadePixels_30(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(190.0f / 255.0f, 249.0f / 255.0f, 214.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 31)]
void ShadePixels_31(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(52.0f / 255.0f, 113.0f / 255.0f, 172.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 32)]
void ShadePixels_32(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(5.0f / 255.0f, 108.0f / 255.0f, 63.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 33)]
void ShadePixels_33(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(40.0f / 255.0f, 20.0f / 255.0f, 209.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 34)]
void ShadePixels_34(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(65.0f / 255.0f, 80.0f / 255.0f, 11.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 35)]
void ShadePixels_35(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(239.0f / 255.0f, 80.0f / 255.0f, 207.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 36)]
void ShadePixels_36(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(75.0f / 255.0f, 34.0f / 255.0f, 178.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 37)]
void ShadePixels_37(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(23.0f / 255.0f, 139.0f / 255.0f, 163.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 38)]
void ShadePixels_38(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(54.0f / 255.0f, 75.0f / 255.0f, 80.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 39)]
void ShadePixels_39(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(130.0f / 255.0f, 60.0f / 255.0f, 33.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 40)]
void ShadePixels_40(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(142.0f / 255.0f, 228.0f / 255.0f, 152.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 41)]
void ShadePixels_41(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(84.0f / 255.0f, 206.0f / 255.0f, 102.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 42)]
void ShadePixels_42(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(184.0f / 255.0f, 142.0f / 255.0f, 241.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 43)]
void ShadePixels_43(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(106.0f / 255.0f, 132.0f / 255.0f, 19.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 44)]
void ShadePixels_44(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(118.0f / 255.0f, 112.0f / 255.0f, 199.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 45)]
void ShadePixels_45(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(187.0f / 255.0f, 17.0f / 255.0f, 63.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 46)]
void ShadePixels_46(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(97.0f / 255.0f, 22.0f / 255.0f, 103.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 47)]
void ShadePixels_47(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(141.0f / 255.0f, 127.0f / 255.0f, 139.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 48)]
void ShadePixels_48(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(151.0f / 255.0f, 166.0f / 255.0f, 200.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 49)]
void ShadePixels_49(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(54.0f / 255.0f, 252.0f / 255.0f, 226.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 50)]
void ShadePixels_50(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(116.0f / 255.0f, 190.0f / 255.0f, 187.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 51)]
void ShadePixels_51(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(155.0f / 255.0f, 163.0f / 255.0f, 33.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 52)]
void ShadePixels_52(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(152.0f / 255.0f, 40.0f / 255.0f, 204.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 53)]
void ShadePixels_53(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(89.0f / 255.0f, 219.0f / 255.0f, 141.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 54)]
void ShadePixels_54(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(178.0f / 255.0f, 52.0f / 255.0f, 160.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 55)]
void ShadePixels_55(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(77.0f / 255.0f, 16.0f / 255.0f, 102.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 56)]
void ShadePixels_56(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(44.0f / 255.0f, 129.0f / 255.0f, 193.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 57)]
void ShadePixels_57(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(77.0f / 255.0f, 187.0f / 255.0f, 88.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 58)]
void ShadePixels_58(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(154.0f / 255.0f, 182.0f / 255.0f, 194.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 59)]
void ShadePixels_59(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(16.0f / 255.0f, 254.0f / 255.0f, 230.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 60)]
void ShadePixels_60(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(150.0f / 255.0f, 183.0f / 255.0f, 40.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 61)]
void ShadePixels_61(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(89.0f / 255.0f, 51.0f / 255.0f, 222.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 62)]
void ShadePixels_62(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(35.0f / 255.0f, 253.0f / 255.0f, 175.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 63)]
void ShadePixels_63(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(102.0f / 255.0f, 182.0f / 255.0f, 215.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 64)]
void ShadePixels_64(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(110.0f / 255.0f, 21.0f / 255.0f, 196.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 65)]
void ShadePixels_65(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(112.0f / 255.0f, 210.0f / 255.0f, 244.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 66)]
void ShadePixels_66(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(124.0f / 255.0f, 106.0f / 255.0f, 199.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 67)]
void ShadePixels_67(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(66.0f / 255.0f, 61.0f / 255.0f, 79.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 68)]
void ShadePixels_68(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(201.0f / 255.0f, 114.0f / 255.0f, 75.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 69)]
void ShadePixels_69(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(92.0f / 255.0f, 232.0f / 255.0f, 157.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 70)]
void ShadePixels_70(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(183.0f / 255.0f, 91.0f / 255.0f, 231.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 71)]
void ShadePixels_71(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(244.0f / 255.0f, 181.0f / 255.0f, 13.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 72)]
void ShadePixels_72(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(250.0f / 255.0f, 72.0f / 255.0f, 32.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 73)]
void ShadePixels_73(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(108.0f / 255.0f, 14.0f / 255.0f, 99.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 74)]
void ShadePixels_74(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(4.0f / 255.0f, 229.0f / 255.0f, 97.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 75)]
void ShadePixels_75(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(202.0f / 255.0f, 25.0f / 255.0f, 154.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 76)]
void ShadePixels_76(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(91.0f / 255.0f, 135.0f / 255.0f, 213.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 77)]
void ShadePixels_77(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(222.0f / 255.0f, 211.0f / 255.0f, 223.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 78)]
void ShadePixels_78(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(7.0f / 255.0f, 182.0f / 255.0f, 118.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 79)]
void ShadePixels_79(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(243.0f / 255.0f, 156.0f / 255.0f, 17.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 80)]
void ShadePixels_80(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(128.0f / 255.0f, 220.0f / 255.0f, 37.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 81)]
void ShadePixels_81(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(244.0f / 255.0f, 137.0f / 255.0f, 172.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 82)]
void ShadePixels_82(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(248.0f / 255.0f, 222.0f / 255.0f, 233.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 83)]
void ShadePixels_83(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(178.0f / 255.0f, 194.0f / 255.0f, 175.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 84)]
void ShadePixels_84(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(223.0f / 255.0f, 4.0f / 255.0f, 56.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 85)]
void ShadePixels_85(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(92.0f / 255.0f, 92.0f / 255.0f, 170.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 86)]
void ShadePixels_86(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(134.0f / 255.0f, 70.0f / 255.0f, 182.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 87)]
void ShadePixels_87(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(80.0f / 255.0f, 48.0f / 255.0f, 123.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 88)]
void ShadePixels_88(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(84.0f / 255.0f, 208.0f / 255.0f, 51.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 89)]
void ShadePixels_89(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(246.0f / 255.0f, 148.0f / 255.0f, 80.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 90)]
void ShadePixels_90(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(1.0f / 255.0f, 44.0f / 255.0f, 133.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 91)]
void ShadePixels_91(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(245.0f / 255.0f, 6.0f / 255.0f, 193.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 92)]
void ShadePixels_92(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(203.0f / 255.0f, 37.0f / 255.0f, 101.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 93)]
void ShadePixels_93(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(124.0f / 255.0f, 50.0f / 255.0f, 255.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 94)]
void ShadePixels_94(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(56.0f / 255.0f, 159.0f / 255.0f, 36.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 95)]
void ShadePixels_95(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(212.0f / 255.0f, 109.0f / 255.0f, 55.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 96)]
void ShadePixels_96(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(45.0f / 255.0f, 156.0f / 255.0f, 195.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 97)]
void ShadePixels_97(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(146.0f / 255.0f, 5.0f / 255.0f, 183.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 98)]
void ShadePixels_98(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(60.0f / 255.0f, 221.0f / 255.0f, 25.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 99)]
void ShadePixels_99(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(111.0f / 255.0f, 142.0f / 255.0f, 168.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 100)]
void ShadePixels_100(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(107.0f / 255.0f, 70.0f / 255.0f, 151.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 101)]
void ShadePixels_101(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(123.0f / 255.0f, 54.0f / 255.0f, 167.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 102)]
void ShadePixels_102(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(162.0f / 255.0f, 183.0f / 255.0f, 52.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 103)]
void ShadePixels_103(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(23.0f / 255.0f, 248.0f / 255.0f, 94.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 104)]
void ShadePixels_104(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(115.0f / 255.0f, 216.0f / 255.0f, 220.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 105)]
void ShadePixels_105(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(250.0f / 255.0f, 88.0f / 255.0f, 184.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 106)]
void ShadePixels_106(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(113.0f / 255.0f, 28.0f / 255.0f, 114.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 107)]
void ShadePixels_107(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(65.0f / 255.0f, 113.0f / 255.0f, 247.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 108)]
void ShadePixels_108(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(107.0f / 255.0f, 159.0f / 255.0f, 19.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 109)]
void ShadePixels_109(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(219.0f / 255.0f, 144.0f / 255.0f, 47.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
/* ============================================================================================= */
[Shader("node")]
[NodeLaunch("Coalescing")]
[NumThreads(256, 1, 1)]
[NodeID("ShadePixels", 110)]
void ShadePixels_110(
    in uint groupIndex : SV_GroupIndex,

    [MaxRecords(256)]
    GroupNodeInputRecords<PixelRecord> inputData)
{
    const float4 materialColor = float4(221.0f / 255.0f, 211.0f / 255.0f, 120.0f / 255.0f, 1.0f);
    if (groupIndex < inputData.Count())
    {
        OutputUAV[inputData.Get(groupIndex).pixelID] = materialColor;
    }
}
