;+-------------------------------------------------------------------------------+
;¦                    GxPlan_Main.pb  - version 0.33-alpha                       ¦
;¦-------------------------------------------------------------------------------¦
;¦            Copyright 2021-2025  Duarte Mendes <duartenm@net.sapo.pt>          ¦
;¦                                                                               ¦
;¦ Permission is hereby granted, free of charge, To any person obtaining a copy  ¦
;¦ of this software And associated documentation files (the "Software"), To deal ¦
;¦ in the Software without restriction, including without limitation the rights  ¦
;¦ To use, copy, modify, merge, publish, distribute, sublicense, And/Or sell     ¦
;¦ copies of the Software, subject To the following conditions:                  ¦
;¦                                                                               ¦
;¦ The above copyright notice And this permission notice shall be included in    ¦
;¦ all copies Or substantial portions of the Software.                           ¦     
;¦                                                                               ¦
;¦ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,               ¦
;¦ EXPRESS Or IMPLIED, INCLUDING BUT Not LIMITED To THE WARRANTIES               ¦
;¦ OF MERCHANTABILITY, FITNESS For A PARTICULAR PURPOSE And NONINFRINGEMENT.     ¦
;¦-------------------------------------------------------------------------------¦
;¦ > PURPOSE :                                                                   ¦
;¦ Main source code for Program GxPlan - Plan in Compliance # Includes Main Loop ¦
;¦ and event handling.                                                           ¦
;+-------------------------------------------------------------------------------+ 

; Condições gerais
EnableExplicit
UseSQLiteDatabase()

Global Window_0    ; Variável aqui para o Scintilla
Global Txt_NotasLinhasChars

;Include files de Topo (Erros e Forms!)
XIncludeFile("Geral.pbi")
XIncludeFile("Form_Tarefas.pbi")
XIncludeFile("MyScintilla.pbi")

;Enumeração de constantes ID para objetos
Enumeration
  #MyFile
  #MyDATABASE
EndEnumeration

;Estruturas
Structure Scrum
  ScrumID.l
  Sprint.s
  ScrumInicio.l
  ScrumFim.l
  ScrumFeito.b
  ScrumFeitoDef.s
  ScrumLog.s
EndStructure

Structure Tipo
  TipoID.l
  TipoNome.s
EndStructure

Structure Projeto
  ProjetoID.l
  TipoIDD.l
  ProjetoNome.s
  ProjetoInicio.l
  ProjetoFim.l
  ProjetoFeito.b
EndStructure

Structure Tarefa
  TarefaID.l
  ProjetoIDD.l
  TarefaNome.s
  Valor.b
  Compliance.b
  Urgencia.b
  Esforco.b
  Prioridade.f
  Custo.l
  Feito.b
  DataInicio.l
  DataFim.l
EndStructure

Structure Schedule
  ScheduleID.l
  Date.l
  Hour.l
  TaskID.l
EndStructure

;Constantes
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered ; Flags para as Windows - operador bitwise para as combinar bit a bit

;Variáveis
Global DatabaseFile$ = ""
Global OldDatabaseFile$ = ""
Global Quit.b = #False
Global NewList TiposLista.Tipo()
Global NewList ProjetosLista.Projeto()
Global NewList TarefasLista.Tarefa()
Global NewList MySchedule.Schedule()
Global NewList ScrumLista.Scrum()
Global DatabaseConnected.b = #False


; --------------------------------------  Include Files de Procedimentos -----------------------------------------------------------

XIncludeFile("UpdateTabs.pb"); >>>>>>>>>>>>>>>>>>>>>>>>>>   Update Tabs do Panel_0

; >>>>>>>>>>>>>>>>> Procedimentos de Gadgets aqui


XIncludeFile("Ficheiro.pb")  ; >>>>>>>>>>>>>>>>>>>>>>>>>>   Operações na Base de Dados
;Procedimentos de salvar/apagar/novo na Base de Dados aqui !!!!


