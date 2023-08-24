/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#pragma once

#include "stdafx.h"

// Note that while ComPtr is used to manage the lifetime of resources on the CPU,
// it has no understanding of the lifetime of resources on the GPU. Apps must account
// for the GPU lifetime of resources to avoid destroying objects that may still be
// referenced by the GPU.
// An example of this can be found in the class method: OnDestroy().
using Microsoft::WRL::ComPtr;

class D3D12ResourceUploader
{
public:
    D3D12ResourceUploader(
        ID3D12Device9*             pDevice,
        ID3D12GraphicsCommandList* pCommandList);

    ID3D12Resource* CreateTextureFromData(
        uint32_t    width,
        uint32_t    height,
        DXGI_FORMAT format,
        const void* pData);

private:
    ComPtr<ID3D12Device9>                m_device;
    ComPtr<ID3D12GraphicsCommandList>    m_commandList;
    std::vector<ComPtr<ID3D12Resource>>  m_uploadHeaps;

    ID3D12Resource* CreateAndUploadTexture(
        const CD3DX12_RESOURCE_DESC& textureDesc,
        uint32_t                     bytesPerRow,
        uint32_t                     bytesPerSlice,
        const void*                  pData);
};
