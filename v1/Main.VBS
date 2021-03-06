Option Explicit

Const AppTitle = "AJPscripts - CherryTree proxy"

Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Dim FSO
Dim WShell

'====================================================================
Public Sub Main()
  Dim DocFileName
  
  Set FSO = CreateObject("Scripting.FileSystemObject")
  Set WShell = CreateObject("WScript.Shell")
  
  DocFileName = GetFileNameFromCmd()
  If DocFileName = vbNullChar Then Exit Sub
  
  If DocFileName <> "" Then _
    If Not ModifyCherryTreeConfig(DocFileName) Then _
      Exit Sub
  
  RunCherryTree
End Sub

'====================================================================
Private Function ModifyCherryTreeConfig(ByVal DocFileName)
  Dim File
  Dim DocFileNameOnly
  Dim DocFilePath
  Dim TXT
  
  On Error Resume Next
  
  ModifyCherryTreeConfig = False
  
  Set File = FSO.GetFile(DocFileName)
  If Err.Number <> 0 Then
    MsgBox DocFileName & vbCrLf & vbCrLf & _
           "Файл не найден.", vbCritical, AppTitle
    Exit Function
  End If
  
  If Not SplitFileName(File.Path, DocFilePath, DocFileNameOnly) Then
    MsgBox DocFileName & vbCrLf & vbCrLf & _
           "Не удалось разбить имя файла.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  TXT = GetFile(CFG_FILE_NAME)
  If Err.Number <> 0 Then
    MsgBox CFG_FILE_NAME & vbCrLf & vbCrLf & _
           "Не удалось прочитать конфиг CherryTree.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  ' Debug!
  'MsgBox TXT
  
  TXT = InsertStringsToCherryTreeConfig(TXT, DocFilePath, DocFileNameOnly)
  If TXT = "" Then Exit Function
  
  ' Debug!
  'MsgBox TXT
  
  PutFile CFG_FILE_NAME, TXT
  If Err.Number <> 0 Then
    MsgBox CFG_FILE_NAME & vbCrLf & vbCrLf & _
           "Не удалось записать конфиг CherryTree.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  ModifyCherryTreeConfig = True
End Function

'====================================================================
Private Function SplitFileName(ByVal FullFileName, _
                               ByRef DocFilePath, _
                               ByRef DocFileNameOnly)
  Dim RC
  
  SplitFileName = False
  
  RC = InStrRev(FullFileName, "\")
  If RC = 0 Then Exit Function
  
  DocFilePath = Left(FullFileName, RC)
  If Len(DocFilePath) <= 1 Then Exit Function
  
  DocFileNameOnly = Mid(FullFileName, RC + 1)
  If Len(DocFileNameOnly) <= 0 Then Exit Function
  
  SplitFileName = True
End Function

'====================================================================
Private Function GetFile(ByVal FileName)
  Dim Stream
  
  Set Stream = FSO.OpenTextFile(FileName, ForReading, False, False)
  GetFile = Stream.ReadAll()
  Stream.Close
  
  GetFile = Utf8ToChar(GetFile)
End Function

'====================================================================
Private Sub PutFile(ByVal FileName, ByVal Data)
  Dim Stream
  
  Data = CharToUtf8(Data)
  
  Set Stream = FSO.OpenTextFile(FileName, ForWriting, True, False)
  Stream.Write Data
  Stream.Close
End Sub

'====================================================================
' file_dir = ...
' file_name = ...
' reload_doc_last = True
'====================================================================
Private Function InsertStringsToCherryTreeConfig(ByVal ConfigText, _
                                                 ByVal DocFilePath, _
                                                 ByVal DocFileNameOnly)
  Dim Lines
  Dim TMP
  
  InsertStringsToCherryTreeConfig = ""
  
  Lines = Split(ConfigText, vbLf)
  For TMP = LBound(Lines) To UBound(Lines)
    If LCase(Left(Lines(TMP), 10)) = "file_dir =" Or _
       LCase(Left(Lines(TMP), 9)) = "file_dir=" Then
      Lines(TMP) = "file_dir = " & DocFilePath
      
    ElseIf LCase(Left(Lines(TMP), 11)) = "file_name =" Or _
           LCase(Left(Lines(TMP), 10)) = "file_name=" Then
      Lines(TMP) = "file_name = " & DocFileNameOnly
      
    ElseIf LCase(Left(Lines(TMP), 17)) = "reload_doc_last =" Or _
           LCase(Left(Lines(TMP), 16)) = "reload_doc_last=" Then
      Lines(TMP) = "reload_doc_last = True"
    End If
  Next
  
  InsertStringsToCherryTreeConfig = Join(Lines, vbLf)
End Function

'====================================================================
Private Sub RunCherryTree()
  Dim RC
  
  On Error Resume Next
  
  RC = WShell.Run("""" & EXE_FILE_NAME & """", 10, False)
  If Err.Number <> 0 Then
    MsgBox EXE_FILE_NAME & vbCrLf & vbCrLf & _
           "Не удалось запустить CherryTree.", _
           vbCritical, AppTitle
  End If
End Sub
