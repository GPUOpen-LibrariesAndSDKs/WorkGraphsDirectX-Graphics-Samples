/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "stdafx.h"
#include "D3D12SimpleClassify.h"
#include "D3D12ResourceUploader.h"
#include "D3DCompilerHelper.h"
#include "g_MaterialIDs.h"

extern "C" { __declspec(dllexport) extern const uint32_t D3D12SDKVersion = 711; }
extern "C" { __declspec(dllexport) extern const char*    D3D12SDKPath = u8".\\"; }

D3D12SimpleClassify::D3D12SimpleClassify(
    uint32_t     width,
    uint32_t     height,
    std::wstring name)
    : DXSample(width, height, name)
    , m_viewport(0.0f, 0.0f, float(width), float(height))
    , m_scissorRect(0, 0, LONG(width), LONG(height))
    , m_rtvDescriptorSize{0}
    , m_srvUavDescriptorSize{0}
    , m_fenceEvent{nullptr}
    , m_fenceValue{1}
    , m_frameIndex{0}
    , m_hasResetBackingStore{false}
    , m_alwaysResetBackingStore{false}
{
}

_Use_decl_annotations_
void D3D12SimpleClassify::ParseCommandLineArgs(WCHAR* argv[], int argc)
{
    for (int i = 1; i < argc; ++i)
    {
        if ((_wcsnicmp(argv[i], L"-AlwaysResetBackingStore", wcslen(argv[i])) == 0) ||
            (_wcsnicmp(argv[i], L"/AlwaysResetBackingStore", wcslen(argv[i])) == 0))
        {
            m_alwaysResetBackingStore = true;
        }
    }

    DXSample::ParseCommandLineArgs(argv, argc);
}

void D3D12SimpleClassify::OnInit()
{
    InitDeviceObjects();
    LoadAssets();
}

void D3D12SimpleClassify::OnRender()
{
    // Record all the commands we need to render the scene into the command list.
    PopulateCommandList();

    // Execute the command list.
    ID3D12CommandList* ppCommandLists[] = { m_commandList.Get() };
    m_commandQueue->ExecuteCommandLists(_countof(ppCommandLists), ppCommandLists);

    // Present the frame.
    ThrowIfFailed(m_swapChain->Present(1, 0));

    WaitForPreviousFrame();
}

void D3D12SimpleClassify::OnDestroy()
{
    // Ensure that the GPU is no longer referencing resources that are about to be
    // cleaned up by the destructor.
    WaitForPreviousFrame();

    CloseHandle(m_fenceEvent);
}

