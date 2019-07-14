Func _exit()
    Exit
EndFunc

Func _isVisualStudioCodeActive()
    If StringInStr( WinGetTitle( '[active]' ), $sEditor, 2 ) <> 0 Then Return True
    Return False
EndFunc

Func _send( $sKeys, $iSleep = 150 )
    Send( $sKeys )
    Sleep( $iSleep )
EndFunc

Func _getCurrentFilePath()
    _send( '^{NUMPAD6}', 50 )
    Return ClipGet()
EndFunc

Func _getFuncName()
    _send( '^{LEFT}', 0 )
    _send( '^+{RIGHT}', 0 )
    _send( '^c', 50 )
    Return ClipGet()
EndFunc

Func _getJustFileName( $sFilePath )
    Return StringRegExpReplace( $sFilePath, '(.+?)\\', '', 0 )
EndFunc

Func _getJustPathOfFile( $sFilePath )
    Return StringTrimRight( $sFilePath, StringLen( _getJustFileName( $sFilePath ) ) )
EndFunc

Func _getAu3FilesOnSameLevel( $sFile )
    Local $sPath = _getJustPathOfFile( $sFile )
    Return _FileListToArray( $sPath, '*.au3', 1, True )
EndFunc

Func _getFileContent( $sFile )
    Local $hFile        = FileOpen( $sFile, 256 )
    Local $sFileContent = FileRead( $hFile )
    FileClose( $hFile )
    Return $sFileContent
EndFunc

Func _searchForDefinitionInFiles( $aFileList, $sPattern )
    For $i = 1 To $aFileList[0] Step 1
        Local $aFileContent = StringSplit( _getFileContent( $aFileList[$i] ), @CRLF, 1 )
        For $j = 1 To $aFileContent[0] Step 1
            If StringRegExp( $aFileContent[$j], $sPattern, 0 ) Then
                Return $aFileList[$i] & '|' & $j
            EndIf
        Next
    Next
    Return $sWarningMessage
EndFunc

Func _pasteAndEnter()
    _send( '^v' )
    _send( '{ENTER}' )
EndFunc

Func _goToFile( $sFile )
    _send( '^p' )
    ClipPut( _getJustFileName( $sFile ) )
    _pasteAndEnter()
EndFunc

Func _goToLine( $iLine )
    _send( '^g' )
    ClipPut( $iLine )
    _pasteAndEnter()
EndFunc

Func _goToDefinition()
    If _isVisualStudioCodeActive() Then
        Local $sFuncName        = _getFuncName()
        Local $sCurrentFilePath = _getCurrentFilePath()
        Local $sPattern         = 'Func\s+' & $sFuncName & '\('
        Local $aFileList        = _getAu3FilesOnSameLevel( $sCurrentFilePath )
        Local $sFileAndLine     = _searchForDefinitionInFiles( $aFileList, $sPattern )

        If $sFileAndLine <> $sWarningMessage Then
            Local $sDefinitionFile = StringSplit( $sFileAndLine, '|' )[1]
            Local $sDefinitionLine = StringSplit( $sFileAndLine, '|' )[2]
            _goToFile( $sDefinitionFile )
            _goToLine( $sDefinitionLine )
        Else
            MsgBox( 48, 'Warning', $sWarningMessage, 30 )
        EndIf
    EndIf
EndFunc
