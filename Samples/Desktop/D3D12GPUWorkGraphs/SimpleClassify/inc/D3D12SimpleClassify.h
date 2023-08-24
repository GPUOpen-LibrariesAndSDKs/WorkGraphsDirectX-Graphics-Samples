/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#pragma once

#include "DXSample.h"
#include "D3D12WorkGraphHelper.h"

// Note that while ComPtr is used to manage the lifetime of resources on the CPU,
// it has no understanding of the lifetime of resources on the GPU. Apps must account
// for the GPU lifetime of resources to avoid destroying objects that may still be
// referenced by the GPU.
// An example of this can be found in the class method: OnDestroy().
using Microsoft::WRL::ComPtr;

class D3D12SimpleClassify : public DXSample
{
public:
    D3D12SimpleClassify(uint32_t width, uint32_t height, std::wstring name);

    virtual void OnInit();
    virtual void OnUpdate() { } // Nothing to do for this sample.
    virtual void OnRender();
    virtual void OnDestroy();

    virtual void ParseCommandLineArgs(_In_reads_(argc) WCHAR* argv[], int argc) override;

private:
    static constexpr uint32_t FrameCount = 2;

    ComPtr<IDXGISwapChain3>     m_swapChain;
    ComPtr<ID3D12Device9>       m_device;
    ComPtr<ID3D12CommandQueue>  m_commandQueue;
    ComPtr<ID3D12Fence>         m_fence;

    ComPtr<ID3D12CommandAllocator>                 m_commandAllocator;
    ComPtr<ID3D12GraphicsCommandListExperimental>  m_commandList;

    ComPtr<ID3D12RootSignature>  m_fullscreenQuadRS;
    ComPtr<ID3D12PipelineState>  m_fullscreenQuadPSO;

    ComPtr<ID3D12RootSignature>  m_workGraphRS;
    D3D12WorkGraphHelper         m_workGraph;

    ComPtr<ID3D12DescriptorHeap>  m_rtvHeap;
    ComPtr<ID3D12DescriptorHeap>  m_descriptorsPSO;
    ComPtr<ID3D12DescriptorHeap>  m_descriptorsWG;
    ComPtr<ID3D12DescriptorHeap>  m_descriptorsClearUAV;

    ComPtr<ID3D12Resource>  m_texture;
    ComPtr<ID3D12Resource>  m_uav;
    ComPtr<ID3D12Resource>  m_renderTargets[FrameCount];

    uint32_t  m_rtvDescriptorSize;
    uint32_t  m_srvUavDescriptorSize;

    HANDLE    m_fenceEvent;
    uint64_t  m_fenceValue;
    uint32_t  m_frameIndex;

    bool m_hasResetBackingStore;
    bool m_alwaysResetBackingStore;

    const CD3DX12_VIEWPORT m_viewport;
    const CD3DX12_RECT     m_scissorRect;

    void InitDeviceObjects();
    void LoadAssets();
    void LoadFullscreenQuadPSO();
    void LoadWorkGraph();

    void PopulateCommandList();
    void WaitForPreviousFrame();

    static IDXGIAdapter1* FindSuitableAdapter(IDXGIFactory4* pFactory);
};
