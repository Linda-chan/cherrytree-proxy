Option Explicit

'====================================================================
Public Function GetLinkFileName(ByVal DocFileName)
  Dim LinkFileName
  
  LinkFileName = FSO.GetFileName(DocFileName)
  LinkFileName = TranslitText(LinkFileName)
  LinkFileName = EscapeUnicodeChars(LinkFileName)
  LinkFileName = InsertGUID(LinkFileName)
  
  If SYMLINK_FOLDER = "" Then
    LinkFileName = FSO.BuildPath(FSO.GetSpecialFolder(TemporaryFolder), LinkFileName)
  Else
    LinkFileName = FSO.BuildPath(SYMLINK_FOLDER, LinkFileName)
  End If
  
  ' Debug!
  'MsgBox DocFileName & vbCrLf & _
  '       vbCrLf & LinkFileName
  
  GetLinkFileName = LinkFileName
End Function

'====================================================================
' Test file name:
'   Byaka «Тест!» カリビアンコム 2827 ダイナマイト.ctd
'====================================================================
Private Function EscapeUnicodeChars(ByVal Text)
  Dim TMP
  Dim Ch
  
  On Error Resume Next
  
  For TMP = 1 To Len(Text)
    Ch = Mid(Text, TMP, 1)
    If Asc(Ch) <> AscW(Ch) Then _
      Text = Left(Text, TMP - 1) & "-" & Mid(Text, TMP + 1)
  Next
  
  EscapeUnicodeChars = Text
End Function

'====================================================================
Private Function InsertGUID(ByVal FileName)
  Dim RC
  Dim GUID
  
  GUID = LCase(GetNewGUID())
  
  RC = InStrRev(FileName, ".")
  If RC = 0 Or RC = 1 Then
    FileName = FileName & " " & GUID
  Else
    FileName = Left(FileName, RC - 1) & _
               " " & GUID & Mid(FileName, RC)
  End If
  
  InsertGUID = FileName
End Function
