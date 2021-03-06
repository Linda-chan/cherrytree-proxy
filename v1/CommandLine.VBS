Option Explicit

'====================================================================
Public Function GetFileNameFromCmd()
  Dim FileName
  
  ' Предполагаем худшее...
  GetFileNameFromCmd = vbNullChar
  
  Select Case WScript.Arguments.Count
    Case 0
      FileName = ""
    Case 1
      FileName = Trim(WScript.Arguments(0))
    Case Else
      ShowUsage
      Exit Function
  End Select
  
  If FileName = "/?" Then
    ShowUsage
    Exit Function
  End If
  
  GetFileNameFromCmd = FileName
End Function

'====================================================================
Private Sub ShowUsage()
  MsgBox "Использование: " & WScript.ScriptName & " [FileName]", _
         vbInformation, AppTitle
End Sub
