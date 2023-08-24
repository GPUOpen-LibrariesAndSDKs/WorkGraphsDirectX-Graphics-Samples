/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "stdafx.h"

extern ID3DBlob* CompileShaderFromFile(
    std::wstring           fileName,
    std::wstring           entrypoint,
    std::wstring           target,
    std::vector<DxcDefine> defines);

extern ID3DBlob* CompileDxilLibraryFromFile(
    std::wstring           fileName,
    std::wstring           target,
    std::vector<DxcDefine> defines);