// Initializes base D3D12 device objects.
void D3D12SimpleClassify::InitDeviceObjects()
{
    const UUID Features[2] = { D3D12ExperimentalShaderModels, D3D12StateObjectsExperiment };
    ThrowIfFailed(D3D12EnableExperimentalFeatures(_countof(Features), Features, nullptr, nullptr));

    ComPtr<ID3D12Debug1> debug;
    ThrowIfFailed(D3D12GetDebugInterface(IID_PPV_ARGS(&debug)));
    debug->EnableDebugLayer();

    ComPtr<IDXGIFactory4> factory;
    ThrowIfFailed(CreateDXGIFactory2(DXGI_CREATE_FACTORY_DEBUG, IID_PPV_ARGS(&factory)));

    ThrowIfFailed(D3D12CreateDevice(
        FindSuitableAdapter(factory.Get()),
        D3D_FEATURE_LEVEL_11_0,
        IID_PPV_ARGS(&m_device)
    ));

    constexpr D3D12_COMMAND_LIST_TYPE CommandListType = D3D12_COMMAND_LIST_TYPE_DIRECT;

    D3D12_COMMAND_QUEUE_DESC CQD { };
    CQD.Flags = D3D12_COMMAND_QUEUE_FLAG_DISABLE_GPU_TIMEOUT;
    CQD.Type  = CommandListType;
    ThrowIfFailed(m_device->CreateCommandQueue(&CQD, IID_PPV_ARGS(&m_commandQueue)));

    ThrowIfFailed(m_device->CreateCommandAllocator(
        CommandListType,
        IID_PPV_ARGS(&m_commandAllocator)
    ));

    ThrowIfFailed(m_device->CreateCommandList(
        0,
        CommandListType,
        m_commandAllocator.Get(),
        nullptr,
        IID_PPV_ARGS(&m_commandList)
    ));

    DXGI_SWAP_CHAIN_DESC1 SCD { };
    SCD.BufferCount = FrameCount;
    SCD.Width       = m_width;
    SCD.Height      = m_height;
    SCD.Format      = DXGI_FORMAT_R8G8B8A8_UNORM;
    SCD.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    SCD.SwapEffect  = DXGI_SWAP_EFFECT_FLIP_DISCARD;
    SCD.SampleDesc.Count = 1;

    ComPtr<IDXGISwapChain1> swapChain;
    ThrowIfFailed(factory->CreateSwapChainForHwnd(
        m_commandQueue.Get(),        // Swap chain needs the queue so that it can force a flush on it.
        Win32Application::GetHwnd(),
        &SCD,
        nullptr,
        nullptr,
        &swapChain
    ));

    // This sample does not support fullscreen transitions.
    ThrowIfFailed(factory->MakeWindowAssociation(Win32Application::GetHwnd(), DXGI_MWA_NO_ALT_ENTER));

    ThrowIfFailed(swapChain.As(&m_swapChain));
    m_frameIndex = m_swapChain->GetCurrentBackBufferIndex();

    // Create descriptor heaps.
    {
        // Descriptor heap containing 1 SRV for the fullscreen Quad PSO.
        D3D12_DESCRIPTOR_HEAP_DESC SUHD { };
        SUHD.NumDescriptors = 1;
        SUHD.Type           = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
        SUHD.Flags          = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
        ThrowIfFailed(m_device->CreateDescriptorHeap(&SUHD, IID_PPV_ARGS(&m_descriptorsPSO)));

        // Descriptor heap containing 1 SRV and 1 UAV for the work graph.
        SUHD.NumDescriptors = 2;
        ThrowIfFailed(m_device->CreateDescriptorHeap(&SUHD, IID_PPV_ARGS(&m_descriptorsWG)));

        // CPU visible descriptor heap for clearing the UAV.
        SUHD.NumDescriptors = 1;
        SUHD.Flags          = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        ThrowIfFailed(m_device->CreateDescriptorHeap(&SUHD, IID_PPV_ARGS(&m_descriptorsClearUAV)));

        // Describe and create a render target view (RTV) descriptor heap.
        D3D12_DESCRIPTOR_HEAP_DESC RHD { };
        RHD.NumDescriptors = FrameCount;
        RHD.Type           = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
        RHD.Flags          = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
        ThrowIfFailed(m_device->CreateDescriptorHeap(&RHD, IID_PPV_ARGS(&m_rtvHeap)));

        m_rtvDescriptorSize    = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
        m_srvUavDescriptorSize = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV);
    }

    // Create a RTV for each frame.
    CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHandle(m_rtvHeap->GetCPUDescriptorHandleForHeapStart());
    for (UINT n = 0; n < FrameCount; ++n)
    {
        ThrowIfFailed(m_swapChain->GetBuffer(n, IID_PPV_ARGS(&m_renderTargets[n])));
        m_device->CreateRenderTargetView(m_renderTargets[n].Get(), nullptr, rtvHandle);
        rtvHandle.Offset(1, m_rtvDescriptorSize);
    }

    // Synchronization objects.
    ThrowIfFailed(m_device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&m_fence)));
    m_fenceValue = 1;

    // Create an event handle to use for frame synchronization.
    m_fenceEvent = ::CreateEvent(nullptr, FALSE, FALSE, nullptr);
    if (m_fenceEvent == nullptr)
    {
        ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
    }
}

