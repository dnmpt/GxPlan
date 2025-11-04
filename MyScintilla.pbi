;╔═══════════════════════════════════════════════════════════════════════════════╗
;║                     MyScintilla.pbi  - version 0.33-alpha                     ║
;╟───────────────────────────────────────────────────────────────────────────────╢
;║            Copyright 2021-2025  Duarte Mendes <duartenm@net.sapo.pt>          ║
;║                                                                               ║
;║ Permission is hereby granted, free of charge, To any person obtaining a copy  ║
;║ of this software And associated documentation files (the "Software"), To deal ║
;║ in the Software without restriction, including without limitation the rights  ║
;║ To use, copy, modify, merge, publish, distribute, sublicense, And/Or sell     ║
;║ copies of the Software, subject To the following conditions:                  ║
;║                                                                               ║
;║ The above copyright notice And this permission notice shall be included in    ║
;║ all copies Or substantial portions of the Software.                           ║     
;║                                                                               ║
;║ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,               ║
;║ EXPRESS Or IMPLIED, INCLUDING BUT Not LIMITED To THE WARRANTIES               ║
;║ OF MERCHANTABILITY, FITNESS For A PARTICULAR PURPOSE And NONINFRINGEMENT.     ║
;╟───────────────────────────────────────────────────────────────────────────────╢
;║ > PURPOSE :                                                                   ║
;║ Include file that handles Scintilla Gadget Operations.                        ║
;║                                                                               ║
;╚═══════════════════════════════════════════════════════════════════════════════╝ 
 

;Scintilla Constant for MARGING FOLDING
#MARGIN_SCRIPT_FOLD_INDEX = 1
#MARGIN_FOOTNOTE_FOLD_INDEX = 1

; Iniciação do Scintilla
;DEPRECATED  --------------------------->>>>>>>>>>>>>>>>>>       HandleMyError(InitScintilla(), "Não se consegue iniciar Scintilla!", 1)

