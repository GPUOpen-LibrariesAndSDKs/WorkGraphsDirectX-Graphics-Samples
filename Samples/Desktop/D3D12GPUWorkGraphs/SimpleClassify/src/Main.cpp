/* Copyright (c) 2021-2023 Advanced Micro Devices, Inc. All rights reserved. */

#include "stdafx.h"
#include "D3D12SimpleClassify.h"

_Use_decl_annotations_
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow)
{
    D3D12SimpleClassify sample(1920, 1280, L"D3D12 Simple Classify");
    return Win32Application::Run(&sample, hInstance, nCmdShow);
}
