/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "D3D12WorkGraphHelper.h"
#include "DXSampleHelper.h"

D3D12WorkGraphHelper::D3D12WorkGraphHelper()
    : m_backingMemRange { }
    , m_localArgsRange { }
    , m_programID { }
    , m_memReqs { }
    , m_maxLocalRootArgumentsTableIndex {-1}
    , m_numEntrypoints {0}
    , m_numNodes {0}
    , m_workGraphIndex {0}
{
}

void D3D12WorkGraphHelper::Initialize(
    ID3D12Device9*     pDevice,
    ID3D12StateObject* pStateObj,
    std::wstring       workGraphName)
{
    m_device   = pDevice;
    m_stateObj = pStateObj;

    ComPtr<ID3D12StateObjectProperties1> stateObjProps;
    m_stateObj.As(&stateObjProps);
    m_programID = stateObjProps->GetProgramIdentifier(workGraphName.c_str());

    m_stateObj.As(&m_workGraphProps);
    m_workGraphIndex = m_workGraphProps->GetWorkGraphIndex(workGraphName.c_str());

    m_workGraphProps->GetWorkGraphMemoryRequirements(m_workGraphIndex, &m_memReqs);
    if (m_memReqs.MaxSizeInBytes != 0)
    {
        auto RD = CD3DX12_RESOURCE_DESC::Buffer(m_memReqs.MaxSizeInBytes);
        RD.Flags = D3D12_RESOURCE_FLAG_ALLOW_UNORDERED_ACCESS;

        auto HP = CD3DX12_HEAP_PROPERTIES {D3D12_HEAP_TYPE_DEFAULT};

        ThrowIfFailed(m_device->CreateCommittedResource(
            &HP,
            D3D12_HEAP_FLAG_NONE,
            &RD,
            D3D12_RESOURCE_STATE_COMMON,
            nullptr,
            IID_PPV_ARGS(&m_backingMem)
        ));

        m_backingMemRange.SizeInBytes  = m_memReqs.MaxSizeInBytes;
        m_backingMemRange.StartAddress = m_backingMem->GetGPUVirtualAddress();
    }

    m_numEntrypoints = m_workGraphProps->GetNumEntrypoints(m_workGraphIndex);
    m_numNodes       = m_workGraphProps->GetNumNodes(m_workGraphIndex);

    for (uint32_t i = 0; i < m_numNodes; ++i)
    {
        uint32_t LRATIndex = m_workGraphProps->GetNodeLocalRootArgumentsTableIndex(m_workGraphIndex, i);
        if (LRATIndex != -1)
        {
            m_maxLocalRootArgumentsTableIndex = max(int32_t(LRATIndex), m_maxLocalRootArgumentsTableIndex);
        }
    }

    if (m_maxLocalRootArgumentsTableIndex >= 0)
    {
        throw HrException(E_NOTIMPL);
    }
}