// Loads all shaders, textures, and other assets used by the application.
void D3D12SimpleClassify::LoadAssets()
{
    LoadFullscreenQuadPSO();
    LoadWorkGraph();

    D3D12ResourceUploader uploader { m_device.Get(), m_commandList.Get() };

    // Load a texture which contains material IDs for each pixel.
    m_texture.Attach(uploader.CreateTextureFromData(
        MaterialIDs::ImageWidthInPixels,
        MaterialIDs::ImageHeightInPixels,
        MaterialIDs::ImageFormat,
        MaterialIDs::GetImagePixelData()));

    // Create another texture to use as a UAV as output from the Work Graph.
    {
        const auto defaultHeapProperties = CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_DEFAULT);

        auto textureDesc = m_texture->GetDesc();
        textureDesc.Format = DXGI_FORMAT_R16G16B16A16_FLOAT;
        textureDesc.Flags  = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

        ThrowIfFailed(m_device->CreateCommittedResource(
            &defaultHeapProperties,
            D3D12_HEAP_FLAG_NONE,
            &textureDesc,
            D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
            nullptr,
            IID_PPV_ARGS(&m_uav)
        ));
    }

    // Create SRV & UAV descriptors for the shader resources.
    {
        D3D12_SHADER_RESOURCE_VIEW_DESC SRVD { };
        SRVD.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
        SRVD.Format                  = DXGI_FORMAT_UNKNOWN;
        SRVD.ViewDimension           = D3D12_SRV_DIMENSION_TEXTURE2D;
        SRVD.Texture2D.MipLevels     = 1;

        m_device->CreateShaderResourceView(
            m_uav.Get(),
            &SRVD,
            m_descriptorsPSO->GetCPUDescriptorHandleForHeapStart());

        m_device->CreateShaderResourceView(
            m_texture.Get(),
            &SRVD,
            m_descriptorsWG->GetCPUDescriptorHandleForHeapStart());

        D3D12_UNORDERED_ACCESS_VIEW_DESC UAVD { };
        UAVD.Format        = DXGI_FORMAT_UNKNOWN;
        UAVD.ViewDimension = D3D12_UAV_DIMENSION_TEXTURE2D;

        m_device->CreateUnorderedAccessView(
            m_uav.Get(),
            nullptr,
            &UAVD,
            CD3DX12_CPU_DESCRIPTOR_HANDLE {
                m_descriptorsWG->GetCPUDescriptorHandleForHeapStart(),
                1,
                m_srvUavDescriptorSize
            }
        );
        m_device->CreateUnorderedAccessView(
            m_uav.Get(),
            nullptr,
            &UAVD,
            m_descriptorsClearUAV->GetCPUDescriptorHandleForHeapStart());
    }

    // Close the command list and execute it to begin the initial GPU setup.
    ThrowIfFailed(m_commandList->Close());
    ID3D12CommandList* ppCommandLists[] = { m_commandList.Get() };
    m_commandQueue->ExecuteCommandLists(_countof(ppCommandLists), ppCommandLists);

    // Wait for the command list to execute; we are reusing the same command 
    // list in our main loop but for now, we just want to wait for setup to 
    // complete before continuing.
    WaitForPreviousFrame();
}

