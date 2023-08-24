# D3D12 Simple Classify

This directory contains a simple sample showcasing the use of the [D3D12 GPU Work Graphs API](https://devblogs.microsoft.com/directx/d3d12-work-graphs-preview/).  The sample implements a trivial material classification and shading scenario.  The output image is presented to a window.

version 2

**Created**: September 20th, 2022
**Last Updated**: July 6th, 2023

## What the Application Does

The sample uploads a 2D Texture containing integer values at each pixel location, which gets auto-generated at build-time by running a Python script on the input image.  The GPU runs a work graph containing two node arrays to process this input image.  The first node array in the graph contains a single node, named `ClassifyPixels` and uses the launch mode `Broadcast`.  This reads the input texture's data and interprets each pixel value as a unique material ID, and then creates a node payload for the second node array, selecting the appropriate node in that array corresponding to the material ID.  The second node array, named `ShadePixels`, contains a node for each unique material ID and each node consumes an input record containing a pixel location, and writes out a unique color value at that location to the destination Texture UAV.  The shaders in the `ShadePixels` node array all use the `Coalescing` launch type.

Finally, the destination Texture is presented to the display Window.  Successful execution is determined by comparing the image displayed in the Window against the source image, which is located at `material-ids.png` in the project directory.

## Requirements

 - Git (tested with 2.39.1.windows.1)
 - Visual Studio 2022 Preview (this sample should also work with Visual Studio 2019, but this hasn't been tested)
 - Python (tested with 3.11 or newer)
 - Tested on Win10 (22H2, build 19045.3086)
 - Windows Developer Mode enabled
 - Windows setup which supports the [Microsoft Agility SDK](https://devblogs.microsoft.com/directx/gettingstarted-dx12agility/#setup)
 - [GPU and driver supporting GPU Work Graphs](https://devblogs.microsoft.com/directx/d3d12-work-graphs-preview/#Prerequisites)

## Build & Run

 1. Clone the repository.
 2. Open `Samples/Desktop/D3D12GPUWorkGraphs/D3D12GPUWorkGraphs.sln` in Visual Studio
 3. Build the solution.
 4. Run the application.
   - You can force the application to re-initialize the Work Graph backing store every frame by passing the "/AlwaysResetBackingStore" command-line parameter.  Default behavior is to only initialize the backing store on the 1st frame.
 
 Note that the D3D12 runtime and DXC compiler which supports Agility SDK 711 must be present in the same directory as `D3D12SimpleClassify`.  These binaries are automatically downloaded by Visual Studio using NuGet, so the files which will need to be copied out to the executable directory are:
  - `D3D12Core.dll` and `d3d12SDKLayers.dll` from `packages/Microsoft.Direct3D.D3D12.1.711.3-preview/build/native/bin/{platform}/`
  - `dxcompiler.dll` from `packages/Microsoft.Direct3D.DXC.1.8.2306-preview/build/native/bin/{platform}/`

The HLSL shaders used by this application should also be in a `/shaders/` subdirectory of whatever directory `D3D12SimpleClassify.exe` is located.  They are located at `shaders/FullscreenQuad.hlsl` and `shaders/g_ClassifyAndShade.hlsl`.  The latter of them is auto-generated during the build.

## Change Notes

| Version | Date | Changes |
| :--: | :--: | :--- |
| 2 | July 14, 2023 | Clean-Up Code; Second Release |
| 1 | June 23, 2023 | Updated to Agility SDK 711; First Release |
| 0 | September 20, 2022 | Initial version. |