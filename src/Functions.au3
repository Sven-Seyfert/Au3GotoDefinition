Func _IsVisualStudioCodeActive()
    If StringInStr(WinGetTitle('[ACTIVE]'), $sEditor, 2) <> 0 Then Return True

    Return False
EndFunc

Func _GetCurrentFilePath()
    _Send('^{NUMPAD6}')

    Return ClipGet()
EndFunc

Func _GetFuncName()
    _Send('^{LEFT}')
    _Send('^+{RIGHT}')
    _Send('^c')

    Return ClipGet()
EndFunc

Func _GetAu3FilesOnSameLevel($sFile)
    Local $sPath = _GetJustPathOfFile($sFile)

    Return _FileListToArray($sPath, '*.au3', 1, True)
EndFunc

Func _SearchForDefinitionInFiles($aFileList, $sPattern)
    Local $iFileListCount = $aFileList[0]

    For $i = 1 To $iFileListCount Step 1
        Local $aFileContent = StringSplit(_GetFileContent($aFileList[$i]), @CRLF, 1)
        Local $iFileContentCount = $aFileContent[0]

        For $j = 1 To $iFileContentCount Step 1
            If StringRegExp($aFileContent[$j], $sPattern, 0) Then
                Return $aFileList[$i] & '|' & $j
            EndIf
        Next
    Next

    Return $sWarningMessage
EndFunc

Func _PasteAndEnter($sContent)
    ClipPut($sContent)
    _Send('^v')
    _Send('{ENTER}')
EndFunc

Func _GoToFile($sFile)
    _Send('^p')
    _PasteAndEnter(_GetJustFileName($sFile))
EndFunc

Func _GoToLine($iLine)
    _Send('^g')
    _PasteAndEnter($iLine)
EndFunc

Func _OpenFile($sFile)
    _Send('^o')
    If WinWaitActive($sDialogOpenFile, '', 2) == 0 Then Return False
    _PasteAndEnter($sFile)

    Return True
EndFunc

Func _Dispose()
    _Send('{SHIFTUP 2}')
    _Send('{CTRLUP 2}')

    ToolTip('')
EndFunc

Func _GoToDefinition()
    If _IsVisualStudioCodeActive() Then
        Local $sFuncName        = _GetFuncName()
        Local $sCurrentFilePath = _GetCurrentFilePath()
        Local $sPattern         = 'Func\s+' & $sFuncName & '\('
        Local $aFileList        = _GetAu3FilesOnSameLevel($sCurrentFilePath)
        Local $sFileAndLine     = _SearchForDefinitionInFiles($aFileList, $sPattern)

        If $sFileAndLine <> $sWarningMessage Then
            Local $sDefinitionFile = StringSplit($sFileAndLine, '|')[1]
            Local $sDefinitionLine = StringSplit($sFileAndLine, '|')[2]

            _GoToFile($sDefinitionFile)
            _GoToLine($sDefinitionLine)
        Else
            $sPathOfIncludeFiles = _AddBackslashToPathEnd($sPathOfIncludeFiles)
            Local $aFileList     = _GetAu3FilesOnSameLevel($sPathOfIncludeFiles)
            Local $sFileAndLine  = _SearchForDefinitionInFiles($aFileList, $sPattern)

            If $sFileAndLine <> $sWarningMessage Then
                Local $sDefinitionFile = StringSplit($sFileAndLine, '|')[1]
                Local $sDefinitionLine = StringSplit($sFileAndLine, '|')[2]
                If _OpenFile($sDefinitionFile) Then
                    Sleep(250)
                    _GoToLine($sDefinitionLine)
                EndIf
            Else
                ToolTip($sWarningMessage & '"' & $sFuncName & '".', Default, Default, 'Au3GotoDefinition', 2)
                Sleep(2500)
            EndIf
        EndIf

        _Dispose()
    EndIf
EndFunc
