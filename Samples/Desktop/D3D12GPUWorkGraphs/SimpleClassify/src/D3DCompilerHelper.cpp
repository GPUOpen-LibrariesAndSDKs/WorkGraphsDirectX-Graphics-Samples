/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "D3DCompilerHelper.h"
#include "DXSampleHelper.h"

using Microsoft::WRL::ComPtr;

//=================================================================================================================================
ID3DBlob* CompileShaderFromFile(
    std::wstring           fileName,
    std::wstring           entrypoint,
    std::wstring           target,
    std::vector<DxcDefine> defines)
{
    ComPtr<ID3DBlob> code;

    static HMODULE s_hmod = 0;
    static DxcCreateInstanceProc s_pDxcCreateInstanceProc = nullptr;
    if (s_hmod == 0)
    {
        s_hmod = LoadLibrary(L".\\dxcompiler.dll");
        if (s_hmod == 0)
        {
            throw HrException(E_NOINTERFACE);
        }

        if (s_pDxcCreateInstanceProc == nullptr)
        {
            s_pDxcCreateInstanceProc = (DxcCreateInstanceProc)GetProcAddress(s_hmod, "DxcCreateInstance");
            if (s_pDxcCreateInstanceProc == nullptr)
            {
                throw HrException(E_NOINTERFACE);
            }
        }
    }

    ComPtr<IDxcLibrary> library;
    ThrowIfFailed(s_pDxcCreateInstanceProc(CLSID_DxcLibrary, IID_PPV_ARGS(&library)));

    ComPtr<IDxcBlobEncoding> source;
    ThrowIfFailed(library->CreateBlobFromFile(
        fileName.c_str(),
        nullptr,
        &source)
    );

    ComPtr<IDxcIncludeHandler> includeHandler;
    ThrowIfFailed(library->CreateIncludeHandler(&includeHandler));

    ComPtr<IDxcCompiler> compiler;
    ThrowIfFailed(s_pDxcCreateInstanceProc(CLSID_DxcCompiler, IID_PPV_ARGS(&compiler)));

    LPCWSTR args[] = { nullptr };
    const uint32_t argCount = 0;

    ComPtr<IDxcOperationResult> operationResult;
    ThrowIfFailed(compiler->Compile(
        source.Get(),
        nullptr,
        entrypoint.c_str(),
        target.c_str(),
        args,
        argCount,
        defines.data(),
        uint32_t(defines.size()),
        includeHandler.Get(),
        &operationResult)
    );

    HRESULT hr = S_OK;
    operationResult->GetStatus(&hr);
    if (SUCCEEDED(hr))
    {
        ThrowIfFailed(operationResult->GetResult((IDxcBlob**)code.GetAddressOf()));
    }

    ComPtr<IDxcBlobEncoding> errors;
    if (SUCCEEDED(operationResult->GetErrorBuffer(&errors)))
    {
        OutputDebugStringA((LPCSTR)errors->GetBufferPointer());
    }

    return code.Detach();
}

//=================================================================================================================================
extern ID3DBlob* CompileDxilLibraryFromFile(
    std::wstring           fileName,
    std::wstring           target,
    std::vector<DxcDefine> defines)
{
    ComPtr<ID3DBlob> code;

    static HMODULE s_hmod = 0;
    static DxcCreateInstanceProc s_pDxcCreateInstanceProc = nullptr;
    if (s_hmod == 0)
    {
        s_hmod = LoadLibrary(L".\\dxcompiler.dll");
        if (s_hmod == 0)
        {
            throw HrException(E_NOINTERFACE);
        }

        if (s_pDxcCreateInstanceProc == nullptr)
        {
            s_pDxcCreateInstanceProc = (DxcCreateInstanceProc)GetProcAddress(s_hmod, "DxcCreateInstance");
            if (s_pDxcCreateInstanceProc == nullptr)
            {
                throw HrException(E_NOINTERFACE);
            }
        }
    }

    ComPtr<IDxcLibrary> library;
    ThrowIfFailed(s_pDxcCreateInstanceProc(CLSID_DxcLibrary, IID_PPV_ARGS(&library)));

    ComPtr<IDxcBlobEncoding> source;
    ThrowIfFailed(library->CreateBlobFromFile(
        fileName.c_str(),
        nullptr,
        &source)
    );

    ComPtr<IDxcIncludeHandler> includeHandler;
    ThrowIfFailed(library->CreateIncludeHandler(&includeHandler));

    ComPtr<IDxcCompiler> compiler;
    ThrowIfFailed(s_pDxcCreateInstanceProc(CLSID_DxcCompiler, IID_PPV_ARGS(&compiler)));

    LPCWSTR args[] = { NULL };
    const uint32_t argCount = 0;

    ComPtr<IDxcOperationResult> operationResult;
    ThrowIfFailed(compiler->Compile(
        source.Get(),
        nullptr,
        nullptr,
        target.c_str(),
        args,
        argCount,
        defines.data(),
        uint32_t(defines.size()),
        includeHandler.Get(),
        &operationResult)
    );

    HRESULT hr = S_OK;
    operationResult->GetStatus(&hr);
    if (SUCCEEDED(hr))
    {
        ThrowIfFailed(operationResult->GetResult((IDxcBlob**)code.GetAddressOf()));
    }

    ComPtr<IDxcBlobEncoding> errors;
    if (SUCCEEDED(operationResult->GetErrorBuffer(&errors)))
    {
        OutputDebugStringA((LPCSTR)errors->GetBufferPointer());
    }

    return code.Detach();
}
