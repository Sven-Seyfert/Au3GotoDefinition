Func _Exit()
    Exit
EndFunc

Func _Send($sKeys)
    Send($sKeys)
    Sleep(100)
EndFunc

Func _GetFileContent($sFile)
    Local $hFile        = FileOpen($sFile, 256)
    Local $sFileContent = FileRead($hFile)
    FileClose($hFile)

    Return $sFileContent
EndFunc

Func _GetJustFileName($sFilePath)
    Return StringRegExpReplace($sFilePath, '(.+?)\\', '', 0)
EndFunc

Func _GetJustPathOfFile($sFilePath)
    Return StringTrimRight($sFilePath, StringLen(_GetJustFileName($sFilePath)))
EndFunc

Func _AddBackslashToPathEnd($sPath)
    If StringRight($sPath, 1) <> '\' Then $sPath &= '\'

    Return $sPath
EndFunc
