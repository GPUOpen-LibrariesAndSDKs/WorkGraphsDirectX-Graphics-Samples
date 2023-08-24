/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "D3D12ResourceUploader.h"
#include "DXSampleHelper.h"

using Microsoft::WRL::ComPtr;

//=================================================================================================================================
static uint32_t BitsPerPixel(
    DXGI_FORMAT format)
{
    switch (format)
    {
    case DXGI_FORMAT_R32G32B32A32_FLOAT:
        return 128;

    case DXGI_FORMAT_R16G16B16A16_FLOAT:
    case DXGI_FORMAT_R16G16B16A16_UNORM:
        return 64;

    case DXGI_FORMAT_R8G8B8A8_UNORM:
    case DXGI_FORMAT_B8G8R8A8_UNORM:
    case DXGI_FORMAT_B8G8R8X8_UNORM:
    case DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM:
    case DXGI_FORMAT_R10G10B10A2_UNORM:
    case DXGI_FORMAT_R32_FLOAT:
    case DXGI_FORMAT_R32_UINT:
        return 32;

    case DXGI_FORMAT_B5G5R5A1_UNORM:
    case DXGI_FORMAT_B5G6R5_UNORM:
        return 16;

    case DXGI_FORMAT_R16_FLOAT:
    case DXGI_FORMAT_R16_UNORM:
        return 16;

    case DXGI_FORMAT_R8_UNORM:
    case DXGI_FORMAT_A8_UNORM:
        return 8;

    default:
        return 0;
    }
}

//=================================================================================================================================
D3D12ResourceUploader::D3D12ResourceUploader(
    ID3D12Device9*             pDevice,
    ID3D12GraphicsCommandList* pCommandList)
    : m_device{pDevice}
    , m_commandList{pCommandList}
{
}

//=================================================================================================================================
ID3D12Resource* D3D12ResourceUploader::CreateAndUploadTexture(
    const CD3DX12_RESOURCE_DESC& textureDesc,
    uint32_t                     bytesPerRow,
    uint32_t                     bytesPerSlice,
    const void*                  pData)
{
    const auto defaultHeapProperties = CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_DEFAULT);
    const auto uploadHeapProperties  = CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_UPLOAD);

    // Create the final Texture resource.
    ComPtr<ID3D12Resource> texture;
    ThrowIfFailed(m_device->CreateCommittedResource(
        &defaultHeapProperties,
        D3D12_HEAP_FLAG_NONE,
        &textureDesc,
        D3D12_RESOURCE_STATE_COPY_DEST,
        nullptr,
        IID_PPV_ARGS(&texture)
    ));

    const auto uploadBufferDesc = CD3DX12_RESOURCE_DESC::Buffer(GetRequiredIntermediateSize(texture.Get(), 0, 1));

    // Create the GPU upload buffer.
    ComPtr<ID3D12Resource> textureUploadHeap;
    ThrowIfFailed(m_device->CreateCommittedResource(
        &uploadHeapProperties,
        D3D12_HEAP_FLAG_NONE,
        &uploadBufferDesc,
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(&textureUploadHeap)
    ));

    m_uploadHeaps.push_back(textureUploadHeap);

    D3D12_SUBRESOURCE_DATA subresourceData { };
    subresourceData.pData      = pData;
    subresourceData.RowPitch   = bytesPerRow;
    subresourceData.SlicePitch = bytesPerSlice;

    UpdateSubresources(m_commandList.Get(), texture.Get(), textureUploadHeap.Get(), 0, 0, 1, &subresourceData);

    const auto barrier = CD3DX12_RESOURCE_BARRIER::Transition(
        texture.Get(),
        D3D12_RESOURCE_STATE_COPY_DEST,
        (D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE | D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE));
    m_commandList->ResourceBarrier(1, &barrier);

    return texture.Detach();
}

//=================================================================================================================================
ID3D12Resource* D3D12ResourceUploader::CreateTextureFromData(
    uint32_t    width,
    uint32_t    height,
    DXGI_FORMAT format,
    const void* pData)
{
    CD3DX12_RESOURCE_DESC textureDesc { };
    textureDesc.Width              = width;
    textureDesc.Height             = height;
    textureDesc.Format             = format;
    textureDesc.MipLevels          = 1;
    textureDesc.Flags              = D3D12_RESOURCE_FLAG_NONE;
    textureDesc.DepthOrArraySize   = 1;
    textureDesc.SampleDesc.Count   = 1;
    textureDesc.SampleDesc.Quality = 0;
    textureDesc.Dimension          = D3D12_RESOURCE_DIMENSION_TEXTURE2D;

    const uint32_t bitsPerPixel  = BitsPerPixel(textureDesc.Format);
    const uint32_t bytesPerRow   = ((width * bitsPerPixel) >> 3);
    const uint32_t bytesPerSlice = (height * bytesPerRow);

    return CreateAndUploadTexture(textureDesc, bytesPerRow, bytesPerSlice, pData);
}
