; compiler information for AutoIt
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\media\favicon.ico
#AutoIt3Wrapper_Outfile_x64=..\build\Au3GotoDefinition.exe
#AutoIt3Wrapper_Res_Description=Au3GotoDefinition (2021-10-05)
#AutoIt3Wrapper_Res_Fileversion=1.0.0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; opt and just singleton -------------------------------------------------------
Opt('MustDeclareVars', 1)
Global $aInst = ProcessList('Au3GotoDefinition.exe')
If $aInst[0][0] > 1 Then Exit



; includes ---------------------------------------------------------------------
#include-once
#include <File.au3>



; references -------------------------------------------------------------------
#include "Declaration.au3"
#include "BasicFunctions.au3"
#include "Functions.au3"



; processing -------------------------------------------------------------------
HotKeySet('^{F10}', '_exit')
HotKeySet('^{F12}', '_goToDefinition')

While 1
    Sleep(250)
WEnd
