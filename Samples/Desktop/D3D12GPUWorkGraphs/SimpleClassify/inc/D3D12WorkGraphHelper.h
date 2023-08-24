/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "stdafx.h"

// Note that while ComPtr is used to manage the lifetime of resources on the CPU,
// it has no understanding of the lifetime of resources on the GPU. Apps must account
// for the GPU lifetime of resources to avoid destroying objects that may still be
// referenced by the GPU.
// An example of this can be found in the class method: OnDestroy().
using Microsoft::WRL::ComPtr;

class D3D12WorkGraphHelper
{
public:
    D3D12WorkGraphHelper();

    void Initialize(
        ID3D12Device9*     pDevice,
        ID3D12StateObject* pStateObj,
        std::wstring       workGraphName);

    D3D12_PROGRAM_IDENTIFIER ID() const { return m_programID; }
    D3D12_GPU_VIRTUAL_ADDRESS_RANGE BackingMemory() const { return m_backingMemRange; }

    ID3D12WorkGraphProperties* Props() const { return m_workGraphProps.Get(); }

private:
    ComPtr<ID3D12Device9>              m_device;
    ComPtr<ID3D12StateObject>          m_stateObj;
    ComPtr<ID3D12WorkGraphProperties>  m_workGraphProps;
    ComPtr<ID3D12Resource>             m_backingMem;
    ComPtr<ID3D12Resource>             m_localRootArgsTable;

    D3D12_GPU_VIRTUAL_ADDRESS_RANGE             m_backingMemRange;
    D3D12_GPU_VIRTUAL_ADDRESS_RANGE_AND_STRIDE  m_localArgsRange;

    D3D12_PROGRAM_IDENTIFIER              m_programID;
    D3D12_WORK_GRAPH_MEMORY_REQUIREMENTS  m_memReqs;

    int32_t   m_maxLocalRootArgumentsTableIndex;
    uint32_t  m_numEntrypoints;
    uint32_t  m_numNodes;
    uint32_t  m_workGraphIndex;
};
