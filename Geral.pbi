; INCLUDE FILE
; PROCEDIMENTOS GERAIS
; VERSÃO 1.0
; 17/06/2021

; Handles any SYSTEM error that occurs
Procedure ErrorHandler()
  Protected ErrorMsg.s = "Error code:" + #TAB$ + Str(ErrorCode()) + #CRLF$
  ErrorMsg + "Error description:" + #TAB$ + ErrorMessage() + #CRLF$
  ErrorMsg + "Occured on line:" + #TAB$ + Str(ErrorLine()) + #CRLF$
  ErrorMsg + "Occured on file:" + #TAB$ + ErrorFile() + #CRLF$
  ErrorMsg + #CRLF$ + "The program will now EXIT !"
  Protected AnswerBox.l = MessageRequester("ERROR", ErrorMsg, #PB_MessageRequester_Ok!#PB_MessageRequester_Error)
EndProcedure ; Program will always exit on ending the procedure ErrorHandler


; Handles any I/O error that occurs
Procedure HandleMyError (Result.l, ErrorMsg.s, Critical.l = 0) ; Opcional 'Critical.l = 0' (= Não, pode-se escolher continuar)
  If Result = 0
    If Critical = 0
      Protected AnswerBox.l = MessageRequester("ERRO", ErrorMsg + #CRLF$ + #CRLF$ + "Deseja continuar ?", #PB_MessageRequester_YesNo|#PB_MessageRequester_Error)
      If AnswerBox = #PB_MessageRequester_No
        End ; Ends program
      Else
        ProcedureReturn #True ;Devolve o falor de Verdadeiro a sinalizar que houve erro e se continuou !
      EndIf
    Else
      AnswerBox.l = MessageRequester("ERRO Crítico", ErrorMsg + #CRLF$ + #CRLF$ + "Erro Crítico !" + #CRLF$ + #CRLF$ + "O programa vai sair...", #PB_MessageRequester_Ok|#PB_MessageRequester_Error)
      End
    EndIf
  EndIf
  ProcedureReturn #False ; Devolve o valor de Falso a sinalizar que não houve erro !
EndProcedure


; Handles DataBase operations check
Procedure CheckDatabaseUpdate(Database, Query$)
   Protected Result = DatabaseUpdate(Database, Query$)
   If Result = 0
     Protected Erro$ = DatabaseError()
      MessageRequester("Erro",Erro$,#PB_MessageRequester_Ok)
   EndIf
   ProcedureReturn Result
 EndProcedure
 
 
;Não deixa DESELECIONAR um objeto List(ListIcon
 Procedure NoDeselection(MyGadget , ByDefault.l)
   If GetGadgetState(MyGadget) <0
     SetGadgetState(MyGadget,ByDefault)
   EndIf   
 EndProcedure
 
 ; Procura um texto removendo os caracteres especiais antes e depois
 Procedure.s RemoveSpecialChars(MyText$)
   
   Protected Char1.s{1} = MyText$                        ; String de 1 caracter para ver o primeiro caracter de NotaResumo
   
   While (Char1 = Chr(10)) Or (Char1 = Chr(13)) Or (Char1 = " ")  ;Remove os caracteres fim de linha no início ...
     MyText$ = LTrim(MyText$, Chr(10))                      ;#LF
     MyText$ = LTrim(MyText$, Chr(13))                      ;#CR
     MyText$ = LTrim(MyText$)                               ; SPACE
     Char1 = MyText$
   Wend
   
   If FindString(MyText$, Chr(10), 1) <> 0
     MyText$ = Mid(MyText$, 1,FindString(MyText$, Chr(10), 1) - 1) ; Só mostra até fim de linha chr(10) : #LF
   EndIf
   
   If FindString(MyText$, Chr(13), 1) <> 0
     MyText$ = Mid(MyText$, 1,FindString(MyText$, Chr(13), 1) - 1) ; Só mostra até fim de linha chr(13) : #CR
   EndIf
   
   If MyText$ ="" : MyText$ = "Sem descrição" : EndIf   ; Se não encontrar nenhum caracter de fim de linha chr(10) ou chr(13)
   
   ProcedureReturn MyText$
 EndProcedure   
 
 
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 47
; FirstLine = 30
; Folding = -
; EnableXP