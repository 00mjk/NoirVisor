@echo off
set path=T:\Program Files\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.28.29910\bin\Hostx86\x86;T:\Program Files\Windows Kits\10\bin\10.0.20348.0\x86;%path%
set incpath=T:\Program Files\Windows Kits\10\Include\10.0.20348.0
set libpath=T:\Program Files\Windows Kits\10\Lib
set binpath=..\bin\compchk_win7x86
set objpath=..\bin\compchk_win7x86\Intermediate

title Compiling NoirVisor, Checked Build, 32-Bit Windows (IA-32 Architecture)
echo Project: NoirVisor
echo Platform: 32-Bit Windows
echo Preset: Debug/Checked Build
echo Powered by zero.tangptr@gmail.com
echo Copyright (c) 2018-2021, zero.tangptr@gmail.com. All Rights Reserved.
if "%~1"=="/s" (echo DO-NOT-PAUSE is activated!) else (pause)

echo ============Start Compiling============
echo Compiling Windows Driver Framework...
cl ..\src\booting\windrv\driver.c /I"%incpath%\km\crt" /I"%incpath%\shared" /I"%incpath%\km" /Zi /nologo /W3 /WX /wd4311 /Od /Oy- /D"_X86_" /D"_X86" /D"_WIN32" /D "_NDEBUG" /D"_UNICODE" /D "UNICODE" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\driver.cod" /Fo"%objpath%\driver.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue

rc /nologo /i"%incpath%\shared" /i"%incpath%\um" /i"%incpath%\km\crt" /fo"%objpath%\version.res" /n ..\src\booting\windrv\version.rc

echo Compiling Core Engine of Intel VT-x...
for %%1 in (..\src\vt_core\*.c) do (cl %%1 /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_vt_core" /D"_%%~n1" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\%%~n1.cod" /Fo"%objpath%\%%~n1.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue)

echo Compiling Core Engine of AMD-V...
for %%1 in (..\src\svm_core\*.c) do (cl %%1 /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_svm_core" /D"_%%~n1" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\%%~n1.cod" /Fo"%objpath%\%%~n1.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue)

echo Compiling Core Engine of Microsoft Hypervisor (MSHV)...
for %%1 in (..\src\mshv_core\*.c) do (cl %%1 /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_mshv_core" /D"_%%~n1" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\%%~n1.cod" /Fo"%objpath%\%%~n1.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue)

echo Compiling Core of Cross-Platform Framework (XPF)...
for %%1 in (..\src\xpf_core\windows\*.c) do (cl %%1 /I"%incpath%\km\crt" /I"%incpath%\shared" /I"%incpath%\km" /Zi /nologo /W3 /WX /Od /D"_KERNEL_MODE" /D"_X86_" /D"_X86" /D"_WIN32" /D "_NDEBUG" /D"_UNICODE" /D "UNICODE" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\%%~n1.cod" /Fo"%objpath%\%%~n1.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue)

cl ..\src\xpf_core\noirhvm.c /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_central_hvm" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\noirhvm.cod" /Fo"%objpath%\noirhvm.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue

cl ..\src\xpf_core\ci.c /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_code_integrity" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\ci.cod" /Fo"%objpath%\ci.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue

cl ..\src\xpf_core\devkits.c /I"..\src\include" /Zi /nologo /W3 /WX /Oi /Od /D"_msvc" /D"_ia32" /D"_dev_kits" /Zc:wchar_t /std:c17 /FAcs /Fa"%objpath%\devkits.cod" /Fo"%objpath%\devkits.obj" /Fd"%objpath%\vc140.pdb" /GS- /Qspectre /TC /c /errorReport:queue

for %%1 in (..\src\xpf_core\windows\*.asm) do (ml /W3 /WX /D"_ia32" /Zf /Zd /Fo"%objpath%\%%~n1.obj" /c /nologo %%1)

echo ============Start Linking============
link "%objpath%\*.obj" "%objpath%\version.res" /LIBPATH:"%libpath%\win7\km\x86" /NODEFAULTLIB "ntoskrnl.lib" "..\src\disasm\LDE32.lib" /NOLOGO /DEBUG /PDB:"%objpath%\NoirVisor.pdb" /OUT:"%binpath%\NoirVisor.sys" /SUBSYSTEM:NATIVE /Driver /ENTRY:"NoirDriverEntry" /Machine:X86 /ERRORREPORT:QUEUE

echo ============Start Signing============
signtool sign /v /fd SHA1 /f .\ztnxtest.pfx /t http://timestamp.globalsign.com/scripts/timestamp.dll %binpath%\NoirVisor.sys

if "%~1"=="/s" (echo Completed!) else (pause)