// Loads the root signature and state object for the GPU Work Graph which runs our classifier.
void D3D12SimpleClassify::LoadWorkGraph()
{
    const std::wstring workGraphName = L"Classifier";

    // Create root signature for the GPU Work Graph.
    {
        CD3DX12_DESCRIPTOR_RANGE1 ranges[2];
        ranges[0].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 0, D3D12_DESCRIPTOR_RANGE_FLAG_NONE);
        ranges[1].Init(D3D12_DESCRIPTOR_RANGE_TYPE_UAV, 1, 0, 0, D3D12_DESCRIPTOR_RANGE_FLAG_NONE);

        CD3DX12_ROOT_PARAMETER1 rootParameters[1];
        rootParameters[0].InitAsDescriptorTable(_countof(ranges), ranges, D3D12_SHADER_VISIBILITY_ALL);

        CD3DX12_VERSIONED_ROOT_SIGNATURE_DESC rootSignatureDesc;
        rootSignatureDesc.Init_1_1(
            _countof(rootParameters),
            rootParameters,
            0,
            nullptr,
            D3D12_ROOT_SIGNATURE_FLAG_NONE);

        ComPtr<ID3DBlob> signature;
        ComPtr<ID3DBlob> error;
        ThrowIfFailed(D3DX12SerializeVersionedRootSignature(
            &rootSignatureDesc,
            D3D_ROOT_SIGNATURE_VERSION_1_1,
            &signature,
            &error)
        );
        ThrowIfFailed(m_device->CreateRootSignature(
            0,
            signature->GetBufferPointer(),
            signature->GetBufferSize(),
            IID_PPV_ARGS(&m_workGraphRS)
        ));
    }

    ComPtr<ID3DBlob> library = CompileDxilLibraryFromFile(L"shaders/g_ClassifyAndShade.hlsl", L"lib_6_8", { });

    CD3DX12_STATE_OBJECT_DESC SOD {D3D12_STATE_OBJECT_TYPE_EXECUTABLE};

    // Add Root Signature as subobject.
    auto pRootSigSubObject = SOD.CreateSubobject<CD3DX12_GLOBAL_ROOT_SIGNATURE_SUBOBJECT>();
    pRootSigSubObject->SetRootSignature(m_workGraphRS.Get());

    // Add Library bytecode as subobject.
    auto pLibSubObject = SOD.CreateSubobject<CD3DX12_DXIL_LIBRARY_SUBOBJECT>();
    CD3DX12_SHADER_BYTECODE libBytecode {library.Get()};
    pLibSubObject->SetDXILLibrary(&libBytecode);

    auto pGraph = SOD.CreateSubobject<CD3DX12_WORK_GRAPH_SUBOBJECT>();
    pGraph->SetProgramName(workGraphName.c_str());
    pGraph->IncludeAllAvailableNodes();
    pGraph->Finalize();

    ComPtr<ID3D12StateObject> stateObj;
    ThrowIfFailed(m_device->CreateStateObject(SOD, IID_PPV_ARGS(&stateObj)));

    m_workGraph.Initialize(m_device.Get(), stateObj.Get(), workGraphName);
    m_hasResetBackingStore = false;
}