;--------------------------------------------------------- EVENTOS -----------------------------------------------------------------
Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow ;-------------------- Eventos gerais -----------------
      If DatabaseConnected = #True
        HandleMyError(CloseDatabase(#MyDATABASE), "Erro ao fechar a Base de Dados !", 1)           
      EndIf
      ProcedureReturn #True
      
    Case #PB_Event_Menu ;---------------------- Itens do Menu -----------------------
      Select EventMenu()
        Case #MenuItem_1
          CriarBaseDados()        
        Case #MenuItem_2
          AbrirBaseDados()          
        Case #MenuItem_3
          If DatabaseConnected = #True
            HandleMyError(CloseDatabase(#MyDATABASE), "Erro ao fechar a Base de Dados !", 1)           
          EndIf
          ProcedureReturn #True
        Case #MenuItem_4
          SetGadgetState(Panel_0,2)
         Case #MenuItem_10
          SetGadgetState(Panel_0,3)         
        Case #MenuItem_14
          MessageRequester("Acerca","          +++++  GxPlan  +++++" + #CRLF$ + "                Plan in Compliance" + #CRLF$  + #CRLF$+ "      versão 0.33-alpha  #20251104" + #CRLF$ + #CRLF$ + "Copyright (c) 2021-2025 by Duarte Mendes", #PB_MessageRequester_Info | #PB_MessageRequester_Ok)
        Case #MenuItem_29
          MessageRequester("Scintilla", "                This software uses Scintilla" + #CRLF$ + #CRLF$ + "Copyright 1998-2003 by Neil Hodgson <neilh@scintilla.org>" + #CRLF$ + "                  All Rights Reserved",#PB_MessageRequester_Info | #PB_MessageRequester_Ok)         
        Case #MenuItem_19
          Ordenar(1)
        Case #MenuItem_20
          Ordenar(2)   
        Case #MenuItem_21
          Ordenar(3)
        Case #MenuItem_22
          Ordenar(4)             
        Case #MenuItem_23
          Ordenar(5)             
        Case #MenuItem_24
          Ordenar(6)            
        Case #MenuItem_25
          Ordenar(7)             
        Case #MenuItem_26
          Ordenar(8)             
        Case #MenuItem_27
          Ordenar(9)             
        Case #MenuItem_28
          Ordenar(10)             
      EndSelect
      
    Case #PB_Event_Gadget ; -------------------------- GADGETS -----------------------
      Select EventGadget()
        Case Panel_0 ; --- PANEL
          Select GetGadgetState(Panel_0)
            Case 0 : UpdateTabDia()
            Case 1 :               
            Case 2 : UpdateTabProjetos(GetGadgetState(ListaProjetos),GetGadgetState(ListaTarefasProj))
            Case 3 : 
              SetGadgetState(#Opt_SortAll, 1)
              UpdateTabTarefas()
            Case 4 : UpdateNotas()
            Case 5 :
            Case 6 : UpdateTimelinesProjetos()
          EndSelect
        Case #Opt_SortDone, #Opt_SortUnDone, #Opt_SortRel, #Opt_SortAll  ; Todos os botões de opção na Tarefa
          UpdateListaTarefas(LsI_Tarefas)
          UpdateTabTarefas()
        Case LsI_Tarefas
          Select EventType()
            Case #PB_EventType_Change
              UpdateListaTarefas(LsI_Tarefas)
              UpdateTabTarefas()
          EndSelect
        Case LsI_Notas
          Select EventType()
            Case #PB_EventType_Change
              If GetGadgetState(LSI_Notas) >= 0
                HideGadget(#ImgNotesNew, 1)
                HideGadget(#ImgNotesOld, 0)
                DisplayNote()
              Else
                HideGadget(#ImgNotesNew, 0)
                HideGadget(#ImgNotesOld, 1)
              EndIf
          EndSelect
          Case #LsI_TimeProj
          Select EventType()
            Case #PB_EventType_Change
              If GetGadgetState(#LsI_TimeProj) < 1
                SetGadgetState (#LsI_TimeProj, 1)
              EndIf
              UpdateTimelinesTasks()
            Case #PB_EventType_LeftDoubleClick
              DoubleClickProj()             
          EndSelect
        Case #LsI_TimeTask
          Select EventType()
            Case #PB_EventType_LeftDoubleClick
              DoubleClickTask()
          EndSelect           
        Case Cob_Scrum
          Select EventType()
            Case #PB_EventType_Change
              UpdateScrum()
          EndSelect
        Case TaskBtnNovo          
          Nova_Tarefa()
        Case TaskBtnApagar
          Apagar_Tarefa()
        Case TaskBtnSubscrever
          Subscrever_Tarefa()
        Case #Button_0
          Apagar_Projeto() ; >>> Apagar Projeto
        Case #Button_1      ; >>> Subescrever Projeto
          Subscrever_Projeto()
        Case #Button_2
          Novo_Projeto() ; >>> Novo Projeto
        Case Date_Proj_f ; >>> Data de Fim do Projeto
          If GetGadgetState(Date_Proj_f) < GetGadgetState(Date_Proj_i)
            MessageRequester("Info","A data de conclusão deve ser posterior à de início!", #PB_MessageRequester_Warning)
            SetGadgetState(Date_Proj_f, GetGadgetState(Date_Proj_i))
          EndIf
        Case Date_Proj_i; >>> Data de Inicio do Projeto
          If GetGadgetState(Date_Proj_i) > GetGadgetState(Date_Proj_f)
            MessageRequester("Info","A data de início deve ser anterior à de fim!", #PB_MessageRequester_Warning)
            SetGadgetState(Date_Proj_i, ProjetosLista()\ProjetoInicio)
          EndIf
         Case Date_1 ; >>> Data de Fim da Tarefa
          If GetGadgetState(Date_1) < GetGadgetState(Date_0)
            MessageRequester("Info","A data de conclusão deve ser posterior à de início!", #PB_MessageRequester_Warning)
            SetGadgetState(Date_1, GetGadgetState(Date_0))
          EndIf
          
        Case Date_0; >>> Data de Inicio da Tarefa
          If GetGadgetState(Date_0) > GetGadgetState(Date_1)
            MessageRequester("Info","A data de início deve ser anterior à de fim!", #PB_MessageRequester_Warning)
            SetGadgetState(Date_0, TarefasLista()\DataInicio)
          EndIf         
                  
        Case TipoCombo; --- Lista de Tipos de Projeto / ComboBox
          UpdateTabProjetos() 
           Case LsI_Dia; --- Icons de Projetos / ListIcon
          Select EventType()
            Case #PB_EventType_Change
              UpdateListaTarefas(LsI_Dia)
              UpdateTabDia()              
          EndSelect         
        Case ListaProjetos; --- Icons de Projetos / ListIcon
          Select EventType()
            Case #PB_EventType_Change
              UpdateTabProjetos(GetGadgetState(ListaProjetos),GetGadgetState(ListaTarefasProj))               
          EndSelect
        Case ListaTarefasProj; --- Lista de Tarefas na Aba de Projetos / ListIcon
          Select EventType()
            Case #PB_EventType_Change
              UpdateCheckTarefa()
              UpdateTabProjetos(GetGadgetState(ListaProjetos),GetGadgetState(ListaTarefasProj))  
          EndSelect     
        Case TrackBar_1
          TrackBarUpdate(1,TrackBar_1,#TaskValor,GetGadgetState(TrackBar_1))
        Case TrackBar_2
          TrackBarUpdate(2,TrackBar_2,#TaskUrgencia,GetGadgetState(TrackBar_2))
        Case TrackBar_3
          TrackBarUpdate(3,TrackBar_3,#TaskCompliance,GetGadgetState(TrackBar_3))
        Case TrackBar_4
          TrackBarUpdate(4,TrackBar_4,#TaskEsforco,GetGadgetState(TrackBar_4))
        Case #Btn_HoraAdd
          AddHorario()
        Case LsI_Horas
          Select EventType()
            Case #PB_EventType_Change
              NoDeselection(LsI_Horas,7)
          EndSelect
        Case #Btn_HoraDel
          DelHorario()
        Case Btn_Finish
          TaskDiaFeito()
        Case Btn_Timer
          ParaImplementar()
        Case Calendar_0
           Select EventType()
            Case #PB_EventType_LeftClick
              SelecionaData()
          EndSelect
                                              ; Botões das Notas
        Case #Btn_Sct_Normal          
          FormatTextScintilla(Scintilla_0, 0)
        Case #Btn_Sct_Bold      
          FormatTextScintilla(Scintilla_0, 1)
        Case #Btn_Sct_Italic         
          FormatTextScintilla(Scintilla_0, 2)
        Case #Btn_Sct_Title   
          FormatTextScintilla(Scintilla_0, 3)
        Case #Btn_Sct_Code        
          FormatTextScintilla(Scintilla_0, 4)
        Case #Btn_Sct_Highl          
          FormatTextScintilla(Scintilla_0, 5)
        Case #Btn_sct_OK
          OK_Nota()
        Case #Btn_sct_Apagar
          Apagar_Nota()
                                                ; Botões do Scrum    
        Case #Btn_OKScrum
          OK_Sprint()
        Case #Btn_DelScrum
          Del_Sprint()
          
        Case #TaskScrumAdd
          AddTaskToScrum()
          
      EndSelect
      
  EndSelect
  ProcedureReturn #False
EndProcedure

;--------------------------------------------------------- MAIN LOOP -----------------------------------------------------------------
OpenWindow_0()

Arranque()

Repeat
  Define MyEvent.l = WaitWindowEvent()  ;Espera um evento
  Quit = Window_0_Events(MyEvent)
Until Quit = #True     ;Fim do loop principal. Termina com o fecho da janela...   
   
End
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 1
; Folding = -
; EnableXP
; Executable = proBLESS_v032b.exe
; CompileSourceDirectory