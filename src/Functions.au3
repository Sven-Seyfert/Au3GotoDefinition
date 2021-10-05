Func _isVisualStudioCodeActive()
    If StringInStr(WinGetTitle('[ACTIVE]'), $sEditor, 2) <> 0 Then Return True

    Return False
EndFunc

Func _getCurrentFilePath()
    _send('^{NUMPAD6}')

    Return ClipGet()
EndFunc

Func _getFuncName()
    _send('^{LEFT}')
    _send('^+{RIGHT}')
    _send('^c')

    Return ClipGet()
EndFunc

Func _getAu3FilesOnSameLevel($sFile)
    Local $sPath = _getJustPathOfFile($sFile)

    Return _FileListToArray($sPath, '*.au3', 1, True)
EndFunc

Func _searchForDefinitionInFiles($aFileList, $sPattern)
    Local $iFileListCount = $aFileList[0]

    For $i = 1 To $iFileListCount Step 1
        Local $aFileContent = StringSplit(_getFileContent($aFileList[$i]), @CRLF, 1)
        Local $iFileContentCount = $aFileContent[0]

        For $j = 1 To $iFileContentCount Step 1
            If StringRegExp($aFileContent[$j], $sPattern, 0) Then
                Return $aFileList[$i] & '|' & $j
            EndIf
        Next
    Next

    Return $sWarningMessage
EndFunc

Func _pasteAndEnter($sContent)
    ClipPut($sContent)
    _send('^v')
    _send('{ENTER}')
EndFunc

Func _goToFile($sFile)
    _send('^p')
    _pasteAndEnter(_getJustFileName($sFile))
EndFunc

Func _goToLine($iLine)
    _send('^g')
    _pasteAndEnter($iLine)
EndFunc

Func _openFile($sFile)
    _send('^o')
    If WinWaitActive($sDialogOpenFile, '', 2) == 0 Then Return False
    _pasteAndEnter($sFile)

    Return True
EndFunc

Func _dispose()
    _send('{SHIFTUP 2}')
    _send('{CTRLUP 2}')

    ToolTip('')
EndFunc

Func _goToDefinition()
    If _isVisualStudioCodeActive() Then
        Local $sFuncName        = _getFuncName()
        Local $sCurrentFilePath = _getCurrentFilePath()
        Local $sPattern         = 'Func\s+' & $sFuncName & '\('
        Local $aFileList        = _getAu3FilesOnSameLevel($sCurrentFilePath)
        Local $sFileAndLine     = _searchForDefinitionInFiles($aFileList, $sPattern)

        If $sFileAndLine <> $sWarningMessage Then
            Local $sDefinitionFile = StringSplit($sFileAndLine, '|')[1]
            Local $sDefinitionLine = StringSplit($sFileAndLine, '|')[2]

            _goToFile($sDefinitionFile)
            _goToLine($sDefinitionLine)
        Else
            $sPathOfIncludeFiles = _addBackslashToPathEnd($sPathOfIncludeFiles)
            Local $aFileList     = _getAu3FilesOnSameLevel($sPathOfIncludeFiles)
            Local $sFileAndLine  = _searchForDefinitionInFiles($aFileList, $sPattern)

            If $sFileAndLine <> $sWarningMessage Then
                Local $sDefinitionFile = StringSplit($sFileAndLine, '|')[1]
                Local $sDefinitionLine = StringSplit($sFileAndLine, '|')[2]
                If _openFile($sDefinitionFile) Then
                    Sleep(250)
                    _goToLine($sDefinitionLine)
                EndIf
            Else
                ToolTip($sWarningMessage & '"' & $sFuncName & '".', Default, Default, 'Au3GotoDefinition', 2)
                Sleep(2500)
            EndIf
        EndIf

        _dispose()
    EndIf
EndFunc
