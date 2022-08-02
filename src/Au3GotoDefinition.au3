; compiler information for AutoIt
#pragma compile(CompanyName, © SOLVE SMART)
#pragma compile(FileVersion, 1.5.0)
#pragma compile(LegalCopyright, © Sven Seyfert)
#pragma compile(ProductName, Au3GotoDefinition)
#pragma compile(ProductVersion, 1.5.0 - 2022-08-02)

#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\media\favicon.ico
#AutoIt3Wrapper_Outfile_x64=..\build\Au3GotoDefinition.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; opt and just singleton -------------------------------------------------------
Opt('MustDeclareVars', 1)
Global $aInst = ProcessList('Au3GotoDefinition.exe')
If $aInst[0][0] > 1 Then Exit



; includes ---------------------------------------------------------------------
#include-once
#include <File.au3>



; modules ----------------------------------------------------------------------
#include "Declaration.au3"
#include "BasicFunctions.au3"
#include "Functions.au3"



; processing -------------------------------------------------------------------
HotKeySet('^{F10}', '_Exit')
HotKeySet('^{F12}', '_GoToDefinition')

While True
    Sleep(250)
WEnd
