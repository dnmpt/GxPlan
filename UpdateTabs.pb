;+-------------------------------------------------------------------------------+
;¦                      UpdateTabs.pb  - version 0.33-alpha                      ¦
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
;¦ Updates tabs and included gadgets for GxPlan - Plan in Compliance.            ¦
;¦                                                                               ¦
;+-------------------------------------------------------------------------------+ 


Procedure UpdateStatusBar()
  Protected Texto$ = "Tipo | Projecto > Tarefa: " + TiposLista()\TipoNome + " | " + ProjetosLista()\ProjetoNome + " > "+ TarefasLista()\TarefaNome
  
  If ListSize(ScrumLista()) > 0
    Texto$ + " | Sprint SCRUM : " + ScrumLista()\Sprint
  Else
    Texto$ + " | Sprint SCRUM : <?>"
  EndIf
  StatusBarText(0,0,Texto$)
EndProcedure


;---------------------------------------- Atualização da TAB de Projetos (#2) ---------------------------------

;---- SELEÇÃO DOS ICONS DE PROJETO E TAREFAS CORRESPONDENTES ----
 Procedure UpdateTabProjetos(selecaoP.l = 0, selecaoT.l = 0) 
   Static ProjPos.l
   Static TaskPos.l 
   
   ;-------------------------------   Mantém a seleção das List Icon Gadgets -------------
   If selecaoP > -1        ; Impossibilita a deseleção total
     ProjPos = selecaoP
   Else
     selecaoP = ProjPos
   EndIf
   
   If selecaoT > -1        ; Impossibilita a deseleção total
     TaskPos = selecaoT
   Else
     selecaoT = TaskPos
   EndIf   
   ;-------------------------------   Limpa os List Icon Gadgets e atribui o Estado ao Tipo -------------      

   ClearGadgetItems(ListaProjetos)
   ClearGadgetItems(ListaTarefasProj)
   ClearGadgetItems(TaskProjeto)
   SelectElement(TiposLista(),GetGadgetState(TipoCombo))
   
   ;-------------------------------   List Icon Projetos redraw -------------
   If LoadImage(0,"icons\project.bmp")     ; change path/filename to your own 32x32 pixel image
     SetGadgetAttribute(ListaProjetos, #PB_ListIcon_DisplayMode, #PB_ListIcon_LargeIcon)
     HandleMyError(LoadImage(1,"icons\task.bmp"),"Imagem não carregada!",1)
     Define x.l = 0
     Define y.l = -1
     Define c.l = 0
     
     ForEach ProjetosLista()
       If TiposLista()\TipoID = ProjetosLista()\TipoIDD
         Define Texto$ = ProjetosLista()\ProjetoNome
         If ProjetosLista()\ProjetoFeito > 0
           AddGadgetItem(ListaProjetos, -1, Texto$, ImageID(0))          
         Else
           AddGadgetItem(ListaProjetos, -1, Texto$, ImageID(1))           
         EndIf
          y + 1
          If y = selecaoP
            c = x
          EndIf
        EndIf
        x + 1
     Next
     SetGadgetState(ListaProjetos, selecaoP)
     SelectElement(ProjetosLista(), c)
   EndIf
   SetGadgetText(ProjStrNome,ProjetosLista()\ProjetoNome)
   SetGadgetState(Date_Proj_i,ProjetosLista()\ProjetoInicio)
   SetGadgetState(Date_Proj_f,ProjetosLista()\ProjetoFim)
   If ProjetosLista()\ProjetoFeito > 0
     SetGadgetState(Chk_Proj_Terminado,#PB_Checkbox_Checked)
   Else
     SetGadgetState(Chk_Proj_Terminado,#PB_Checkbox_Unchecked)
   EndIf
   
     Define x.l = 0
     Define y.l = -1
     Define c.l = 0
     Define progresso.l = 0
   ;-------------------------------   List Icon Tarefas redraw -------------
   If CountGadgetItems(ListaProjetos) > 0  
     ForEach TarefasLista()
       If TarefasLista()\ProjetoIDD = ProjetosLista()\ProjetoID
         Texto$ = Str(TarefasLista()\TarefaID) + Chr(10)
         Texto$ + TarefasLista()\TarefaNome + Chr(10) + Str(TarefasLista()\Esforco) + Chr(10) + StrF(TarefasLista()\Prioridade,1)
         Texto$  + Chr(10) + Str(TarefasLista()\Custo)
         If TarefasLista()\DataInicio <> 0
           Texto$ + Chr(10) + FormatDate("%dd/%mm/%yyyy", TarefasLista()\DataInicio)
         Else
           Texto$ + Chr(10) + ""
         EndIf
         If TarefasLista()\DataFim <> 0               
           Texto$ + Chr(10) + FormatDate("%dd/%mm/%yyyy", TarefasLista()\DataFim)
         EndIf
         AddGadgetItem(ListaTarefasProj, -1, Texto$)
          y + 1
          If TarefasLista()\Feito = 1
            SetGadgetItemState(ListaTarefasProj, y, #PB_ListIcon_Checked)
            progresso + 1
         EndIf
         If y <= selecaoT
            c = x
         EndIf  
       EndIf
       x + 1
     Next
     ; Atualiza a Progress Bar do Projeto
     progresso = Int(progresso/CountGadgetItems(ListaTarefasProj)*100)
     SetGadgetState(PrBar_Proj,progresso)
     SetGadgetText(#Text_5, "Progresso ("+Str(progresso)+"%)")
     If y > SelecaoT
       y = selecaoT
     EndIf
   Else
     SetGadgetState(PrBar_Proj,0) ; Progress Bar do Projeto fica vazia sem items
     SetGadgetText(#Text_5, "Progresso (0%)")
   EndIf
   
   SetGadgetItemColor(ListaTarefasProj, y,#PB_Gadget_BackColor, #Blue)
   SetGadgetItemColor(ListaTarefasProj, y,#PB_Gadget_FrontColor, #White)
   SelectElement(TarefasLista(), c)
   UpdateStatusBar()
EndProcedure 


Procedure UpdateCheckTarefa() ;---- ATUALIZAR O CHECK NAS TAREFAS DO PROJETO -------------
  Define x.l = CountGadgetItems(ListaTarefasProj) 
  
  If DatabaseConnected = #True  
    x = 0
    While x < CountGadgetItems(ListaTarefasProj)
      If GetGadgetItemState(ListaTarefasProj, x) = #PB_ListIcon_Checked
        Define check.l = 1
      Else
        Define check.l = 0
      EndIf
      Define Texto$ = GetGadgetItemText(ListaTarefasProj, x)
      ForEach TarefasLista()
        If TarefasLista()\TarefaID = Val(Texto$)
          If check <> TarefasLista()\Feito
            Texto$ = "UPDATE TarefasDB SET TaskFeito = '" + Str(check)+"' WHERE TaskID = '" + Str(TarefasLista()\TarefaID)+"'"
            CheckDatabaseUpdate(#MyDatabase, Texto$)
            TarefasLista()\Feito = check
          EndIf
        EndIf
      Next
      x + 1
    Wend
    
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf
  
EndProcedure


;---------------------------------------- Atualização da TAB NOTAS (#4) ---------------------------------
Procedure UpdateNotas(necessario.l = 0)
  
  Static LastFile.s
  Static LastTask.l
  Define OldSel.l = -1
  
  If (TarefasLista()\TarefaID <> LastTask) Or (DatabaseFile$ <> LastFile) Or necessario <> 0
    If necessario <> 0
      OldSel.l = GetGadgetState(LsI_Notas)
    Else      
      LastFile = DatabaseFile$
      LastTask = TarefasLista()\TarefaID
      SetGadgetText(#TxtTaskNotes, "Notas da tarefa : " + TarefasLista()\TarefaNome)
    EndIf
    
      ClearGadgetItems(LsI_Notas)
    
    If DatabaseConnected = #True
      If DatabaseQuery(#MyDATABASE, "SELECT * FROM NotasDB WHERE TarefasIDD = '" + TarefasLista()\TarefaID+"'")      
        While NextDatabaseRow(#MyDATABASE)
          Define NotasID.l = GetDatabaseLong(#MyDATABASE, 0)
          Define TarefasIDD.l = GetDatabaseLong(#MyDATABASE, 1)
          Define DataInicial.l = GetDatabaseLong(#MyDATABASE, 2)
          Define DataModificado.l = GetDatabaseLong(#MyDATABASE, 3)                   
          Define Nota.s = GetDatabaseString(#MyDATABASE, 4)
          Define Formato.s = GetDatabaseString(#MyDATABASE, 5)                  
          
          Define NotaResumo.s{115} = RemoveSpecialChars(Nota)      ; Resumo da Nota (primeiros 115 caracteres que cabem na linha)
          
          AddGadgetItem(LsI_Notas,-1,Str(NotasID) + Chr(10) + FormatDate("%dd/%mm/%yyyy", DataInicial) + Chr(10) + FormatDate("%dd/%mm/%yyyy", DataModificado) + Chr(10) + NotaResumo)
        Wend
        FinishDatabaseQuery(#MyDATABASE)
      EndIf
    EndIf
    SetGadgetState(LsI_Notas, OldSel)
  EndIf
        
EndProcedure;


;---------------------------------------- Atualização da TAB de TAREFAS (#3) ---------------------------------
;Update de Formatação da Prioridade
Procedure UpdatePrioridade(valor.f)
  
  Select valor
    Case 18 To 20
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_FrontColor, #White)
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_BackColor, #Red)
    Case 15 To 17
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_FrontColor, #Blue)
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_BackColor, #Yellow) 
    Case 10 To 14
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_FrontColor, #Black)
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_BackColor, #Cyan)
    Default
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_FrontColor, #Gray)
      SetGadgetColor(#TaskPrioridade,  #PB_Gadget_BackColor, #White)
  EndSelect      
  SetGadgetText(#TaskPrioridade,StrF(Valor,1))  
EndProcedure  

;Update das TrackBars das componentes do cálculo da Prioridade
Procedure TrackBarUpdate(TrackBarIndex.l, MyTrackBar.d, MyTextGasget.l, MyStatus.l)
  Define Texto$ = ""
  Define Prioridade.f = 20
  Dim Estado.s (5,5) ; Array de estados possíveis para 4 TrackBars vs 5 Status do Gadget  : (0,0) - não usado
  
  Estado(1,1) = "Insignificante" : Estado(1,2) = "Significante" : Estado(1,3) = "Importante" : Estado(1,4) = "Relevante" : Estado(1,5) = "Elevado!"
  Estado(2,1) = "Sem data" : Estado(2,2) = "Adiável" : Estado(2,3) = "Urgente" : Estado(2,4) = "Urgentíssima" : Estado(2,5) = "Faz agora!"
  Estado(3,1) = "Nenhuma" : Estado(3,2) = "Aplicável" : Estado(3,3) = "Impacto" : Estado(3,4) = "Consequência" : Estado(3,5) = "Crítica!"
  Estado(4,1) = "Fácil" : Estado(4,2) = "Acessível" : Estado(4,3) = "Moderada" : Estado(4,4) = "Difícil" : Estado(4,5) = "Laboriosa!"
  
  Select MyStatus
    Case 5
      SetGadgetColor(MyTextGasget,  #PB_Gadget_FrontColor, #White)
      SetGadgetColor(MyTextGasget,  #PB_Gadget_BackColor, #Red)
    Case 4
      SetGadgetColor(MyTextGasget,  #PB_Gadget_FrontColor, #Blue)
      SetGadgetColor(MyTextGasget,  #PB_Gadget_BackColor, #Yellow) 
    Case 2 , 3
      SetGadgetColor(MyTextGasget,  #PB_Gadget_FrontColor, #Black)
      SetGadgetColor(MyTextGasget,  #PB_Gadget_BackColor, #Cyan)
    Default
      SetGadgetColor(MyTextGasget,  #PB_Gadget_FrontColor, #Gray)
      SetGadgetColor(MyTextGasget,  #PB_Gadget_BackColor, #White)
  EndSelect           

  Texto$ = Estado(TrackBarIndex,GetGadgetState(MyTrackbar))
  SetGadgetText(MyTextGasget,Texto$)
  
  ;Fórmula de cálculo da Prioridade
  Prioridade = (GetGadgetState(TrackBar_4) + 2*GetGadgetState(TrackBar_2) + 3*GetGadgetState(TrackBar_3))/1.5 + GetGadgetState(TrackBar_1) - 5
  UpdatePrioridade(Prioridade)
EndProcedure


Procedure SelecionaTipoProj()
   Define c.l = 0
  Define x.l = 0
  
  ClearGadgetItems(TaskProjeto)
  
  ForEach ProjetosLista()
    AddGadgetItem(TaskProjeto, -1, ProjetosLista()\ProjetoNome)
    If TarefasLista()\ProjetoIDD = ProjetosLista()\ProjetoID
      x = ListIndex(ProjetosLista())
    EndIf
  Next
  
  SelectElement(ProjetosLista(),x) 

  ForEach TiposLista()
    If ProjetosLista()\TipoIDD = TiposLista()\TipoID
      c = ListIndex(TiposLista())
    EndIf
  Next
  
  SelectElement(TiposLista(),c)
  
  SetGadgetState(TipoCombo,c)
  SetGadgetState(TaskProjeto,x)
  
EndProcedure


; Atualiza o Panel_0/#3 TAREFAS
Procedure UpdateTabTarefas()

  
  ClearGadgetItems(LsI_Tarefas)
  
  SelecionaTipoProj()
  
  Define y.l = TarefasLista()\TarefaID
  Define i.l = ListIndex(TarefasLista())
  Define x = -1
  Define c = 0
  
  ; Escolha dos botões de opção de filtragem
  ForEach  TarefasLista()
    
    Define Texto$ = Str(TarefasLista()\TarefaID)
    Texto$ + Chr(10) + TarefasLista()\TarefaNome + Chr(10) + StrF(TarefasLista()\Prioridade,1)
    
    If TarefasLista()\Feito = 1
      Texto$ + Chr(10) + "X" +Chr(10);Não adicionada ao Dia
    Else
      Texto$ + Chr(10)+ Chr(10)
      If Int(TarefasLista()\DataInicio/3600/24) <= Int(Date()/3600/24)                     ; Tarefas no mesmo dia INT - parte inteira do dia !
        Texto$ + "X" + Chr(10)                                                                       ;Adiciona X ao Dia
      Else
        Texto$ + "" + Chr(10)
      EndIf   
    EndIf   
    
    ; Inclui informação do Scrum
    If DatabaseConnected = #True
      Define TextoScrum$ = ""
      
      #TextoForQuery = "SELECT Sprint from ScrumDB as a INNER JOIN ScrumBoardDB as b ON a.ScrumID = b.ScrumID WHERE b.Task = '"    
      If DatabaseQuery(#MyDATABASE, #TextoForQuery + Str(TarefasLista()\TarefaID) +"'" )        
        While NextDatabaseRow(#MyDATABASE)      
          TextoScrum$ + Mid(GetDatabaseString(#MyDATABASE, 0),1,37) + " ; "
        Wend
        FinishDatabaseQuery(#MyDATABASE)
      EndIf
    EndIf
    Texto$ + TextoScrum$
    
    ; Filtragem dos botões de seleção
    If (GetGadgetState(#Opt_SortRel) = 1) And (TarefasLista()\ProjetoIDD = ProjetosLista()\ProjetoID); Caso opção de Relacionadas
        AddGadgetItem(LsI_Tarefas,-1,Texto$)
        x + 1
    EndIf
    
    If (GetGadgetState(#Opt_SortDone) = 1) And (TarefasLista()\Feito = 1) ; Caso Opção de Concluídas
      AddGadgetItem(LsI_Tarefas,-1,Texto$)
      x + 1        
    EndIf
    
    If (GetGadgetState(#Opt_SortUnDone) = 1) And (TarefasLista()\Feito = 0) ; Caso Opção de Em Curso
      AddGadgetItem(LsI_Tarefas,-1,Texto$)
      x + 1        
    EndIf        
    
    If GetGadgetState(#Opt_SortAll) = 1 ; Caso Opção TODAS
      AddGadgetItem(LsI_Tarefas,-1,Texto$)
      x + 1        
    EndIf   
    
    If TarefasLista()\TarefaID = y
      c = x
    EndIf   
  Next
  
  If c < 0
    c = 0
  EndIf
  
  SelectElement(TarefasLista(),i)
  SetGadgetState(LsI_Tarefas,c)
      
  SetGadgetText(TaskNome,TarefasLista()\TarefaNome)
  
  SetGadgetState(TrackBar_1,TarefasLista()\Valor)
  TrackBarUpdate(1,TrackBar_1,#TaskValor,GetGadgetState(TrackBar_1))
  
  SetGadgetState(TrackBar_2,TarefasLista()\Urgencia)
  TrackBarUpdate(2,TrackBar_2,#TaskUrgencia,GetGadgetState(TrackBar_2))
    
  SetGadgetState(TrackBar_3,TarefasLista()\Compliance)
  TrackBarUpdate(3,TrackBar_3,#TaskCompliance,GetGadgetState(TrackBar_3))  
  
  SetGadgetState(TrackBar_4,TarefasLista()\Esforco)
  TrackBarUpdate(4,TrackBar_4,#TaskEsforco,GetGadgetState(TrackBar_4))
  
  SetGadgetState(TaskCusto,TarefasLista()\Custo)
  
  SetGadgetState(Date_0,TarefasLista()\DataInicio)
  SetGadgetState(Date_1, TarefasLista()\DataFim)
  
  If TarefasLista()\Feito = 1
    SetGadgetState(TaskConcluido,#PB_Checkbox_Checked)
  Else
    SetGadgetState(TaskConcluido,#PB_Checkbox_Unchecked)
  EndIf
  
  SetGadgetText(#Txt_Taskperc, Str(CountGadgetItems(LsI_Tarefas)) + "/" + Str(ListSize(TarefasLista())) + " tarefas" + #CRLF$ + Str(Round(CountGadgetItems(LsI_Tarefas)/ListSize(TarefasLista()) * 100,0)) + "%")
  
  UpdateNotas()  ; Atualiza o Tab#4 (notas) e vê se há items -> Mostra ou não a imagem de notas
  If CountGadgetItems(LsI_notas) > 0
    HideGadget(#Img_HasNotes, 0)
  Else
    HideGadget(#Img_HasNotes, 1)
  EndIf
  
  SetActiveGadget(#Img_HasNotes)
  UpdateStatusBar()
  SetActiveGadget(LsI_Tarefas)
EndProcedure; 

;------------ Update da Tarefa consoante a seleção na Lista de Tarefas (TAB Tarefas)

Procedure UpdateListaTarefas(MyGadget)
  Define Texto$ = GetGadgetItemText(MyGadget,GetGadgetState(MyGadget))
  Define c.l = 0
  ForEach TarefasLista()
    If TarefasLista()\TarefaID = Val(Texto$)
      c = ListIndex(TarefasLista())
    EndIf
  Next
  SelectElement(TarefasLista(),c)
EndProcedure 


Procedure SelecionaData()
  Define x.l = 0
  
  If DatabaseConnected = #True
    
    ClearList(MySchedule())
    
    If DatabaseQuery(#MyDATABASE, "SELECT * FROM ScheduleDB WHERE Date = '" + Str(GetGadgetState(Calendar_0))+"'")           
      While NextDatabaseRow(#MyDATABASE)
        AddElement(MySchedule())
        MySchedule()\ScheduleID = GetDatabaseLong(#MyDATABASE, 0)
        MySchedule()\Date = GetDatabaseLong(#MyDATABASE, 1)
        MySchedule()\Hour = GetDatabaseLong(#MyDATABASE, 2)
        MySchedule()\TaskID = GetDatabaseLong(#MyDATABASE, 3)
      Wend
      FinishDatabaseQuery(#MyDATABASE)
    EndIf
    
    SetGadgetText(#Txt_DataSel,"HORÁRIO para: " + FormatDate("%dd/%mm/%yyyy", GetGadgetState(Calendar_0)))
    
    For x = 0 To 23       ; Limpa o texto dos items do Horário (LsI_Horas)
      SetGadgetItemText(Lsi_Horas,x, Str(x)+"h00" + Chr(10) + "")
    Next
    
    ForEach MySchedule()
      ForEach TarefasLista()
        If TarefasLista()\TarefaID = MySchedule()\TaskID
          SetGadgetItemText(Lsi_Horas,MySchedule()\Hour, Str(MySchedule()\Hour)+"h00" + Chr(10) + TarefasLista()\TarefaNome)
        EndIf
      Next
    Next
    
  EndIf
     
EndProcedure

;---------------------------------------- Atualização da TAB DIA (#0) ---------------------------------
Procedure UpdateTabDia()
  
  ClearGadgetItems(LsI_Dia)
  
  SetGadgetText(#Txt_1st,"") : SetGadgetText(#Txt_2nd,"") : SetGadgetText(#Txt_3rd,"")

  Define y.l = TarefasLista()\TarefaID
  
  Define x.l = -1
  Define c.l = 0
  Define c2.l = 0
  Define Decorrido.l = 0
  Define Atraso.l = 0
  Define PodioC.l = 0
  Define Podio1.l = 0
  Define Podio2.l = 0
  Define Podio3.l = 0
  Define first.l = #False
  
   ; Filtragem das tarefas válidas para o dia
  ForEach  TarefasLista()
    If (TarefasLista()\Feito) = 0 And (Int(TarefasLista()\DataInicio/3600/24) <= Int(Date()/3600/24))         ; Parte inteira para ser no mesmo dia !
      Decorrido = Int(Date()/3600/24) - Int(TarefasLista()\DataInicio/3600/24)
      Atraso = Int(Date()/3600/24) - Int(TarefasLista()\Datafim/3600/24)
      
      ForEach ProjetosLista()
        If TarefasLista()\ProjetoIDD = ProjetosLista()\ProjetoID
          Protected ProjNome$ = ProjetosLista()\ProjetoNome
        EndIf
      Next
  
      Define Texto$ = Str(TarefasLista()\TarefaID)
      Texto$ + Chr(10) + TarefasLista()\TarefaNome + Chr(10) + StrF(TarefasLista()\Prioridade,0) + Chr(10) + Str(Decorrido) + Chr(10) + Str(Atraso) + Chr(10) + ProjNome$     
      AddGadgetItem(LsI_Dia, -1, Texto$)
      x + 1
      
      If first = #False
        c2 = ListIndex(TarefasLista())
        first = #True
      EndIf
      
      ; Classificação das 3 prioritárias
      
      ;fórmula = Prioridade x (dias Decorridos + 1) x ciclo atual (= Decorridos / Duração + 1)
      ;Decorridos são os dias em curso, i.e. a diferença da Atualidade para Início, contando o dia que começou (+1)
      ;Ciclo é o ciclo em que está : 1º , 2º , etc . É a razão (Decorridos / Duração + 1) (não há zero, é logo o ciclo 1) 
      PodioC = Round(TarefasLista()\Prioridade * (Decorrido + 1) * (Decorrido /((TarefasLista()\DataFim - TarefasLista()\DataInicio)/3600/24 + 1) +1),0)
      
      If PodioC >= Podio1
        Podio3 = Podio2
        Podio2 = Podio1
        Podio1 = PodioC
        SetGadgetText(#Txt_3rd,GetGadgetText(#Txt_2nd)) 
        SetGadgetText(#Txt_2nd,GetGadgetText(#Txt_1st))       
        SetGadgetText(#Txt_1st,TarefasLista()\TarefaNome) 
      Else
        If PodioC >= Podio2
          Podio3 = Podio2
          Podio2 = PodioC
          SetGadgetText(#Txt_3rd,GetGadgetText(#Txt_2nd))
          SetGadgetText(#Txt_2nd,TarefasLista()\TarefaNome) 
        Else
          If PodioC >= Podio3
            Podio3 = PodioC
            SetGadgetText(#Txt_3rd,TarefasLista()\TarefaNome) 
          EndIf
        EndIf
      EndIf
                  
     ;Seleção da tarefa que estava definida anteriormente no novo redraw da List Icon LsI_Dia
      If TarefasLista()\TarefaID = y
        c = x
        c2 = ListIndex(TarefasLista())        
      EndIf
    EndIf
    SetGadgetItemState(Calendar_0,TarefasLista()\DataFim, #PB_Calendar_Normal)
  Next

  If c < 0
    c = 0
  EndIf
   
  SelectElement(TarefasLista(),c2)
  
  SetGadgetItemState(Calendar_0,TarefasLista()\DataFim, #PB_Calendar_Bold)
  
  SelecionaTipoProj()
  
  UpdateNotas()  ; Atualiza o Tab#4 (notas) e vê se há items -> Mostra ou não a imagem de notas
  If CountGadgetItems(LsI_notas) > 0
    HideGadget(#Img_HasNotesDia, 0)
  Else
    HideGadget(#Img_HasNotesDia, 1)
  EndIf
  
  UpdateStatusBar()
  SetGadgetState(LsI_Dia,c)
  SetActiveGadget(LsI_Dia)
   
EndProcedure

; Ordenação das Listas
Procedure Ordenar(opcao.l)
  Define x.l = 0
  Define y = TarefasLista()\TarefaID
  Define c.l = 0
      
  Select opcao
    Case 1 :
      SortStructuredList(ProjetosLista(),#PB_Sort_Ascending,OffsetOf(Projeto\ProjetoNome),TypeOf(Projeto\ProjetoNome))
      UpdateTabProjetos()  
    Case 2 :
      SortStructuredList(ProjetosLista(),#PB_Sort_Ascending,OffsetOf(Projeto\ProjetoFim),TypeOf(Projeto\ProjetoFim))
      UpdateTabProjetos() 
    Case 3 :
      SortStructuredList(ProjetosLista(),#PB_Sort_Ascending,OffsetOf(Projeto\ProjetoID),TypeOf(Projeto\ProjetoID))
      UpdateTabProjetos()      
    Case 4 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Ascending,OffsetOf(Tarefa\TarefaNome),TypeOf(Tarefa\TarefaNome))
    Case 5 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Ascending,OffsetOf(Tarefa\DataFim),TypeOf(Tarefa\DataFim))
    Case 6 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Ascending,OffsetOf(Tarefa\Feito),TypeOf(Tarefa\Feito))
    Case 7 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Descending,OffsetOf(Tarefa\Prioridade),TypeOf(Tarefa\Prioridade))
    Case 8 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Descending,OffsetOf(Tarefa\Urgencia),TypeOf(Tarefa\Urgencia))          
    Case 9 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Descending,OffsetOf(Tarefa\Esforco),TypeOf(Tarefa\Esforco))
    Case 10 :  
      SortStructuredList(TarefasLista(),#PB_Sort_Ascending,OffsetOf(Tarefa\TarefaID),TypeOf(Tarefa\TarefaID))     
  EndSelect
  
  UpdateTabProjetos(GetGadgetState(ListaProjetos),0)
  ForEach TarefasLista()
    If TarefasLista()\TarefaID = y
      c = x
    EndIf
    x + 1
  Next  
  
  SelectElement(TarefasLista(),c)
  UpdateTabTarefas()
  UpdateTabDia()
EndProcedure

;Adição de tarefas ao Horário
Procedure AddHorario()
  Define Entry.l = 0
    
  If DatabaseConnected = #True
    If CountGadgetItems(LsI_Dia) > 0
      ForEach MySchedule()
        If MySchedule()\Hour = GetGadgetState(Lsi_Horas)
          Entry = MySchedule()\ScheduleID
        EndIf
      Next
      
      If Entry > 0
        Define Texto$ = "UPDATE ScheduleDB SET Date = '" + Str(GetGadgetState(Calendar_0)) + "', Hour = '" + Str(GetGadgetState(LsI_Horas)) + "', Task = '"
        Texto$ + TarefasLista()\TarefaID + "' WHERE Schedule = '"+ Str(Entry) + "'"
      Else
        Define Texto$ = "INSERT INTO ScheduleDB (Date, Hour, Task) VALUES ('" + Str(GetGadgetState(Calendar_0)) +"', '" + Str(GetGadgetState(LsI_Horas)) + "', '"
        Texto$ + TarefasLista()\TarefaID + "')"        
      EndIf 
      CheckDatabaseUpdate(#MyDatabase, Texto$)
    Else
      MessageRequester("Info","Nenhuma tarefa para adicionar ao Horário !", #PB_MessageRequester_Warning)
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf  
  
  SelecionaData()
  
EndProcedure

;Remoção de tarefas ao Horário
Procedure DelHorario()  
  Define Entry.l = 0
  
  If DatabaseConnected = #True
      ForEach MySchedule()
        If MySchedule()\Hour = GetGadgetState(LsI_Horas)
          Entry = MySchedule()\ScheduleID
        EndIf
      Next
      
      If Entry > 0
        Define Texto$ = "DELETE FROM ScheduleDB WHERE Schedule = '" + Str(Entry)+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
      EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf  
  
  SelecionaData() 
EndProcedure


;Tarefa marcada como feita na Tab Dia !
Procedure TaskDiaFeito()
  
  If DatabaseConnected = #True
    If CountGadgetItems(LsI_Dia) > 0
      TarefasLista()\Feito = 1
      Define Texto$ = "UPDATE TarefasDB SET TaskFeito = '1' WHERE TaskID = '" + Str(TarefasLista()\TarefaID)+"'"
      CheckDatabaseUpdate(#MyDatabase, Texto$)
      UpdateTabDia()
    Else
      MessageRequester("Info","Nenhuma tarefa para marcar como Terminada !", #PB_MessageRequester_Warning)
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf 
  
EndProcedure


;Mostra a Nota seleccionada. Se nenhuma estiver seleccionada o Scintilla não é "limpo" e o que estiver escrito perdura...
Procedure DisplayNote()
  
  If DatabaseConnected = #True
    If DatabaseQuery(#MyDATABASE, "SELECT * FROM NotasDB WHERE NotasID = '" + GetGadgetItemText(LsI_Notas,GetGadgetState(LsI_Notas))+"'") 
      While NextDatabaseRow(#MyDATABASE)                  
        Define Nota.s = GetDatabaseString(#MyDATABASE, 4)
        Define Formato.s = GetDatabaseString(#MyDATABASE, 5)
      Wend
      FinishDatabaseQuery(#MyDATABASE)
    EndIf
    MyScintillaText(Scintilla_0, Nota, Formato)
  EndIf
  
EndProcedure

; Faz o Update das timelines das Tarefas associadas a cada Projeto (TAB #6)
Procedure UpdateTimelinesTasks()
  
    Define c.l = CountGadgetItems(#LsI_TimeTask)
    Define x.l = 0
        
    If c > 2  ; Remove os items/tarefas do projeto anterior     
      For x = 3 To c
        RemoveGadgetItem(#LsI_TimeTask, 2)
      Next x
    EndIf
  
  c = ListIndex(TarefasLista()) ; Mantém a Tarefa inicial
  
  ForEach TarefasLista()
    Define MyDiaStr$ = ""
    If TarefasLista()\ProjetoIDD = Val(GetGadgetItemText(#LsI_TimeProj,GetGadgetState(#LsI_TimeProj))) And TarefasLista()\Feito = 0
      For x = 0 To 120
        Define MyData = Date() + x * 3600 * 24
        
        If (Int(TarefasLista()\DataInicio/3600/24) <= Int(MyData/3600/24)) And (Int(TarefasLista()\DataFim/3600/24) >= Int(MyData/3600/24))
          MyDiaStr$ + "XX"
        Else
          MyDiaStr$ + "  "
        EndIf
      Next x
      AddGadgetItem(#LsI_TimeTask, -1, Str(TarefasLista()\TarefaID) + Chr(10) + TarefasLista()\TarefaNome + Chr(10) + MyDiaStr$)
    EndIf
  Next
  SelectElement(TarefasLista(),c)
EndProcedure

;---------------------------------------- Atualização da TAB CALENDÁRIO (#6) ---------------------------------
Procedure UpdateTimelinesProjetos()
  
  ClearGadgetItems(#LsI_TimeProj)
  ClearGadgetItems(#LsI_TimeTask)
  
  Define MyDiaStr$ = FormatDate("%dd", Date())  ; Dia de hoje
  Define MyMesStr$ = FormatDate("%mm", Date())  ; Mês de hoje
  
  SetGadgetText(#Txt_Calendario, "Calendário de " + FormatDate("%dd/%mm/%yyyy", Date()) + " a " + FormatDate("%dd/%mm/%yyyy", Date() + 120*3600*24))
  
  Define x.l = 1
  Define y.l = 1
  
  For x = 1 To 120                             ; Calendário para os próximos trimestre
    Define MyData = Date() + x * 3600 * 24
    
    If y < 7
      MyDiaStr$ = MyDiaStr$ + "  "
    Else
      MyDiaStr$ = MyDiaStr$ + FormatDate("%dd", MyData)
      y = 0
    EndIf
    y + 1
    
    If FormatDate("%mm", MyData) <> FormatDate("%mm", MyData - 24 * 3600)
      MyMesStr$ = MyMesStr$ + FormatDate("%mm", MyData)
    Else
      MyMesStr$ = MyMesStr$ + "  "
    EndIf
  Next x
  
  AddGadgetItem(#LsI_TimeProj, 0, "Mês" + Chr(10) + Chr(10) + MyMesStr$)
  AddGadgetItem(#LsI_TimeProj, 1, "Dia" + Chr(10) + Chr(10) + MyDiaStr$)
  AddGadgetItem(#LsI_TimeTask, 0, "Mês" + Chr(10) + Chr(10) + MyMesStr$)
  AddGadgetItem(#LsI_TimeTask, 1, "Dia" + Chr(10) + Chr(10) + MyDiaStr$)
  
  SetGadgetItemColor(#LsI_TimeProj, 0,#PB_Gadget_BackColor, #Gray)
  SetGadgetItemColor(#LsI_TimeProj, 0,#PB_Gadget_FrontColor, #White)
  SetGadgetItemColor(#LsI_TimeProj, 1,#PB_Gadget_BackColor, #Gray)
  SetGadgetItemColor(#LsI_TimeProj, 1,#PB_Gadget_FrontColor, #White)
  SetGadgetItemColor(#LsI_TimeTask, 0,#PB_Gadget_BackColor, #Gray)
  SetGadgetItemColor(#LsI_TimeTask, 0,#PB_Gadget_FrontColor, #White) 
  SetGadgetItemColor(#LsI_TimeTask, 1,#PB_Gadget_BackColor, #Gray)
  SetGadgetItemColor(#LsI_TimeTask, 1,#PB_Gadget_FrontColor, #White) 
  
  Define c = ListIndex(ProjetosLista()) ; Mantém o Projeto inicial
  ForEach ProjetosLista()
    MyDiaStr$ = ""
    For x = 0 To 120
      MyData = Date() + x * 3600 * 24
      
      If (Int(ProjetosLista()\ProjetoInicio/3600/24) <= Int(MyData/3600/24)) And (Int(ProjetosLista()\ProjetoFim/3600/24) >= Int(MyData/3600/24))
        MyDiaStr$ + "XX"
      Else
        MyDiaStr$ + "  "
      EndIf
    Next x
    AddGadgetItem(#LsI_TimeProj, -1, Str(ProjetosLista()\ProjetoID) + Chr(10) + ProjetosLista()\ProjetoNome + Chr(10) + MyDiaStr$)
  Next
  SelectElement(ProjetosLista(),c)
  
  SetGadgetState(#LsI_TimeProj, 1)
  UpdateTimelinesTasks()
   
EndProcedure

;Double click num projeto do Calendário
Procedure DoubleClickProj()
  If (GetGadgetState(#LsI_TimeProj) > 1)
    UpdateTabProjetos()
    SetGadgetState(Panel_0,2)
    SetActiveGadget(ListaProjetos)
  EndIf  
EndProcedure

;Double click numa tarefa do Calendário
Procedure DoubleClickTask()
  Define c.l = 0
  
  If (GetGadgetState(#LsI_TimeTask) > 1)
    Define x.l = Val(GetGadgetItemText(#LsI_TimeTask, GetGadgetState(#LsI_TimeTask)))
    
    ForEach TarefasLista()
      If TarefasLista()\TarefaID = x
        c = ListIndex(TarefasLista())
      EndIf
    Next
    SelectElement(TarefasLista(),c)
    UpdateTabTarefas()
    SetGadgetState(Panel_0,3)
    SetActiveGadget(LsI_Tarefas)
  EndIf  
EndProcedure


Procedure UpdateScrumBoard()
  
  ClearGadgetItems(LsI_scrum)
  
  If DatabaseConnected = #True
    Protected VarInt.l = 0
    Protected Texto$
    Protected c.l = 0
      
      #TextoForQuery2 = "Select b.BoardID, a.TaskNome, a.TaskUrgencia, a.TaskEsforco, b.Status from TarefasDB as a INNER JOIN ScrumBoardDB as b on a.TaskID = b.Task INNER JOIN ScrumDB as c on b.ScrumID = c.ScrumID WHERE c.ScrumID = '"    
      If DatabaseQuery(#MyDATABASE, #TextoForQuery2 + Str(ScrumLista()\ScrumID) +"'" )        
        While NextDatabaseRow(#MyDATABASE)
          VarInt = GetDatabaseLong(#MyDATABASE,4)
          Texto$ = GetDatabaseString(#MyDATABASE,1)
          AddGadgetItem(LsI_Scrum, c,"")
          Select VarInt
            Case 0 :             
              SetGadgetItemText(LsI_Scrum,c, Texto$, 0)
            Case 1
              SetGadgetItemText(LsI_Scrum,c, Texto$, 1)
            Case 2
              SetGadgetItemText(LsI_Scrum,c, Texto$, 2)
          EndSelect
          VarInt = GetDatabaseLong(#MyDATABASE,0)
          SetGadgetItemData(LsI_Scrum, c, VarInt)
          ;---------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ToDo : Ler Urgencia e Esforco !!!!!!!!!!!!!!
          c + 1
        Wend
        FinishDatabaseQuery(#MyDATABASE)
      EndIf
    EndIf
    
  EndProcedure


;---------------------------------------- Atualização da TAB SCRUM (#1) ---------------------------------
Procedure UpdateScrum()
  
  Protected c.l = GetGadgetState(Cob_Scrum)
  
  If c >= 0
    SelectElement(ScrumLista(), c)
    
    SetGadgetState(#Date_2, ScrumLista()\ScrumInicio)
    SetGadgetState(#Date_3, ScrumLista()\ScrumFim)
    
    If ScrumLista()\ScrumFeito = 1  
      SetGadgetState(#Ckb_Scrum, #PB_Checkbox_Checked)   
    Else
      SetGadgetState(#Ckb_Scrum, #PB_Checkbox_Unchecked) 
    EndIf       
    
    SetGadgetText(#Edt_ScrumDef, ScrumLista()\ScrumFeitoDef) 
    MyScintillaFootnote (Scintilla_1, ScrumLista()\ScrumLog)
    UpdateScrumBoard()
  Else
    SetGadgetState(#Date_2, Date())
    SetGadgetState(#Date_3, Date() + 3600*24*14)         ; A duração normal de 1 sprint costuma ser de 2 semanas (14 dias)
    SetGadgetState(#Ckb_Scrum, #PB_Checkbox_Unchecked)       
    ClearGadgetItems(#Edt_ScrumDef)
    ClearGadgetItems(LsI_Scrum)
    Protected SCN_Texto$ = "[#1] O que fiz ontem ?" + #CRLF$ + #CRLF$ + #CRLF$ + #CRLF$ + "[#2] O que vou fazer hoje ?" + #CRLF$ + #CRLF$ + #CRLF$ + #CRLF$ + "[#3] Quais são os obstáculos ?"+ #CRLF$ + #CRLF$ + #CRLF$   
    MyScintillaFootnote(Scintilla_1, SCN_Texto$)
  EndIf
  
  UpdateStatusBar()
EndProcedure
    

; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 22
; Folding = ----
; EnableXP