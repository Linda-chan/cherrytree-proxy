Option Explicit

Const AppTitle = "AJPscripts - CherryTree proxy SL"

Const WindowsFolder = 0
Const SystemFolder = 1
Const TemporaryFolder = 2

Dim FSO
Dim WShell

'====================================================================
Public Sub Main()
  Dim DocFileName
  
  Set FSO = CreateObject("Scripting.FileSystemObject")
  Set WShell = CreateObject("WScript.Shell")
  
  DocFileName = GetFileNameFromCmd()
  If DocFileName = vbNullChar Then Exit Sub
  
  If DocFileName <> "" Then
    DocFileName = MakeDocSymLink(DocFileName)
    If DocFileName = vbNullChar Then Exit Sub
  End If
  
  RunCherryTree DocFileName
End Sub

'====================================================================
Private Function MakeDocSymLink(ByVal DocFileName)
  Dim LinkFileName
  Dim Cmd
  Dim RC
  
  ' На всякий случай!
  MakeDocSymLink = vbNullChar
  
  ' Для начала проверяем, есть ли такой файл на самом деле!
  If Not FSO.FileExists(DocFileName) Then
    MsgBox DocFileName & vbCrLf & vbCrLf & _
           "Файл не найден.", vbCritical, AppTitle
    Exit Function
  End If
  
  LinkFileName = GetLinkFileName(DocFileName)
  
  Cmd = LN_COMMAND
  Cmd = Replace(Cmd, "%SOURCE%", DocFileName)
  Cmd = Replace(Cmd, "%TARGET%", LinkFileName)
  
  ' Debug!
  'MsgBox Cmd
  
  On Error Resume Next
  
  RC = WShell.Run(Cmd, 0, True)
  If Err.Number <> 0 Then
    MsgBox "Не удалось запустить команду создания симлинка." & _
           vbCrLf & vbCrLf & _
           "Командная строка:" & _
           vbCrLf & vbCrLf & _
           Cmd, vbCritical, AppTitle
    Exit Function
  End If
  
  ' Debug!
  'MsgBox RC
  
  If RC > 0 Then
    MsgBox "Не удалось создать симлинк." & _
           vbCrLf & vbCrLf & _
           "Код ошибки: " & CStr(RC) & _
           vbCrLf & vbCrLf & _
           "Командная строка:" & _
           vbCrLf & vbCrLf & _
           Cmd, vbCritical, AppTitle
    Exit Function
  End If
  
  MakeDocSymLink = LinkFileName
End Function

'====================================================================
Private Sub RunCherryTree(ByVal DocFileName)
  Dim Cmd
  Dim RC
  
  If DocFileName = "" Then
    Cmd = """" & EXE_FILE_NAME & """"
  Else
    Cmd = """" & EXE_FILE_NAME & """ """ & DocFileName & """"
  End If
  
  ' Debug!
  'MsgBox Cmd
  
  On Error Resume Next
  
  RC = WShell.Run(Cmd, 10, False)
  If Err.Number <> 0 Then
    MsgBox "Не удалось запустить CherryTree." & _
           vbCrLf & vbCrLf & _
           "Командная строка:" & _
           vbCrLf & vbCrLf & _
           Cmd, vbCritical, AppTitle
  End If
End Sub