;Message to collpase/expand folder - Margin 1 is sensitive
ScintillaSendMessage(Scintilla_0, #SCI_SETMARGINSENSITIVEN, #MARGIN_SCRIPT_FOLD_INDEX, #True)
ScintillaSendMessage(Scintilla_1, #SCI_SETMARGINSENSITIVEN, #MARGIN_SCRIPT_FOLD_INDEX, #True)


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>        SCINTILLA    PROCEDURES       <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure ScintillaCallBack(MyGadget, *scinotify.SCNotification)            ; Handles Scintilla in Notes
    
  Select *scinotify\nmhdr\code
    Case #SCN_MARGINCLICK
        Define modifiers = *scinotify\modifiers
        Define position = *scinotify\position
        Define margin = *scinotify\margin
        Define linenumber = ScintillaSendMessage(MyGadget, #SCI_LINEFROMPOSITION, position,0)
        
        If margin = #MARGIN_SCRIPT_FOLD_INDEX  ; alterna o fold na linha clicada
          ScintillaSendMessage(MyGadget, #SCI_TOGGLEFOLD, lineNumber, 0)
        EndIf
    Case #SCN_MODIFIED                                 ;Answers for Scintilla modifications
        Define Linhas.l =  ScintillaSendMessage(MyGadget, #SCI_GETLINECOUNT)
        Define Caracteres.l =  ScintillaSendMessage(MyGadget, #SCI_GETLENGTH)
        SetGadgetText(Txt_NotasLinhasChars, Str(Linhas) + " / " + Str(Caracteres))
  EndSelect
EndProcedure

;Read and Format text into Scintilla
Procedure MyScintillaText(MyGadget, MyText$ = "", MyFormat$ = "")
  
XIncludeFile("ScintillaStyles.pbi")                                                         ;>>>>>>>>>>>>> Scintilla STYLES FILE
  
  ScintillaSendMessage(MyGadget, #SCI_CLEARALL)                             ; Clear All Text
            
  Define *Text=UTF8(MyText$)
  ScintillaSendMessage(MyGadget, #SCI_SETTEXT, 0, *Text)
  FreeMemory(*Text) ; The buffer made by UTF8() has to be freed, to avoid memory leak
  
  ; Começa a aplicar a Formatação do texto no início do documento : posição "0"
  ScintillaSendMessage(MyGadget, #SCI_STARTSTYLING, 0)
  
  Protected x.l = 1
  Define xChar.s{1}
  Define xForm.s{1}
  
  For x.l = 1 To Len(MyFormat$)   ;Aplica a formatação caracter a caracter a partir do string de formatação
    
    xForm = Mid(MyFormat$,x,1)
    xChar = Mid(MyText$,x,1)
    
    Protected FormatCode.l = Val(xForm)
    Protected Linha = ScintillaSendMessage(MyGadget,#SCI_LINEFROMPOSITION, x - 1) ; Verifica a linha da posição do caracter
    
    ScintillaSendMessage(MyGadget, #SCI_SETSTYLING,1, FormatCode)               ; Aplica a formatação ao caracter
    
    If (xChar <> Chr(10)) And (xChar <> Chr(13)) And (xChar <> Chr(9))  ; Folding das linhas de título (não conta com caracteres de quebra de linha e TAB)
      If FormatCode = 3
        ScintillaSendMessage(MyGadget,#SCI_SETFOLDLEVEL, Linha, 99 | #SC_FOLDLEVELHEADERFLAG)     ; Aplica o Folding se for Título
      Else
        ScintillaSendMessage(MyGadget,#SCI_SETFOLDLEVEL, Linha, #SC_FOLDLEVELBASE)                ; Não aplica o Fold se não for Título ...
      EndIf
    EndIf
      
  Next x
  
EndProcedure

; SCINTILLA - Acquire a String with style codes for each character
Procedure.s GetScintillaFormat(MyGadget) 
  
  Protected NumChar.l = ScintillaSendMessage(MyGadget, #SCI_GETLENGTH)  ; Get Lenght of Scintilla Document
  Protected MyFormat$ = ""
  
  Protected x.l = 0
  
  For x = 0  To NumChar - 1                                          ; O último é o caracter "0" END
    MyFormat$ + Str(ScintillaSendMessage(MyGadget, #SCI_GETSTYLEAT,x))
  Next x      
  
  ProcedureReturn MyFormat$
  
EndProcedure

; SCINTILLA - Acquire All Text in the Document
Procedure.s GetScintillaAllText (MyGadget)
  
  Protected NumChar.l = ScintillaSendMessage(MyGadget, #SCI_GETLENGTH)  ; Gets the Lenght of All characthers in document (nLen)
  
  Protected *Text = AllocateMemory(NumChar + 1) ; Allocates memory to buffer (note : Memmory comsumption of a string is nLen + 1)           
  ScintillaSendMessage(MyGadget, #SCI_GETTEXT, NumChar + 1, *Text)   ; Gets UTF8 text to buffer with nLen size (including the 0 terminated)
  Protected text$ = PeekS(*Text, NumChar + 1, #PB_UTF8)                     ; Assign to a string.
  FreeMemory(*Text)
  
  ProcedureReturn text$

EndProcedure

; SCINTILLA - Format selected Text
Procedure FormatTextScintilla(MyGadget, FormatCode.l)
  
  Protected SelStart.l = ScintillaSendMessage(MyGadget, #SCI_GETSELECTIONSTART) ; Início da seleção de texto
  Protected SelEnd.l = ScintillaSendMessage(MyGadget, #SCI_GETSELECTIONEND)     ; Fim da seleção de texto
  Protected Tamanho.l = SelEnd - SelStart
  
  If Tamanho > 0
    ScintillaSendMessage(MyGadget, #SCI_STARTSTYLING,SelStart)                         ; Começa a formatação na posição do início da seleção
    ScintillaSendMessage(MyGadget, #SCI_SETSTYLING,Tamanho, FormatCode)                ; Formata com o estico FormatCode (ver acima os Styles - MyScintillaText)
  EndIf
  
  Protected LinhaInicio = ScintillaSendMessage(MyGadget,#SCI_LINEFROMPOSITION, SelStart)
  
  If FormatCode = 3
    ScintillaSendMessage(MyGadget,#SCI_SETFOLDLEVEL, LinhaInicio, 99 | #SC_FOLDLEVELHEADERFLAG)     ; Define a Linha de "Título" como Folded , Hierarquia = "99" !
  Else     
    Protected LinhaFim = ScintillaSendMessage(MyGadget,#SCI_LINEFROMPOSITION, SelEnd)   ; Define como hierarquia de folding "0" os outros formatos

    For Tamanho = LinhaInicio To LinhaFim           ;Reaproveitamento da variável Tamanho : Redefine a Hierarquia "0" de novo !
      ScintillaSendMessage(MyGadget,#SCI_SETFOLDLEVEL, Tamanho, #SC_FOLDLEVELBASE)
    Next Tamanho    
  EndIf
  
EndProcedure

;SCINTILLA - FOOTNOTE Style Gadget (small text size and automatic folding of text with '[#')
Procedure MyScintillaFootnote (MyGadget, MyText$ ="")
  
  XIncludeFile "ScintillaFootnote.pbi"
  
  ScintillaSendMessage(MyGadget, #SCI_CLEARALL)                             ; Clear All Text
            
  Define *Text=UTF8(MyText$)
  ScintillaSendMessage(MyGadget, #SCI_SETTEXT, 0, *Text)
  FreeMemory(*Text) ; The buffer made by UTF8() has to be freed, to avoid memory leak
   
  Protected x.l = FindString(MyText$, "[#")
  
  While x > 0
    Protected Linha.l = ScintillaSendMessage(MyGadget,#SCI_LINEFROMPOSITION, x - 1) ; Verifica a linha da posição do caracter
    Protected y.l = FindString(MyText$,Chr(10), x)
    If y = 0 
      y = Len(MyText$)
    EndIf
    ScintillaSendMessage(MyGadget, #SCI_STARTSTYLING,x - 1)  
    ScintillaSendMessage(MyGadget, #SCI_SETSTYLING, y - x +1, 1)               ; Aplica a formatação ao caracter
    ScintillaSendMessage(MyGadget,#SCI_SETFOLDLEVEL, Linha, 99 | #SC_FOLDLEVELHEADERFLAG)
    x = FindString(MyText$, "[#", x + 1)
  Wend
  
EndProcedure  

;SCINTILLA - CallBack for FOOTNOTES for Scrum
Procedure Callback_Scintilla_1(MyGadget, *scinotify.SCNotification)       ;Handles Scintilla in Scrum of FOOTNOTES
  
  Select *scinotify\nmhdr\code
    Case #SCN_MARGINCLICK  ; CallBack para ações na Margem
      
      Define modifiers = *scinotify\modifiers
      Define position = *scinotify\position
      Define margin = *scinotify\margin
      Define linenumber = ScintillaSendMessage(MyGadget, #SCI_LINEFROMPOSITION, position,0)
    
      If margin = #MARGIN_FOOTNOTE_FOLD_INDEX                                           ;Answers to this Margin Folder clicks        
        ScintillaSendMessage(MyGadget, #SCI_TOGGLEFOLD, linenumber, 0)       
      EndIf
    Case #SCN_DOUBLECLICK   ;Answers for Scintilla modifications  
      If ScintillaSendMessage(MyGadget, #SCI_GETLENGTH) = 0
        If MessageRequester("Questão ?","Quer introduzir um template ?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes
          
          ;TEMPLATE for Scrum
          Protected SCN_Texto$ = "[#1] O que fiz ontem ?" + #CRLF$ + #CRLF$ + #CRLF$ + #CRLF$ + "[#2] O que vou fazer hoje ?" + #CRLF$ + #CRLF$ + #CRLF$ + #CRLF$ + "[#3] Quais são os obstáculos ?"+ #CRLF$ + #CRLF$ + #CRLF$        
          
          MyScintillaFootnote(MyGadget, SCN_Texto$)
        EndIf
      EndIf    
  EndSelect  
  
EndProcedure

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 35
; Folding = --
; EnableXP