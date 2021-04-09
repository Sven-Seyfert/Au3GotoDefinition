Func _exit()
    Exit
EndFunc

Func _send( $sKeys )
    Send( $sKeys )
    Sleep( 100 )
EndFunc

Func _getFileContent( $sFile )
    Local $hFile        = FileOpen( $sFile, 256 )
    Local $sFileContent = FileRead( $hFile )
    FileClose( $hFile )

    Return $sFileContent
EndFunc

Func _getJustFileName( $sFilePath )
    Return StringRegExpReplace( $sFilePath, '(.+?)\\', '', 0 )
EndFunc

Func _getJustPathOfFile( $sFilePath )
    Return StringTrimRight( $sFilePath, StringLen( _getJustFileName( $sFilePath ) ) )
EndFunc

Func _addBackslashToPathEnd( $sPath )
    If StringRight( $sPath, 1 ) <> '\' Then $sPath &= '\'

    Return $sPath
EndFunc