// Loads the root signature and pipeline state for a PSO which renders a fullscreen textured Quad.
void D3D12SimpleClassify::LoadFullscreenQuadPSO()
{
    // Create root signature for the simple "Fullscreen Quad PSO".
    {
        CD3DX12_DESCRIPTOR_RANGE1 ranges[1];
        ranges[0].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 0, D3D12_DESCRIPTOR_RANGE_FLAG_DATA_STATIC);

        CD3DX12_ROOT_PARAMETER1 rootParameters[1];
        rootParameters[0].InitAsDescriptorTable(_countof(ranges), ranges, D3D12_SHADER_VISIBILITY_PIXEL);

        D3D12_STATIC_SAMPLER_DESC sampler { };
        sampler.Filter           = D3D12_FILTER_MIN_MAG_MIP_POINT;
        sampler.AddressU         = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
        sampler.AddressV         = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
        sampler.AddressW         = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
        sampler.MipLODBias       = 0;
        sampler.MaxAnisotropy    = 0;
        sampler.ComparisonFunc   = D3D12_COMPARISON_FUNC_NEVER;
        sampler.BorderColor      = D3D12_STATIC_BORDER_COLOR_TRANSPARENT_BLACK;
        sampler.MinLOD           = 0.0f;
        sampler.MaxLOD           = D3D12_FLOAT32_MAX;
        sampler.ShaderRegister   = 0;
        sampler.RegisterSpace    = 0;
        sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

        CD3DX12_VERSIONED_ROOT_SIGNATURE_DESC rootSignatureDesc;
        rootSignatureDesc.Init_1_1(
            _countof(rootParameters),
            rootParameters,
            1,
            &sampler,
            D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);

        ComPtr<ID3DBlob> signature;
        ComPtr<ID3DBlob> error;
        ThrowIfFailed(D3DX12SerializeVersionedRootSignature(
            &rootSignatureDesc,
            D3D_ROOT_SIGNATURE_VERSION_1_1,
            &signature,
            &error)
        );
        ThrowIfFailed(m_device->CreateRootSignature(
            0,
            signature->GetBufferPointer(),
            signature->GetBufferSize(),
            IID_PPV_ARGS(&m_fullscreenQuadRS)
        ));
    }

    // Create the pipeline state, which includes compiling and loading shaders.
    {
        ComPtr<ID3DBlob> vertexShader = CompileShaderFromFile(L"shaders/FullscreenQuad.hlsl", L"VertexShaderMain", L"vs_6_0", { });
        ComPtr<ID3DBlob> pixelShader  = CompileShaderFromFile(L"shaders/FullscreenQuad.hlsl", L"PixelShaderMain",  L"ps_6_0", { });

        // Define the vertex input layout.
        const D3D12_INPUT_ELEMENT_DESC inputElementDescs[] =
        {
            { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0,  0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
            { "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,    0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
        };

        // Describe and create the graphics pipeline state object (PSO).
        D3D12_GRAPHICS_PIPELINE_STATE_DESC GPSD { };
        GPSD.InputLayout                     = { inputElementDescs, _countof(inputElementDescs) };
        GPSD.pRootSignature                  = m_fullscreenQuadRS.Get();
        GPSD.VS                              = CD3DX12_SHADER_BYTECODE(vertexShader.Get());
        GPSD.PS                              = CD3DX12_SHADER_BYTECODE(pixelShader.Get());
        GPSD.RasterizerState                 = CD3DX12_RASTERIZER_DESC(D3D12_DEFAULT);
        GPSD.BlendState                      = CD3DX12_BLEND_DESC(D3D12_DEFAULT);
        GPSD.DepthStencilState.DepthEnable   = FALSE;
        GPSD.DepthStencilState.StencilEnable = FALSE;
        GPSD.SampleMask                      = UINT_MAX;
        GPSD.PrimitiveTopologyType           = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
        GPSD.NumRenderTargets                = 1;
        GPSD.RTVFormats[0]                   = DXGI_FORMAT_R8G8B8A8_UNORM;
        GPSD.SampleDesc.Count                = 1;

        ThrowIfFailed(m_device->CreateGraphicsPipelineState(&GPSD, IID_PPV_ARGS(&m_fullscreenQuadPSO)));
    }
}

// Waits for the previous frame to complete rendering.
void D3D12SimpleClassify::WaitForPreviousFrame()
{
    // WAITING FOR THE FRAME TO COMPLETE BEFORE CONTINUING IS NOT BEST PRACTICE.
    // This is code implemented as such for simplicity. The D3D12HelloFrameBuffering
    // sample illustrates how to use fences for efficient resource usage and to
    // maximize GPU utilization.

    // Signal and increment the fence value.
    const auto fence = m_fenceValue;
    ThrowIfFailed(m_commandQueue->Signal(m_fence.Get(), fence));
    ++m_fenceValue;

    // Wait until the previous frame is finished.
    if (m_fence->GetCompletedValue() < fence)
    {
        ThrowIfFailed(m_fence->SetEventOnCompletion(fence, m_fenceEvent));
        ::WaitForSingleObject(m_fenceEvent, INFINITE);
    }

    m_frameIndex = m_swapChain->GetCurrentBackBufferIndex();
}

// Checks if a DXGI Adapter supports D3D12 and GPU Work Graphs.
static bool CheckAdapter(
    IDXGIAdapter1* pAdapter)
{
    ComPtr<ID3D12Device9> device;
    if (SUCCEEDED(D3D12CreateDevice(pAdapter, D3D_FEATURE_LEVEL_11_0, IID_PPV_ARGS(&device))))
    {
        D3D12_FEATURE_DATA_D3D12_OPTIONS_EXPERIMENTAL options { };

        if (FAILED(device->CheckFeatureSupport(D3D12_FEATURE_D3D12_OPTIONS_EXPERIMENTAL, &options, sizeof(options))) ||
            (options.WorkGraphsTier == D3D12_WORK_GRAPHS_TIER_NOT_SUPPORTED))
        {
            return false;
        }

        D3D12_FEATURE_DATA_ROOT_SIGNATURE featureData { };
        featureData.HighestVersion = D3D_ROOT_SIGNATURE_VERSION_1_1;

        if (FAILED(device->CheckFeatureSupport(D3D12_FEATURE_ROOT_SIGNATURE, &featureData, sizeof(featureData))))
        {
            return false;
        }

        return true;
    }

    return false;
}

// Finds a DXGI Adapter which supports D3D12 and GPU Work Graphs.
IDXGIAdapter1* D3D12SimpleClassify::FindSuitableAdapter(
    IDXGIFactory4* pFactory)
{
    ComPtr<IDXGIAdapter1> adapter;

    ComPtr<IDXGIFactory6> factory6;
    if (SUCCEEDED(pFactory->QueryInterface(IID_PPV_ARGS(&factory6))))
    {
        for (
            uint32_t adapterIndex = 0;
            SUCCEEDED(factory6->EnumAdapterByGpuPreference(
                adapterIndex,
                DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE,
                IID_PPV_ARGS(&adapter)));
            ++adapterIndex)
        {
            DXGI_ADAPTER_DESC1 desc;
            adapter->GetDesc1(&desc);

            if (desc.Flags & DXGI_ADAPTER_FLAG_SOFTWARE)
            {
                // Don't select the Basic Render Driver adapter.
                // If you want a software adapter, pass in "/warp" on the command line.
                continue;
            }

            if (CheckAdapter(adapter.Get()))
            {
                break;
            }
        }
    }

    if(adapter.Get() == nullptr)
    {
        for (uint32_t adapterIndex = 0; SUCCEEDED(pFactory->EnumAdapters1(adapterIndex, &adapter)); ++adapterIndex)
        {
            DXGI_ADAPTER_DESC1 desc;
            adapter->GetDesc1(&desc);

            if (desc.Flags & DXGI_ADAPTER_FLAG_SOFTWARE)
            {
                // Don't select the Basic Render Driver adapter.
                // If you want a software adapter, pass in "/warp" on the command line.
                continue;
            }

            if (CheckAdapter(adapter.Get()))
            {
                break;
            }
        }
    }

    if (adapter.Get() == nullptr)
    {
        throw HrException(D3D12_ERROR_ADAPTER_NOT_FOUND);
    }

    return adapter.Detach();
}

void D3D12SimpleClassify::PopulateCommandList()
{
    std::vector<D3D12_RESOURCE_BARRIER> barriers;

    if (m_fenceValue > 1)
    {
        // Command list allocators can only be reset when the associated command lists have finished execution on the GPU;
        // apps should use fences to determine GPU execution progress.
        ThrowIfFailed(m_commandAllocator->Reset());

        // However, when ExecuteCommandList() is called on a particular command list, that command list can then be reset
        // at any time and must be before  re-recording.
        ThrowIfFailed(m_commandList->Reset(m_commandAllocator.Get(), nullptr));
    }

    // Indicate that the back buffer will be used as a render target.
    barriers.push_back(
        CD3DX12_RESOURCE_BARRIER::Transition(
            m_renderTargets[m_frameIndex].Get(),
            D3D12_RESOURCE_STATE_PRESENT,
            D3D12_RESOURCE_STATE_RENDER_TARGET
    ));
    // Indicate that the UAV texture will be used as a UAV.
    barriers.push_back(
        CD3DX12_RESOURCE_BARRIER::Transition(
            m_uav.Get(),
            D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE,
            D3D12_RESOURCE_STATE_UNORDERED_ACCESS
    ));
    m_commandList->ResourceBarrier(uint32_t(barriers.size()), barriers.data());
    barriers.clear();

    constexpr float ClearColor[] = { 0.0f, 0.2f, 0.4f, 1.0f };

    /* =========================================================================
     * Run the GPU Work Graph
     * ========================================================================= */
    {
        ID3D12DescriptorHeap* ppHeaps[] = { m_descriptorsWG.Get() };
        m_commandList->SetDescriptorHeaps(_countof(ppHeaps), ppHeaps);

        m_commandList->ClearUnorderedAccessViewFloat(
            CD3DX12_GPU_DESCRIPTOR_HANDLE {
                m_descriptorsWG->GetGPUDescriptorHandleForHeapStart(),
                1,
                m_srvUavDescriptorSize
            },
            m_descriptorsClearUAV->GetCPUDescriptorHandleForHeapStart(),
            m_uav.Get(),
            ClearColor,
            0,
            nullptr);

        D3D12_SET_PROGRAM_DESC SPD { };
        SPD.Type = D3D12_PROGRAM_TYPE_WORK_GRAPH;
        SPD.WorkGraph.ProgramIdentifier = m_workGraph.ID();
        SPD.WorkGraph.BackingMemory     = m_workGraph.BackingMemory();

        if (!m_hasResetBackingStore || m_alwaysResetBackingStore)
        {
            // INITIALIZING THE BACKING MEMORY EACH TIME CAN BE INEFFICIENT.
            // Instead, only the first use of the backing memory should initialize it.
            SPD.WorkGraph.Flags = D3D12_SET_WORK_GRAPH_FLAG_INITIALIZE;
            m_hasResetBackingStore = true;
        }

        m_commandList->SetComputeRootSignature(m_workGraphRS.Get());
        m_commandList->SetProgram(&SPD);
        m_commandList->SetComputeRootDescriptorTable(0, m_descriptorsWG->GetGPUDescriptorHandleForHeapStart());

        const auto TD = m_texture->GetDesc();
        struct EntryRecord
        {
            uint32_t gridX, gridY;
        } record { };

        record.gridX = uint32_t(TD.Width  + 7) / 8;
        record.gridY = (TD.Height + 7) / 8;

        D3D12_DISPATCH_GRAPH_DESC DGD { };
        DGD.Mode = D3D12_DISPATCH_MODE_NODE_CPU_INPUT;
        DGD.NodeCPUInput.EntrypointIndex     = 0;
        DGD.NodeCPUInput.NumRecords          = 1;
        DGD.NodeCPUInput.pRecords            = &record;
        DGD.NodeCPUInput.RecordStrideInBytes = sizeof(record);

        m_commandList->DispatchGraph(&DGD);
    }
    /* ========================================================================= */

    // Indicate that the UAV texture will be used as a pixel shader SRV.
    barriers.push_back(
        CD3DX12_RESOURCE_BARRIER::Transition(
            m_uav.Get(),
            D3D12_RESOURCE_STATE_UNORDERED_ACCESS,
            D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE
    ));
    m_commandList->ResourceBarrier(uint32_t(barriers.size()), barriers.data());
    barriers.clear();

    /* =========================================================================
     * Run the Fullscreen Quad PSO
     * ========================================================================= */
    {
        ID3D12DescriptorHeap* ppHeaps[] = { m_descriptorsPSO.Get() };
        m_commandList->SetDescriptorHeaps(_countof(ppHeaps), ppHeaps);

        m_commandList->SetGraphicsRootSignature(m_fullscreenQuadRS.Get());
        m_commandList->SetPipelineState(m_fullscreenQuadPSO.Get());

        const CD3DX12_CPU_DESCRIPTOR_HANDLE rtvHandle {
            m_rtvHeap->GetCPUDescriptorHandleForHeapStart(),
            int32_t(m_frameIndex),
            m_rtvDescriptorSize
        };
        m_commandList->OMSetRenderTargets(1, &rtvHandle, FALSE, nullptr);

        m_commandList->SetGraphicsRootDescriptorTable(0, m_descriptorsPSO->GetGPUDescriptorHandleForHeapStart());
        m_commandList->RSSetViewports(1, &m_viewport);
        m_commandList->RSSetScissorRects(1, &m_scissorRect);

        m_commandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
        m_commandList->DrawInstanced(6, 1, 0, 0);
    }
    /* ========================================================================= */

    // Indicate that the back buffer will now be used to present.
    barriers.push_back(
        CD3DX12_RESOURCE_BARRIER::Transition(
            m_renderTargets[m_frameIndex].Get(),
            D3D12_RESOURCE_STATE_RENDER_TARGET,
            D3D12_RESOURCE_STATE_PRESENT
    ));
    m_commandList->ResourceBarrier(uint32_t(barriers.size()), barriers.data());
    barriers.clear();

    ThrowIfFailed(m_commandList->Close());
}
