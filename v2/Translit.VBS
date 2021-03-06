Option Explicit

'====================================================================
Public Function TranslitText(ByVal Text)
  Dim TMP
  Dim TXT
  Dim RusChars
  Dim TransChars
  Dim Ch
  Dim Idx
  Dim Found
  
  TXT = ""
  
  ' Таблицы транслитирации. Ищем в первом массиве, берём замену из 
  ' второго. Тупо и ясно ^^
  RusChars = Array("а", "б", "в", "г", "д", "е", "ё", "ж", "з", _
                   "и", "й", "к", "л", "м", "н", "о", "п", "р", _
                   "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", _
                   "ь", "ы", "ъ", "э", "ю", "я")
  TransChars = Array("a", "b", "v", "g", "d", "e", "yo", "j", "z", _
                     "i", "iy", "k", "l", "m", "n", "o", "p", "r", _
                     "s", "t", "u", "f", "h", "ts", "ch", "sh", _
                     "sh", "", "i", "", "e", "yu", "ya")
  
  For TMP = 1 To Len(Text)
    Ch = Mid(Text, TMP, 1)
    Idx = InArray(RusChars, LCase(Ch), Found)
    
    If Found Then
      If Ch = UCase(Ch) Then
        TXT = TXT & MyUCase(TransChars(Idx))
      Else
        TXT = TXT & TransChars(Idx)
      End If
    Else
      TXT = TXT & Ch
    End If
  Next
  
  TranslitText = TXT
End Function

'====================================================================
' Эмуляция StrConv(..., vbProperCase)
' Делается с учётом того что у нас будут только одна или две буквы.
'====================================================================
Private Function MyUCase(ByVal Text)
  If Len(Text) > 0 Then
    MyUCase = UCase(Left(Text, 1)) & Mid(Text, 2)
  End If
End Function

'====================================================================
' Укороченная версия функции из CommonFunctions.DLL
'====================================================================
Private Function InArray(ByRef ArrayX, _
                         ByVal FindWhat, _
                         ByRef lpIsFound)
  Dim TMP
  
  lpIsFound = False
  InArray = LBound(ArrayX) - 1
  
  For TMP = LBound(ArrayX) To UBound(ArrayX)
    If ArrayX(TMP) = FindWhat Then
      lpIsFound = True
      InArray = TMP
      Exit Function
    End If
  Next
End Function
