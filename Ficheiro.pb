;+-------------------------------------------------------------------------------+
;¦                      Ficheiro.pb  - version 0.33-alpha                        ¦
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
;¦ Handles File Operations (read/write) for program GxPlan - Plan in Compliance. ¦
;+-------------------------------------------------------------------------------+ 


Procedure UpdateTiposProjeto()
  ;Define x.l = CountGadgetItems(TipoCombo)  ---> ToDo : ver se a criação de uma nova tarefa pode retroceder ao tipo certo
  ClearGadgetItems(TipoCombo)
  ForEach TiposLista()
    AddGadgetItem(TipoCombo,-1, TiposLista()\TipoNome)
  Next
  SetGadgetState(TipoCombo, 0)
EndProcedure

; Adiciona os nomes dos Sprints aos gadgets
Procedure AddScrum()
  
  ClearGadgetItems(Cob_Scrum)
  ClearGadgetItems(TaskScrum)
  
  If ListSize(ScrumLista()) > 0  
    ForEach ScrumLista()
      
      AddGadgetItem(Cob_Scrum, -1, ScrumLista()\Sprint)       ; ComboBox na TAB#1 Scrum
      SetGadgetItemData(Cob_Scrum, CountGadgetItems(Cob_Scrum) - 1, ScrumLista()\ScrumID)
      
      If ScrumLista()\ScrumFeito = 0
          AddGadgetItem(TaskScrum, -1, ScrumLista()\Sprint)       ; ComboBox na TAB#3 Tarefas
          SetGadgetItemData(TaskScrum, CountGadgetItems(TaskScrum) - 1, ScrumLista()\ScrumID)
      EndIf
    Next
  EndIf

EndProcedure

;------------------------------------- Criação, Abertura e Carregamento da BASE DE DADOS ----------------------
 
 Procedure Arranque()
   
   ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Criação das Listas iniciais
   ClearList(TiposLista())
   AddElement (TiposLista())
   TiposLista()\TipoID = 1
   TiposLista()\TipoNome = "Pessoal"
   AddElement (TiposLista())
   TiposLista()\TipoID = 2
   TiposLista()\TipoNome = "Trabalho"      
   
   ClearList(ProjetosLista())
   AddElement (ProjetosLista())
   ProjetosLista()\ProjetoID = 1
   ProjetosLista()\TipoIDD = 1
   ProjetosLista()\ProjetoNome = "Rotina"
   ProjetosLista()\ProjetoInicio = Date()
   ProjetosLista()\ProjetoFim = Date() + (7 * 24 * 3600)
   ProjetosLista()\ProjetoFeito = 0   
   
   ClearList(TarefasLista())
   AddElement (TarefasLista())
   TarefasLista()\TarefaID = 1
   TarefasLista()\ProjetoIDD = 1
   TarefasLista()\TarefaNome = "Tarefa 1"
   TarefasLista()\Valor = 3
   TarefasLista()\Compliance = 3
   TarefasLista()\Urgencia = 3
   TarefasLista()\Esforco = 3             
   TarefasLista()\Prioridade = 10.0             
   TarefasLista()\Custo = 0                 
   TarefasLista()\Feito = 0                 
   TarefasLista()\DataInicio = Date()             
   TarefasLista()\DataFim = Date()  + (24 * 3600)
   
   ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Ações para atualizar items no arranque
   
   SetActiveGadget(panel_0)
   SetGadgetState(LsI_Horas,7) ; Define as 7h00 no arranque
   UpdateTabDia()       ; Atualiza o painel 0 no arranque !
   UpdateTiposProjeto() ; Atualiza o combo "Tipo de Projetos"
   UpdateTabProjetos()
   Updatetabtarefas()
   MyScintillaText(Scintilla_0)
   UpdateScrum()
    
 EndProcedure 
 
