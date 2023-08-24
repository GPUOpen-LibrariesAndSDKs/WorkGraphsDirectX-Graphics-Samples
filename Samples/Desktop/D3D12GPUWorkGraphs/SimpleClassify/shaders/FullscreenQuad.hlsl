/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

Texture2D    g_texture : register(t0);
SamplerState g_sampler : register(s0);

struct PSInput
{
    float4 position : SV_Position;
    float2 texCoord : TEXCOORD;
};

#define EDGE 1.0

PSInput VertexShaderMain(
    in uint index : SV_VertexID)
{
    PSInput result;

    switch (index % 6)
    {
    case 0:
    case 5:
        result.position = float4(-EDGE, EDGE, 0, 1);
        result.texCoord = float2(0, 0);
        break;
    case 1:
        result.position = float4(EDGE, EDGE, 0, 1);
        result.texCoord = float2(1, 0);
        break;
    case 2:
    case 3:
        result.position = float4(EDGE, -EDGE, 0, 1);
        result.texCoord = float2(1, 1);
        break;
    case 4:
        result.position = float4(-EDGE, -EDGE, 0, 1);
        result.texCoord = float2(0, 1);
        break;
    default:
        break;
    }

    return result;
}

float4 PixelShaderMain(in PSInput input) : SV_Target
{
    return g_texture.Sample(g_sampler, input.texCoord);
}