Procedure Carrega_Dados() ;------------------ Carrega a Base de Dados nas Listas -----------
  
  ;---------------------------  Leitura da Base de Dados dos Tipos --------------------------
  If DatabaseQuery(#MyDATABASE, "SELECT * FROM TiposDB")           
    ClearList (TiposLista())
    While NextDatabaseRow(#MyDATABASE)
      AddElement (TiposLista())
      TiposLista()\TipoID = GetDatabaseLong(#MyDATABASE, 0)
      TiposLista()\TipoNome = GetDatabaseString(#MyDATABASE, 1)            
    Wend
    FinishDatabaseQuery(#MyDATABASE)
  EndIf
  ;---------------------------  Leitura da Base de Dados dos Projetos -------------------------
  If DatabaseQuery(#MyDATABASE, "SELECT * FROM ProjetosDB")           
    ClearList (ProjetosLista())
    While NextDatabaseRow(#MyDATABASE)
      AddElement (ProjetosLista())
      ProjetosLista()\ProjetoID = GetDatabaseLong(#MyDATABASE, 0)
      ProjetosLista()\TipoIDD = GetDatabaseLong(#MyDATABASE, 1)
      ProjetosLista()\ProjetoNome = GetDatabaseString(#MyDATABASE, 2)
      ProjetosLista()\ProjetoInicio = GetDatabaseLong(#MyDATABASE, 3)
      ProjetosLista()\ProjetoFim = GetDatabaseLong(#MyDATABASE, 4)
      ProjetosLista()\ProjetoFeito = GetDatabaseLong(#MyDATABASE, 5)             
    Wend
    FinishDatabaseQuery(#MyDATABASE)
  EndIf
  

  ;---------------------------  Leitura da Base de Dados das Tarefas ---------------------------
  If DatabaseQuery(#MyDATABASE, "SELECT * FROM TarefasDB")    
    ClearList (TarefasLista()) 
    While NextDatabaseRow(#MyDATABASE)
      AddElement (TarefasLista())
      TarefasLista()\TarefaID = GetDatabaseLong(#MyDATABASE, 0)
      TarefasLista()\ProjetoIDD = GetDatabaseLong(#MyDATABASE, 1)
      TarefasLista()\TarefaNome = GetDatabaseString(#MyDATABASE, 2)
      TarefasLista()\Valor = GetDatabaseLong(#MyDATABASE, 3)
      TarefasLista()\Compliance = GetDatabaseLong(#MyDATABASE, 4)
      TarefasLista()\Urgencia = GetDatabaseLong(#MyDATABASE, 5)
      TarefasLista()\Esforco = GetDatabaseLong(#MyDATABASE, 6)              
      TarefasLista()\Prioridade = GetDatabaseFloat(#MyDATABASE, 7)               
      TarefasLista()\Custo = GetDatabaseLong(#MyDATABASE, 8)                  
      TarefasLista()\Feito = GetDatabaseLong(#MyDATABASE, 9)                  
      TarefasLista()\DataInicio = GetDatabaseLong(#MyDATABASE, 10)               
      TarefasLista()\DataFim = GetDatabaseLong(#MyDATABASE, 11)
    Wend
    FinishDatabaseQuery(#MyDATABASE)
  EndIf 
  
   ;---------------------------  Leitura da Base de Dados dos Sprints de Scrum -------------------------
  If DatabaseQuery(#MyDATABASE, "SELECT * FROM ScrumDB")           
    ClearList (ScrumLista())
    While NextDatabaseRow(#MyDATABASE)
      AddElement (ScrumLista())
      ScrumLista()\ScrumID = GetDatabaseLong(#MyDATABASE, 0)
      ScrumLista()\Sprint = GetDatabaseString(#MyDATABASE, 1)
      ScrumLista()\ScrumInicio = GetDatabaseLong(#MyDATABASE, 2)
      ScrumLista()\ScrumFim = GetDatabaseLong(#MyDATABASE, 3)
      ScrumLista()\ScrumFeito = GetDatabaseLong(#MyDATABASE, 4)
      ScrumLista()\ScrumFeitoDef = GetDatabaseString(#MyDATABASE, 5)
      ScrumLista()\ScrumLog = GetDatabaseString(#MyDATABASE, 6)
    Wend
    FinishDatabaseQuery(#MyDATABASE)
  EndIf 
   
  SelecionaData()   ;Carrega um horário se houver para a data selecionada no Calendar_0 (#Tab 0)
  
  UpdateTiposProjeto()
  
  AddScrum() : UpdateScrum()      ;Adiciona os Scrums às 2 ComboBox do Scrum (TAB#1 e TAB#3) e faz o update da TAB#1 (Scrum)
  
EndProcedure
  
;--------------------------------------------------------- ABRE A BASE DE DADOS -----------------------------------------------------------------
Procedure AbrirBaseDados()
    
  DatabaseFile$ = OpenFileRequester("Abrir Base de Dados","", "sqlite DB (*.sqlite)|*.sqlite|Todos (*.*)|*.*",0)
  
  If DatabaseFile$ <> ""
    
    If DatabaseConnected = #True
      HandleMyError(CloseDatabase(#MyDATABASE),"Erro ao fechar a Base de Dados anterior!",1)
    EndIf
    
    Define Erro.l = HandleMyError(OpenDatabase(#MyDATABASE, DatabaseFile$, "", "",#PB_Database_SQLite),"Erro ao abrir a Base de Dados!",0)
    
    If Erro = #False
      DatabaseConnected=#True
      OldDatabaseFile$ = DatabaseFile$  ; Retém o nome do ficheiro anterior após uma conexão com sucesso !
      
      ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ações para atualizar os items após carregar novos dados !
      
      SetGadgetItemState(Calendar_0,TarefasLista()\DataFim, #PB_Calendar_Normal) ; Limpeza do calendário da base de dados anterior ...
      Carrega_Dados()
      UpdateTabDia()
      UpdateTabProjetos(0,0)
      Updatetabtarefas()
      UpdateTimelinesProjetos()
      MessageRequester("Sucesso!","Base de Dados carregada!", #PB_MessageRequester_Info)
    Else
      If DatabaseConnected=#True
         HandleMyError(OpenDatabase(#MyDATABASE, OldDatabaseFile$, "", "",#PB_Database_SQLite),"Erro ao abrir a Base de Dados!",1)  ;Tenta reconnectar a base de dados anterior em caso de Erro da Nova aberta...
      EndIf  
    EndIf
  EndIf
  
EndProcedure  
 
;--------------------------------------------------------- CRIA A BASE DE DADOS -----------------------------------------------------------------
Procedure CriarBaseDados()
    
  DatabaseFile$ = SaveFileRequester("Nova Base de Dados","novaBD.sqlite", "sqlite DB (*.sqlite)|*.sqlite",0)
  
  If DatabaseFile$<>""
  
    Define Erro.l = HandleMyError(CreateFile(#MyFile,DatabaseFile$),"Não se conseguiu criar o ficheiro!",0)
    
    If Erro = #False
      CloseFile(#MyFile)
      
      If DatabaseConnected = #True
        HandleMyError(CloseDatabase(#MyDATABASE),"Erro ao fechar a Base de Dados anterior!",1)
      EndIf
    
      HandleMyError(OpenDatabase(#MyDATABASE, DatabaseFile$, "", "",#PB_Database_SQLite),"Erro ao criar a Base de Dados !",1)
      
      DatabaseConnected=#True
      OldDatabaseFile$ = DatabaseFile$  ; Retém o nome do ficheiro anterior após uma conexão com sucesso !
      
      SetGadgetItemState(Calendar_0,TarefasLista()\DataFim, #PB_Calendar_Normal) ; Limpeza do calendário da base de dados anterior ...
      Arranque()
      
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE TiposDB (TipoID INTEGER PRIMARY KEY AUTOINCREMENT,TipoNome CHAR)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE ProjetosDB (ProjID INTEGER PRIMARY KEY AUTOINCREMENT ,TipoIDD INT, ProjNome CHAR, ProjInicio INT, ProjFim INT, ProjFeito BIT)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE TarefasDB (TaskID INTEGER PRIMARY KEY AUTOINCREMENT ,ProjIDD INT, TaskNome CHAR, TaskValor INT, TaskCompliance INT, TaskUrgencia INT, TaskEsforco INT, TaskPrioridade REAL, TaskCusto INT, TaskFeito BIT, TaskStart INT, TaskEnd INT)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE ScheduleDB (Schedule INTEGER PRIMARY KEY AUTOINCREMENT,Date INT, Hour INT, Task INT)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE NotasDB (NotasID INTEGER PRIMARY KEY AUTOINCREMENT,TarefasIDD INT, DataInicial INT, DataModificado INT, Nota CHAR, Formato CHAR)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE ScrumDB (ScrumID INTEGER PRIMARY KEY AUTOINCREMENT,Sprint CHAR, DataInicio INT, DataFim INT, SprintFeito INT, FeitoDef CHAR, RetrosP CHAR)")
      CheckDatabaseUpdate(#MyDATABASE, "CREATE TABLE ScrumBoardDB (BoardID INTEGER PRIMARY KEY AUTOINCREMENT, ScrumID INT, Task INT, Status INT)")
      
      CheckDatabaseUpdate(#MyDatabase, "INSERT INTO TiposDB (TipoNome) VALUES ('Pessoal')")
      CheckDatabaseUpdate(#MyDatabase, "INSERT INTO TiposDB (TipoNome) VALUES ('Trabalho')")
      
      SelectElement(ProjetosLista(),0)
      Define Texto$ = "INSERT INTO ProjetosDB (TipoIDD, ProjNome, ProjInicio, ProjFim, ProjFeito) VALUES ('1', '"
      Texto$ + ProjetosLista()\ProjetoNome +"', '" + Str(ProjetosLista()\ProjetoInicio) +"', '" + Str(ProjetosLista()\ProjetoFim) +"', '" + Str(ProjetosLista()\ProjetoFeito) +"')"
      CheckDatabaseUpdate(#MyDatabase,Texto$)
      
      SelectElement(TarefasLista(),0)
      Texto$ = "INSERT INTO TarefasDB (ProjIDD, TaskNome, TaskValor, TaskCompliance, TaskUrgencia, TaskEsforco, TaskPrioridade, TaskCusto, TaskFeito, TaskStart, TaskEnd) VALUES ('1','"
      Texto$ + TarefasLista()\TarefaNome +"', '"+ Str(TarefasLista()\Valor) +"', '" + Str(TarefasLista()\Compliance)
      Texto$ + "', '" + Str(TarefasLista()\Urgencia) + "', '" + Str(TarefasLista()\Esforco)
      Texto$ + "', '" + StrF(TarefasLista()\Prioridade,1) + "', '" + Str(TarefasLista()\Custo)
      Texto$ + "', '" + Str(TarefasLista()\Feito)
      Texto$ + "', '" + Str(TarefasLista()\DataInicio) + "', '" + Str(TarefasLista()\DataFim) +"')"
      CheckDatabaseUpdate(#MyDatabase,Texto$)
      
      MessageRequester("Sucesso!","Base de Dados criada!", #PB_MessageRequester_Info)
    Else
      If DatabaseConnected=#True
        HandleMyError(OpenDatabase(#MyDATABASE, OldDatabaseFile$, "", "",#PB_Database_SQLite),"Erro ao abrir a Base de Dados!",1)  ;Tenta reconnectar a base de dados anterior em caso de Erro da Nova aberta...
      EndIf 
    EndIf
  EndIf
EndProcedure

;--------------------------------------- Operações na TAB PROJETOS ---------------------------------------------

Procedure Novo_Projeto()  ;----------------------------- NOVO PROJETO ---------
  Define Texto$ = GetGadgetText(ProjStrNome)
  
  If DatabaseConnected = #True
    If Texto$ <> ProjetosLista()\ProjetoNome
      If MessageRequester("Questão?","Quer criar um novo Projeto ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes     
        Texto$ = "INSERT INTO ProjetosDB (TipoIDD, ProjNome, ProjInicio, ProjFim, ProjFeito) VALUES ('" + Str(TiposLista()\TipoID)
        Texto$ + "', '" + GetGadgetText(ProjStrNome)
        Texto$ + "', '" + Str(GetGadgetState(Date_Proj_i)) + "', '" + Str(GetGadgetState(Date_Proj_f))
        If GetGadgetState(Chk_Proj_Terminado) = #PB_Checkbox_Checked
          Texto$ + "', '1')"
        Else
          Texto$ + "', '0')"
        EndIf
        CheckDatabaseUpdate(#MyDatabase, Texto$)   
        Carrega_Dados()
        UpdateTabProjetos()
      EndIf
    Else
      MessageRequester("Info","Por favor, dê um novo nome !")   
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf
  
EndProcedure



Procedure Apagar_Projeto() ;----------------------------- APAGAR PROJETO -----------
  Define Texto$ = ProjetosLista()\ProjetoNome
  
  If DatabaseConnected = #True
    If ListSize(ProjetosLista()) > 1
      If MessageRequester("Questão?","Quer apagar o Projeto" + #CRLF$+ #CRLF$+"'" + Texto$ +"'" + #CRLF$ + #CRLF$+" e TODAS as TAREFAS associadas ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) = #PB_MessageRequester_Yes     
        Texto$ = "DELETE FROM ProjetosDB WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        Texto$ = "DELETE FROM TarefasDB WHERE ProjIDD = '" + Str(ProjetosLista()\ProjetoID)+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)   
        Carrega_Dados()
        UpdateTabProjetos()
      EndIf
    Else
      MessageRequester("Info","Tem de existir pelo menos 1 projeto !", #PB_MessageRequester_Warning)   
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf  
  
EndProcedure


Procedure Subscrever_Projeto() ;----------------------------- SUBSCREVER PROJETO -------
  
  If DatabaseConnected = #True
    If MessageRequester("Questão?","Deseja subscrever o projeto ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      
      ProjetosLista()\ProjetoNome = GetGadgetText(ProjStrNome)
      ProjetosLista()\ProjetoInicio = GetGadgetState(Date_Proj_i)
      ProjetosLista()\ProjetoFim = GetGadgetState(Date_Proj_f)
      
      If GetGadgetState(Chk_Proj_Terminado) = #PB_Checkbox_Checked
        ProjetosLista()\ProjetoFeito = 1
      Else
        ProjetosLista()\ProjetoFeito = 0
      EndIf
      
      
      Define Texto$ = "UPDATE ProjetosDB SET ProjNome = '"
      
      Texto$ + ProjetosLista()\ProjetoNome +"', ProjInicio = '"+ Str(ProjetosLista()\ProjetoInicio) +"', ProjFim = '" + Str(ProjetosLista()\ProjetoFim) 
      Texto$ + "', ProjFeito = '" + Str(ProjetosLista()\ProjetoFeito)
      Texto$ +"' WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
      CheckDatabaseUpdate(#MyDatabase, Texto$)
      
      UpdateTabProjetos(GetGadgetState(ListaProjetos),GetGadgetState(ListaTarefasProj))
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf 
  
EndProcedure

;--------------------------------------- Operações na TAB TAREFAS ---------------------------------------------

Procedure Nova_Tarefa()  ;----------------------------- NOVA TAREFA ---------
  Define Texto$ = GetGadgetText(TaskNome)
  
  If DatabaseConnected = #True
    If Texto$ <> TarefasLista()\TarefaNome
      If MessageRequester("Questão?","Quer criar uma nova Tarefa ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes     
        Texto$ = "INSERT INTO TarefasDB (ProjIDD, TaskNome, TaskValor, TaskCompliance, TaskUrgencia, TaskEsforco, TaskPrioridade, TaskCusto, TaskFeito, TaskStart, TaskEnd) VALUES ('"
        
        Define c.l = 0
        
        ForEach ProjetosLista()
          If ProjetosLista()\ProjetoNome = GetGadgetItemText(TaskProjeto, GetGadgetState(TaskProjeto))
            Texto$ + Str(ProjetosLista()\ProjetoID)
            c = ListIndex(ProjetosLista())
          EndIf
        Next
        
        Texto$ + "', '"+ GetGadgetText(TaskNome) +"', '"+ Str(GetGadgetState(Trackbar_1))+"', '" +Str(GetGadgetState(Trackbar_3))+"', '" 
        Texto$ + Str(GetGadgetState(Trackbar_2))+"', '" +Str(GetGadgetState(Trackbar_4))+"', '" +GetGadgetText(#TaskPrioridade)+"', '" +Str(GetGadgetState(TaskCusto))
        
        If GetGadgetState(TaskConcluido) = #PB_Checkbox_Checked
          Texto$ + "', '1', '"
        Else
          Texto$ + "', '0', '"
        EndIf
        
        Texto$ + Str(GetGadgetState(Date_0)) + "', '" + Str(GetGadgetState(Date_1)) + "')"
        
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        
        ; Update das datas do PROJETO consoante as da TAREFA, se necessário ...
        SelectElement(ProjetosLista(),c)
        
        If GetGadgetState(Date_0) < ProjetosLista()\ProjetoInicio
          If MessageRequester("Questão?","O início da Tarefa é anterior ao do Projeto !" + #CRLF$ + #CRLF$ + "Deseja antecipar o Projeto ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes
            ProjetosLista()\ProjetoInicio = GetGadgetState(Date_0)
            Texto$ = "UPDATE ProjetosDB SET ProjInicio = '" + Str(ProjetosLista()\ProjetoInicio)
            Texto$ +"' WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
            CheckDatabaseUpdate(#MyDatabase, Texto$)
          EndIf
        EndIf
        
         If GetGadgetState(Date_1) > ProjetosLista()\ProjetoFim
          If MessageRequester("Questão?","A conclusão da Tarefa é posterior à do Projeto !" + #CRLF$ + #CRLF$ + "Deseja adiar o Projeto ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes
            ProjetosLista()\ProjetoFim = GetGadgetState(Date_1)
            Texto$ = "UPDATE ProjetosDB SET ProjFim = '" + Str(ProjetosLista()\ProjetoFim)
            Texto$ +"' WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
            CheckDatabaseUpdate(#MyDatabase, Texto$)
          EndIf
        EndIf       
               
        Carrega_Dados()
        UpdateTabTarefas()
      EndIf
    Else
      MessageRequester("Info","Por favor, dê um novo nome !")   
    EndIf 
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf
  
EndProcedure  

Procedure Apagar_Tarefa() ;----------------------------- APAGAR TAREFA -----------
  Define Texto$ = TarefasLista()\TarefaNome
  
  If DatabaseConnected = #True
    If ListSize(TarefasLista()) > 1
      If MessageRequester("Questão?","Quer apagar a Tarefa " +"'" + Texto$ +"' ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) = #PB_MessageRequester_Yes     
        Texto$ = "DELETE FROM TarefasDB WHERE TaskID = '" + Str(TarefasLista()\TarefaID)+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        Carrega_Dados()
        UpdateTabTarefas()
      EndIf
    Else
      MessageRequester("Info","Tem de existir pelo menos 1 tarefa !", #PB_MessageRequester_Warning)   
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf 
  
EndProcedure

Procedure Subscrever_Tarefa() ;----------------------------- SUBSCREVER TAREFA -------
  
  If DatabaseConnected = #True
    If MessageRequester("Questão?","Deseja subscrever a tarefa ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      
      TarefasLista()\TarefaNome = GetGadgetText(TaskNome) ; Update ListaTarefas
      TarefasLista()\Valor = GetGadgetState(TrackBar_1)
      TarefasLista()\Urgencia = GetGadgetState(TrackBar_2)
      TarefasLista()\Compliance = GetGadgetState(TrackBar_3)
      TarefasLista()\Esforco = GetGadgetState(TrackBar_4)
      TarefasLista()\Prioridade = ValF(GetGadgetText(#Taskprioridade))
      TarefasLista()\Custo = GetGadgetState(TaskCusto)
      TarefasLista()\DataInicio = GetGadgetState(Date_0)  
      TarefasLista()\ DataFim = GetGadgetState(Date_1)  
      
      If GetGadgetState(TaskConcluido) = #PB_Checkbox_Checked ; Update Feito na ListaTarefas
        TarefasLista()\Feito = 1
      Else
        TarefasLista()\Feito = 0
      EndIf
      
      Define Texto$ = "UPDATE TarefasDB SET TaskNome = '"  ; SQL command start
      Texto$ + TarefasLista()\TarefaNome +"', TaskValor = '"+ Str(TarefasLista()\Valor) +"', TaskUrgencia = '" + Str(TarefasLista()\Urgencia)
      Texto$ + "', TaskCompliance = '" + Str(TarefasLista()\Compliance) + "', TaskEsforco = '" + Str(TarefasLista()\Esforco)
      Texto$ + "', TaskPrioridade = '" + StrF(TarefasLista()\Prioridade,1) + "', TaskCusto = '" + Str(TarefasLista()\Custo)
      Texto$ + "', TaskStart = '" + Str(TarefasLista()\DataInicio) + "', TaskEnd = '" + Str(TarefasLista()\DataFim)
      Texto$ + "', TaskFeito = '" + Str(TarefasLista()\Feito)
      
      Define c.l = 0
      
      ForEach ProjetosLista() ; Atualiza o link ao projetoID
        If ProjetosLista()\ ProjetoNome = GetGadgetItemText(TaskProjeto, GetGadgetState(TaskProjeto))
          TarefasLista()\ProjetoIDD = ProjetosLista()\ProjetoID
          Texto$ + "', ProjIDD = '" + Str(TarefasLista()\ProjetoIDD) + "' WHERE TaskID = '" + Str(TarefasLista()\TarefaID)+"'"
          c = ListIndex(ProjetosLista())
        EndIf
      Next      
      CheckDatabaseUpdate(#MyDatabase, Texto$)  ; SQL command execute
      
      ; Update das datas do PROJETO consoante as da TAREFA, se necessário ...
      SelectElement(ProjetosLista(),c)
      
      If GetGadgetState(Date_0) < ProjetosLista()\ProjetoInicio
        If MessageRequester("Questão?","O início da Tarefa é anterior ao do Projeto !" + #CRLF$ + #CRLF$ + "Deseja antecipar o Projeto ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes
          ProjetosLista()\ProjetoInicio = GetGadgetState(Date_0)
          Texto$ = "UPDATE ProjetosDB SET ProjInicio = '" + Str(ProjetosLista()\ProjetoInicio)
          Texto$ +"' WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
          CheckDatabaseUpdate(#MyDatabase, Texto$)
        EndIf
      EndIf
      
      If GetGadgetState(Date_1) > ProjetosLista()\ProjetoFim
        If MessageRequester("Questão?","A conclusão da Tarefa é posterior à do Projeto !" + #CRLF$ + #CRLF$ + "Deseja adiar o Projeto ?",#PB_MessageRequester_YesNo | #PB_MessageRequester_Info) = #PB_MessageRequester_Yes
          ProjetosLista()\ProjetoFim = GetGadgetState(Date_1)
          Texto$ = "UPDATE ProjetosDB SET ProjFim = '" + Str(ProjetosLista()\ProjetoFim)
          Texto$ +"' WHERE ProjID = '" + Str(ProjetosLista()\ProjetoID)+"'"
          CheckDatabaseUpdate(#MyDatabase, Texto$)
        EndIf
      EndIf  
          
      UpdateTabTarefas()
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf
  
EndProcedure;

;Adiciona Notas (botão OK)
Procedure OK_Nota()
  
  Define NumChar.l = ScintillaSendMessage(Scintilla_0, #SCI_GETLENGTH)
  
  If DatabaseConnected = #True
    If (GetGadgetState(LsI_Notas) < 0) And (NumChar > 0)
      If MessageRequester("Questão?","Deseja criar uma nova nota ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        Define Texto$ = "INSERT INTO NotasDB (TarefasIDD, DataInicial, DataModificado, Nota, Formato) VALUES ('" + Str(TarefasLista()\TarefaID)
        Texto$ + "', '" + Str(Date()) + "', '" + Str(Date()) + "', '" + GetScintillaAllText(Scintilla_0) + "', '" + GetScintillaFormat(Scintilla_0) + "')"
        CheckDatabaseUpdate(#MyDatabase, Texto$)  ; SQL command execute INSERT NEW
        UpdateNotas(1)
      EndIf
    ElseIf GetGadgetState(LsI_Notas) >= 0
      If MessageRequester("Questão?","Deseja subscrever a nota ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        Define Texto$ = "UPDATE NotasDB SET DataModificado = '" + Str(Date()) + "', Nota = '" + GetScintillaAllText(Scintilla_0)
        Texto$ + "', Formato = '" + GetScintillaFormat(Scintilla_0) + "' WHERE NotasID = '" + GetGadgetItemText(LsI_Notas,GetGadgetState(LsI_Notas))+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)  ; SQL command execute UPDATE SET 
        UpdateNotas(1)
      EndIf
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf

EndProcedure

;Apaga notas (Botão Apagar)
Procedure Apagar_Nota()
  
  If DatabaseConnected = #True
    If (GetGadgetState(LsI_Notas) >= 0)
      If MessageRequester("Questão?","Deseja apagar a nota ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        Define Texto$ = "DELETE FROM NotasDB WHERE NotasID = '" + GetGadgetItemText(LsI_Notas,GetGadgetState(LsI_Notas))+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        SetGadgetState(LsI_Notas, -1)
        ScintillaSendMessage(Scintilla_0, #SCI_CLEARALL)   
        UpdateNotas(1)
      EndIf
    Else
      ScintillaSendMessage(Scintilla_0, #SCI_CLEARALL)   
    EndIf      
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf        
EndProcedure       

; Update da Lista de Scrum
Procedure UpdateScrumLista()
  
  ScrumLista()\Sprint = GetGadgetText(Cob_Scrum)
  ScrumLista()\ScrumInicio = GetGadgetState(#Date_2)
  ScrumLista()\ScrumFim = GetGadgetState(#Date_3)
  
  If GetGadgetState(#Ckb_Scrum) = #PB_Checkbox_Checked ; Update Feito no Scrum
    ScrumLista()\ScrumFeito = 1
  Else
    ScrumLista()\ScrumFeito = 0
  EndIf       
  
  ScrumLista()\ScrumFeitoDef = GetGadgetText(#Edt_ScrumDef)
  ScrumLista()\ScrumLog = GetScintillaAllText(Scintilla_1)
  
  If GetGadgetState(Cob_Scrum) >= 0
    ScrumLista()\ScrumID = GetGadgetItemData(Cob_Scrum, GetGadgetState(Cob_Scrum))
  Else
    ScrumLista()\ScrumID = 0
  EndIf
  
EndProcedure

;Adiciona SPRINTS (botão btn_OKScrum)
Procedure OK_Sprint()
  
  Protected NumChar.l = Len(GetGadgetText(Cob_SCrum))
  
  If DatabaseConnected = #True
    If (GetGadgetState(Cob_SCrum) < 0) And (NumChar > 0)
      If MessageRequester("Questão?","Deseja criar um novo Sprint de Scrum ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        
        AddElement(ScrumLista())
        UpdateScrumLista()
                   
        Protected Texto$ = "INSERT INTO ScrumDB (Sprint, DataInicio, DataFim, SprintFeito, FeitoDef, RetrosP) VALUES ('" + ScrumLista()\Sprint
        Texto$ + "', '" + Str(ScrumLista()\ScrumInicio) + "', '" + Str(ScrumLista()\ScrumFim) + "', '"     
        Texto$ + Str(ScrumLista()\ScrumFeito) + "', '" + ScrumLista()\ScrumFeitoDef + "', '" + ScrumLista()\ScrumLog + "')"
        CheckDatabaseUpdate(#MyDatabase, Texto$)  ; SQL command execute INSERT NEW
        
        If DatabaseQuery(#MyDATABASE, "SELECT * FROM ScrumDB WHERE Sprint = '" + ScrumLista()\Sprint +"'", #PB_Database_StaticCursor) 
          While NextDatabaseRow(#MyDATABASE)                  
            ScrumLista()\ScrumID = GetDatabaseLong(#MyDATABASE, 0)
          Wend
          FinishDatabaseQuery(#MyDATABASE)
        EndIf
        
        AddGadgetItem(Cob_Scrum, -1, ScrumLista()\Sprint)       ;Adiciona à ComboBox TAB#1 SCRUM
        SetGadgetItemData(Cob_Scrum, CountGadgetItems(Cob_Scrum) - 1, ScrumLista()\ScrumID)
        SetGadgetState(Cob_Scrum, CountGadgetItems(Cob_Scrum) - 1)
        
        If ScrumLista()\ScrumFeito = 0
          AddGadgetItem(TaskScrum, -1, ScrumLista()\Sprint)       ;Adiciona à ComboBox TAB#3 TAREFAS
          SetGadgetItemData(TaskScrum, CountGadgetItems(TaskScrum) - 1, ScrumLista()\ScrumID)
        EndIf
      EndIf
    ElseIf GetGadgetState(Cob_SCrum) >= 0
      If MessageRequester("Questão?","Deseja atualizar o Sprint ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        
        UpdateScrumLista()
        
        Texto$ = "UPDATE ScrumDB SET Sprint = '" + ScrumLista()\Sprint + "', DataInicio = '" + Str(ScrumLista()\ScrumInicio)
        Texto$ + "', DataFim = '" + Str(ScrumLista()\ScrumFim)
        Texto$ +  "', SprintFeito = '" + Str(ScrumLista()\ScrumFeito) +  "', FeitoDef = '" + ScrumLista()\ScrumFeitoDef
        Texto$ +  "', RetrosP = '" + ScrumLista()\ScrumLog + "' WHERE ScrumID = '" + ScrumLista()\ScrumID+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)  ; SQL command execute UPDATE SET 
        SetGadgetItemText(Cob_SCrum,GetGadgetState(Cob_Scrum),ScrumLista()\Sprint)
        If ScrumLista()\ScrumFeito = 0
          Protected x.l = 0
          Protected Exists.l = -1
          While x < CountGadgetItems(TaskScrum)
            If GetGadgetItemData(TaskScrum, x) = ScrumLista()\ScrumID
              Exists = x
            EndIf
            x + 1
          Wend
          If Exists < 0
            AddGadgetItem(TaskScrum, Exists, ScrumLista()\Sprint)
            SetGadgetItemData(TaskScrum, CountGadgetItems(TaskScrum) -1 , ScrumLista()\ScrumID)
            SetGadgetState(TaskScrum, -1)           
          Else
            SetGadgetItemText(TaskScrum,Exists ,ScrumLista()\Sprint)
          EndIf
        Else
          x = 0
          While x < CountGadgetItems(TaskScrum)
            If GetGadgetItemData(TaskScrum, x) = ScrumLista()\ScrumID
              RemoveGadgetItem(TaskScrum,x)
              SetGadgetState(TaskScrum, -1)
            EndIf
            x + 1
          Wend
        EndIf         
      EndIf
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf

EndProcedure

;Apaga SPRINTS (botão btn_DelScrum)
Procedure Del_Sprint()
  
   If DatabaseConnected = #True
    If (GetGadgetState(Cob_Scrum) >= 0)
      If MessageRequester("Questão?","Deseja apagar o Sprint ?", #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        ;Apaga de ScrumDB
        Protected Texto$ = "DELETE FROM ScrumDB WHERE ScrumID = '" + GetGadgetItemData(Cob_Scrum,GetGadgetState(Cob_Scrum))+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        ;Apaga de ScrumBoardDB
        Texto$ = "DELETE FROM ScrumBoardDB WHERE ScrumID = '" + GetGadgetItemData(Cob_Scrum,GetGadgetState(Cob_Scrum))+"'"
        CheckDatabaseUpdate(#MyDatabase, Texto$)
        RemoveGadgetItem(Cob_Scrum, GetGadgetState(Cob_Scrum))
        
        If ScrumLista()\ScrumFeito = 0
          Protected x.l = 0
          While x < CountGadgetItems(TaskScrum)
            If GetGadgetItemData(TaskScrum, x) = ScrumLista()\ScrumID
              RemoveGadgetItem(TaskScrum, x) ; Também apaga nesta ComboBox das tarefas se existir
              SetGadgetState(TaskScrum, -1 )                         ; Reinicia esta ComboBox nas tarefas
            EndIf
            x + 1
          Wend
        EndIf
        
        DeleteElement(ScrumLista(),1)         ;Apaga o elemento na ScrumLista e passa para o seguinte
        SetGadgetState(Cob_Scrum, ListIndex(ScrumLista()))       
        UpdateScrum() 
      EndIf
    EndIf      
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf    

EndProcedure

Procedure AddTaskToScrum()
  
  Define HasRows.l = 0
  
  If DatabaseConnected = #True
    If GetGadgetState(TaskScrum) > -1     ;Se houver um Sprint selecionado na ComboBox Scrum da TAB#3 - Tarefas
      
      If DatabaseQuery(#MyDATABASE, "SELECT * FROM ScrumBoardDB WHERE ScrumID = '" + Str(GetGadgetItemData(TaskScrum, GetGadgetState(TaskScrum))) + "' AND Task = '" + Str(TarefasLista()\TarefaID) + "'")      
        HasRows = NextDatabaseRow(#MyDATABASE)
        FinishDatabaseQuery(#MyDATABASE)
        
        If HasRows > 0        ; Se já houver registos
          Protected Texto$ = "A tarefa já se encontra adicionada!" + #CRLF$ + "   Deseja removê-la do Sprint ?"
          If MessageRequester("Questão?", Texto$, #PB_MessageRequester_Warning | #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
            Texto$ = "DELETE FROM ScrumBoardDB WHERE ScrumID = '" + Str(GetGadgetItemData(TaskScrum, GetGadgetState(TaskScrum))) + "' AND Task = '" + Str(TarefasLista()\TarefaID) + "'"          
            CheckDatabaseUpdate(#MyDatabase, Texto$)
            UpdateScrum()
          EndIf
        Else         ;Se não houver registos
          Texto$ = "INSERT INTO ScrumBoardDB (ScrumID, Task, Status) VALUES ('" + Str(GetGadgetItemData(TaskScrum, GetGadgetState(TaskScrum)))
          Texto$ +  "', '" + Str(TarefasLista()\TarefaID) + "', '0')"
          CheckDatabaseUpdate(#MyDatabase, Texto$)
          UpdateScrum()
        EndIf    
        
      EndIf
      
    EndIf
  Else
    MessageRequester("Info","Por favor, crie uma nova Base de Dados primeiro !")
  EndIf  
  
EndProcedure

;Para informação >>>>>>> Funcionalidades a implementar !
Procedure ParaImplementar()
  
  MessageRequester("Info","Funcionalidade a ser implementada !")
  
EndProcedure



; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 21
; Folding = ----
; EnableXP