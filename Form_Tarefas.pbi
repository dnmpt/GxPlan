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
;¦ Formulary derived from the automatic file 'Form_Tarefas.pbf' costumized       ¦
;¦ for variables, declarations, etc. This is the form file to be included.       ¦
;+-------------------------------------------------------------------------------+ 


;DEPRECATED ------------------>>>>>>>>>>>>>>>>>>>>   InitScintilla()

Global Window_0

Global Panel_0, LsI_Horas, Calendar_0, LsI_Dia, Frame_6, Btn_Timer, Btn_Finish, LsI_Scrum, Cob_Scrum, Scintilla_1, Frame_7, Frame_8, ListaProjetos, ProjStrNome, ListaTarefasProj, PrBar_Proj, TipoCombo, Date_Proj_i, Date_Proj_f, Chk_Proj_Terminado, Frame_1, TaskNome, TaskProjeto, TrackBar_1, TrackBar_2, TrackBar_3, TrackBar_4, LsI_Tarefas, TaskCusto, Date_0, Date_1, TaskConcluido, Frame_3, TaskScrum, TaskBtnSubscrever, TaskBtnApagar, TaskBtnNovo, LsI_Notas, Scintilla_0, Txt_NotasLinhasChars

Global Img_Window_0_0, Img_Window_0_1, Img_Window_0_2, Img_Window_0_3, Img_Window_0_4, Img_Window_0_5, Img_Window_0_6, Img_Window_0_7, Img_Window_0_8, Img_Window_0_9, Img_Window_0_10, Img_Window_0_11, Img_Window_0_12, Img_Window_0_13

Enumeration FormGadget
  #Img_Podium
  #Text_32
  #Text_33
  #Btn_HoraAdd
  #Btn_HoraDel
  #Txt_1st
  #Txt_2nd
  #Txt_3rd
  #Txt_DataSel
  #Img_HasNotesDia
  #Text_39
  #Date_2
  #Date_3
  #Text_40
  #Text_41
  #ProgressBar_0
  #Text_42
  #Text_43
  #Text_44
  #Txt_InfoSrum
  #Btn_OKScrum
  #Btn_DelScrum
  #Ckb_Scrum
  #Text_47
  #Text_48
  #Btn_BackScrum
  #Btn_ForwardScrum
  #Text_49
  #Edt_ScrumDef
  #Text_1
  #Text_0
  #Frame_0
  #Button_0
  #Text_5
  #Button_1
  #Button_2
  #Text_3
  #Text_4
  #Text_2
  #Text_6
  #Text_7
  #Text_30
  #Text_36
  #Text_8
  #Text_9
  #Text_10
  #Text__5
  #Text_12
  #TaskValor
  #Text_14
  #TaskUrgencia
  #Text_16
  #TaskCompliance
  #Text_18
  #TaskEsforco
  #Text_20
  #TaskPrioridade
  #Text_22
  #Text_24
  #Text_26
  #Text_27
  #Text_28
  #TaskScrumAdd
  #Text_29
  #Cnv_Matrix_PvU
  #Opt_SortUnDone
  #Opt_SortRel
  #Opt_SortDone
  #Opt_SortAll
  #Txt_TaskPerc
  #Img_HasNotes
  #Btn_Sct_Normal
  #Btn_Sct_Bold
  #Btn_Sct_Italic
  #Btn_Sct_Title
  #Btn_Sct_Code
  #Btn_Sct_OK
  #Btn_Sct_Apagar
  #Btn_Sct_Highl
  #TxtTaskNotes
  #ImgNotesOld
  #ImgNotesNew
  #Text_38
  #LsI_TimeProj
  #LsI_TimeTask
  #Txt_Calendario
EndEnumeration

Enumeration FormMenu
  #MenuItem_1
  #MenuItem_2
  #MenuItem_3
  #MenuItem_4
  #MenuItem_19
  #MenuItem_20
  #MenuItem_21
  #MenuItem_10
  #MenuItem_22
  #MenuItem_23
  #MenuItem_24
  #MenuItem_25
  #MenuItem_26
  #MenuItem_27
  #MenuItem_28
  #MenuItem_16
  #MenuItem_17
  #MenuItem_18
  #MenuItem_29
  #MenuItem_14
EndEnumeration

UseJPEGImageDecoder()
UsePNGImageDecoder()

Img_Window_0_0 = LoadImage(#PB_Any,"icons\crono.png")
Img_Window_0_1 = LoadImage(#PB_Any,"icons\podium.jpg")
Img_Window_0_2 = LoadImage(#PB_Any,"icons\Done.jpg")
Img_Window_0_3 = LoadImage(#PB_Any,"icons\Normal.png")
Img_Window_0_4 = LoadImage(#PB_Any,"icons\Bold.png")
Img_Window_0_5 = LoadImage(#PB_Any,"icons\italic.png")
Img_Window_0_6 = LoadImage(#PB_Any,"icons\Title.png")
Img_Window_0_7 = LoadImage(#PB_Any,"icons\Code.png")
Img_Window_0_8 = LoadImage(#PB_Any,"icons\highlighted.png")
Img_Window_0_9 = LoadImage(#PB_Any,"icons\OldNote.png")
Img_Window_0_10 = LoadImage(#PB_Any,"icons\NewNote.png")
Img_Window_0_11 = LoadImage(#PB_Any,"icons\notes.jpg")
Img_Window_0_12 = LoadImage(#PB_Any,"icons\previous.png")
Img_Window_0_13 = LoadImage(#PB_Any,"icons\next.png")


;Declaration of needed Procedures - CallBacks Scintilla
Declare ScintillaCallBack(MyGadget, *scinotify.SCNotification) 
Declare Callback_Scintilla_1(MyGadget, *scinotify.SCNotification)


Procedure OpenWindow_0(x = 0, y = 0, width = 1008, height = 552)
  Window_0 = OpenWindow(#PB_Any, x, y, width, height, "GxPlan - Plan in Compliance", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_N, #MenuItem_1)
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_O, #MenuItem_2)
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_Q, #MenuItem_3)

  CreateStatusBar(0, WindowID(Window_0))
  AddStatusBarField(1000)
  StatusBarText(0, 0, "Status:")
  CreateMenu(0, WindowID(Window_0))
  MenuTitle("Ficheiro")
  MenuItem(#MenuItem_1, "Novo" + Chr(9) + "Ctrl+N")
  MenuItem(#MenuItem_2, "Abrir" + Chr(9) + "Ctrl+O")
  MenuBar()
  MenuItem(#MenuItem_3, "Sair" + Chr(9) + "Ctrl+Q")
  MenuTitle("Editar")
  OpenSubMenu("Projeto")
  MenuItem(#MenuItem_4, "Edição")
  OpenSubMenu("Classificar")
  MenuItem(#MenuItem_19, "Nome")
  MenuItem(#MenuItem_20, "Data de Conclusão")
  MenuItem(#MenuItem_21, "Ordem")
  CloseSubMenu()
  CloseSubMenu()
  OpenSubMenu("Tarefa")
  MenuItem(#MenuItem_10, "Edição")
  OpenSubMenu("Classificar")
  MenuItem(#MenuItem_22, "Nome")
  MenuItem(#MenuItem_23, "Data de Conclusão")
  MenuItem(#MenuItem_24, "Estado")
  MenuItem(#MenuItem_25, "Prioridade")
  MenuItem(#MenuItem_26, "Urgência")
  MenuItem(#MenuItem_27, "Esforço")
  MenuItem(#MenuItem_28, "Ordem")
  CloseSubMenu()
  CloseSubMenu()
  OpenSubMenu("Categoria")
  MenuItem(#MenuItem_16, "Adicionar")
  MenuItem(#MenuItem_17, "Eliminar")
  MenuItem(#MenuItem_18, "Renomear")
  MenuTitle("Ajuda")
  MenuItem(#MenuItem_29, "Créditos")
  MenuItem(#MenuItem_14, "Acerca")
  CloseSubMenu()
  Panel_0 = PanelGadget(#PB_Any, -8, 1, 1016, 506)
  AddGadgetItem(Panel_0, -1, "Dia")
  ImageGadget(#Img_Podium, 680, 56, 220, 118, ImageID(Img_Window_0_1))
  LsI_Horas = ListIconGadget(#PB_Any, 24, 50, 304, 377, "Hora", 60, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(LsI_Horas, 1, "Tarefa", 250)
  AddGadgetItem(LsI_Horas, -1, "0h00")
  AddGadgetItem(LsI_Horas, -1, "1h00", 0, 1)
  AddGadgetItem(LsI_Horas, -1, "2h00", 0, 2)
  AddGadgetItem(LsI_Horas, -1, "3h00", 0, 3)
  AddGadgetItem(LsI_Horas, -1, "4h00", 0, 4)
  AddGadgetItem(LsI_Horas, -1, "5h00", 0, 5)
  AddGadgetItem(LsI_Horas, -1, "6h00", 0, 6)
  AddGadgetItem(LsI_Horas, -1, "7h00", 0, 7)
  AddGadgetItem(LsI_Horas, -1, "8h00", 0, 8)
  AddGadgetItem(LsI_Horas, -1, "9h00", 0, 9)
  AddGadgetItem(LsI_Horas, -1, "10h00", 0, 10)
  AddGadgetItem(LsI_Horas, -1, "11h00", 0, 11)
  AddGadgetItem(LsI_Horas, -1, "12h00", 0, 12)
  AddGadgetItem(LsI_Horas, -1, "13h00", 0, 13)
  AddGadgetItem(LsI_Horas, -1, "14h00", 0, 14)
  AddGadgetItem(LsI_Horas, -1, "15h00", 0, 15)
  AddGadgetItem(LsI_Horas, -1, "16h00", 0, 16)
  AddGadgetItem(LsI_Horas, -1, "17h00", 0, 17)
  AddGadgetItem(LsI_Horas, -1, "18h00", 0, 18)
  AddGadgetItem(LsI_Horas, -1, "19h00", 0, 19)
  AddGadgetItem(LsI_Horas, -1, "20h00", 0, 20)
  AddGadgetItem(LsI_Horas, -1, "21h00", 0, 21)
  AddGadgetItem(LsI_Horas, -1, "22h00", 0, 22)
  AddGadgetItem(LsI_Horas, -1, "23h00", 0, 23)
  Calendar_0 = CalendarGadget(#PB_Any, 344, 8, 312, 200, 0, #PB_Calendar_Borderless)
  LsI_Dia = ListIconGadget(#PB_Any, 352, 246, 648, 224, "#", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(LsI_Dia, 1, "Nome", 250)
  AddGadgetColumn(LsI_Dia, 2, "Prioridade", 80)
  AddGadgetColumn(LsI_Dia, 3, "Decorrido", 80)
  AddGadgetColumn(LsI_Dia, 4, "Atraso", 80)
  AddGadgetColumn(LsI_Dia, 5, "Projeto", 250)
  TextGadget(#Text_32, 672, 6, 80, 20, "PRIORITÁRIAS")
  TextGadget(#Text_33, 352, 222, 80, 20, "Tarefas")
  Frame_6 = FrameGadget(#PB_Any, 16, 6, 320, 466, "")
  ButtonGadget(#Btn_HoraAdd, 216, 440, 80, 20, "Adicionar")
  ButtonGadget(#Btn_HoraDel, 48, 440, 80, 20, "Retirar")
  Btn_Timer = ButtonImageGadget(#PB_Any, 944, 190, 48, 48, ImageID(Img_Window_0_0), #PB_Button_Toggle)
  GadgetToolTip(Btn_Timer, "Cronometrar")
  Btn_Finish = ButtonImageGadget(#PB_Any, 880, 190, 48, 48, ImageID(Img_Window_0_2))
  GadgetToolTip(Btn_Finish, "Terminado")
  TextGadget(#Txt_1st, 758, 10, 130, 48, "", #PB_Text_Center)
  TextGadget(#Txt_2nd, 670, 50, 96, 44, "", #PB_Text_Center)
  TextGadget(#Txt_3rd, 880, 50, 98, 48, "", #PB_Text_Center)
  TextGadget(#Txt_DataSel, 24, 22, 304, 20, "")
  ImageGadget(#Img_HasNotesDia, 816, 190, 46, 48, ImageID(Img_Window_0_11))
  HideGadget(#Img_HasNotesDia, 1)
  GadgetToolTip(#Img_HasNotesDia, "Existem Notas !")
  AddGadgetItem(Panel_0, -1, "Scrum", 0, 1)
  LsI_Scrum = ListIconGadget(#PB_Any, 24, 86, 968, 207, "A Fazer", 320, #PB_ListIcon_GridLines)
  AddGadgetColumn(LsI_Scrum, 1, "Em Curso", 320)
  AddGadgetColumn(LsI_Scrum, 2, "Feito", 320)
  Cob_Scrum = ComboBoxGadget(#PB_Any, 96, 46, 424, 20, #PB_ComboBox_Editable)
  TextGadget(#Text_39, 32, 46, 56, 20, "SPRINT :")
  DateGadget(#Date_2, 632, 14, 120, 20, "%dd/%mm/%yyyy")
  DateGadget(#Date_3, 632, 46, 120, 20, "%dd/%mm/%yyyy")
  TextGadget(#Text_40, 544, 14, 80, 20, "Início :", #PB_Text_Right)
  TextGadget(#Text_41, 544, 46, 80, 20, "Fim :", #PB_Text_Right)
  Scintilla_1 = ScintillaGadget(#PB_Any, 296, 326, 520, 146, @Callback_Scintilla_1())
  ProgressBarGadget(#ProgressBar_0, 832, 334, 160, 21, 0, 0)
  TextGadget(#Text_42, 24, 366, 112, 20, "Definição de Feito:")
  TextGadget(#Text_43, 296, 302, 96, 20, "Retrospectiva :")
  TextGadget(#Text_44, 832, 302, 160, 20, "Progresso e Estatística", #PB_Text_Center)
  TextGadget(#Txt_InfoSrum, 832, 366, 160, 105, "", #PB_Text_Border)
  ButtonGadget(#Btn_OKScrum, 904, 14, 80, 20, "OK")
  ButtonGadget(#Btn_DelScrum, 904, 46, 80, 20, "Apagar")
  CheckBoxGadget(#Ckb_Scrum, 816, 46, 24, 20, "")
  TextGadget(#Text_47, 784, 14, 80, 20, "Terminado :", #PB_Text_Center)
  Frame_7 = FrameGadget(#PB_Any, 24, 0, 968, 78, "")
  TextGadget(#Text_48, 32, 14, 488, 20, "SCRUM BOARD", #PB_Text_Center | #PB_Text_Border)
  SetGadgetColor(#Text_48, #PB_Gadget_FrontColor,RGB(255,255,255))
  SetGadgetColor(#Text_48, #PB_Gadget_BackColor,RGB(0,0,255))
  ButtonImageGadget(#Btn_BackScrum, 104, 310, 72, 39, ImageID(Img_Window_0_12))
  GadgetToolTip(#Btn_BackScrum, "Passo Atrás")
  ButtonImageGadget(#Btn_ForwardScrum, 192, 310, 72, 39, ImageID(Img_Window_0_13))
  GadgetToolTip(#Btn_ForwardScrum, "Passo à Frente")
  Frame_8 = FrameGadget(#PB_Any, 24, 294, 256, 64, "")
  TextGadget(#Text_49, 32, 318, 64, 24, "Controlos")
  EditorGadget(#Edt_ScrumDef, 24, 390, 256, 80, #PB_Editor_WordWrap)
  AddGadgetItem(Panel_0, -1, "Projetos", 0, 2)
  TextGadget(#Text_1, 8, 8, 80, 20, "Projetos")
  ListaProjetos = ListIconGadget(#PB_Any, 8, 22, 688, 192, "Projetos", 100, #PB_ListIcon_AlwaysShowSelection)
  TextGadget(#Text_0, 710, 54, 278, 20, "EDITAR", #PB_Text_Center)
  ProjStrNome = StringGadget(#PB_Any, 708, 102, 280, 24, "")
  FrameGadget(#Frame_0, 704, 70, 288, 177, "")
  ButtonGadget(#Button_0, 902, 220, 80, 20, "Apagar")
  ListaTarefasProj = ListIconGadget(#PB_Any, 8, 254, 688, 216, "#", 40, #PB_ListIcon_CheckBoxes | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(ListaTarefasProj, 1, "Nome", 250)
  AddGadgetColumn(ListaTarefasProj, 2, "Esforço", 80)
  AddGadgetColumn(ListaTarefasProj, 3, "Prioridade", 80)
  AddGadgetColumn(ListaTarefasProj, 4, "Custo (€)", 80)
  AddGadgetColumn(ListaTarefasProj, 5, "Início", 80)
  AddGadgetColumn(ListaTarefasProj, 6, "Fim", 80)
  PrBar_Proj = ProgressBarGadget(#PB_Any, 704, 448, 288, 20, 0, 100)
  TextGadget(#Text_5, 704, 424, 288, 20, "Progresso", #PB_Text_Center)
  ButtonGadget(#Button_1, 808, 220, 80, 20, "Subscrever")
  ButtonGadget(#Button_2, 714, 220, 80, 20, "Novo")
  TextGadget(#Text_3, 730, 134, 104, 20, "Data de início :", #PB_Text_Center)
  TextGadget(#Text_4, 862, 134, 104, 20, "Data de Fim :", #PB_Text_Center)
  TextGadget(#Text_2, 8, 232, 80, 20, "Tarefas")
  TipoCombo = ComboBoxGadget(#PB_Any, 708, 28, 284, 25)
  TextGadget(#Text_6, 708, 10, 284, 18, "CATEGORIA", #PB_Text_Center)
  TextGadget(#Text_7, 708, 78, 100, 20, "Nome :")
  Date_Proj_i = DateGadget(#PB_Any, 718, 157, 120, 25, "%dd/%mm/%yyyy")
  Date_Proj_f = DateGadget(#PB_Any, 858, 157, 120, 25, "%dd/%mm/%yyyy")
  Chk_Proj_Terminado = CheckBoxGadget(#PB_Any, 898, 190, 30, 25, "")
  TextGadget(#Text_30, 748, 190, 120, 25, "Projeto TERMINADO")
  TextGadget(#Text_36, 758, 320, 190, 25, "(Informações dos Projetos)", #PB_Text_Center)
  AddGadgetItem(Panel_0, -1, "Tarefas", 0, 3)
  Frame_1 = FrameGadget(#PB_Any, 16, 22, 984, 168, "")
  TextGadget(#Text_8, 16, 232, 80, 20, "Tarefas")
  TextGadget(#Text_9, 16, 6, 80, 20, "EDITAR")
  TextGadget(#Text_10, 24, 38, 80, 20, "NOME :")
  TaskNome = StringGadget(#PB_Any, 122, 38, 544, 20, "")
  TextGadget(#Text__5, 672, 38, 80, 20, "Projeto :")
  TaskProjeto = ComboBoxGadget(#PB_Any, 760, 38, 232, 20)
  TextGadget(#Text_12, 24, 78, 80, 20, "Valor", #PB_Text_Center)
  TextGadget(#TaskValor, 112, 110, 76, 24, "", #PB_Text_Center | #PB_Text_Border)
  TextGadget(#Text_14, 240, 78, 80, 20, "Urgência", #PB_Text_Center)
  TextGadget(#TaskUrgencia, 328, 110, 80, 24, "", #PB_Text_Center | #PB_Text_Border)
  TextGadget(#Text_16, 456, 78, 80, 20, "Conformidade", #PB_Text_Center)
  TextGadget(#TaskCompliance, 544, 110, 84, 24, "", #PB_Text_Center | #PB_Text_Border)
  TextGadget(#Text_18, 664, 78, 80, 20, "Esforço", #PB_Text_Center)
  TextGadget(#TaskEsforco, 752, 110, 76, 24, "", #PB_Text_Center | #PB_Text_Border)
  TrackBar_1 = TrackBarGadget(#PB_Any, 24, 110, 80, 20, 1, 5, #PB_TrackBar_Ticks)
  TrackBar_2 = TrackBarGadget(#PB_Any, 240, 110, 80, 20, 1, 5, #PB_TrackBar_Ticks)
  TrackBar_3 = TrackBarGadget(#PB_Any, 456, 110, 80, 20, 1, 5, #PB_TrackBar_Ticks)
  TrackBar_4 = TrackBarGadget(#PB_Any, 664, 110, 80, 20, 1, 5, #PB_TrackBar_Ticks)
  LsI_Tarefas = ListIconGadget(#PB_Any, 16, 252, 582, 208, "#", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(LsI_Tarefas, 1, "Nome", 250)
  AddGadgetColumn(LsI_Tarefas, 2, "Prioridade", 70)
  AddGadgetColumn(LsI_Tarefas, 3, "Feita", 50)
  AddGadgetColumn(LsI_Tarefas, 4, "Dia", 40)
  AddGadgetColumn(LsI_Tarefas, 5, "Scrum", 715)
  TextGadget(#Text_20, 880, 78, 80, 20, "PRIORIDADE", #PB_Text_Center)
  TextGadget(#TaskPrioridade, 880, 102, 80, 32, "", #PB_Text_Center | #PB_Text_Border)
  TextGadget(#Text_22, 24, 150, 80, 20, "Custo")
  TaskCusto = SpinGadget(#PB_Any, 112, 150, 128, 20, 0, 100000, #PB_Spin_Numeric)
  TextGadget(#Text_24, 248, 150, 16, 20, "€")
  Date_0 = DateGadget(#PB_Any, 424, 150, 104, 20, "%dd/%mm/%yyyy")
  TextGadget(#Text_26, 328, 150, 88, 20, "Data de Início :")
  TextGadget(#Text_27, 576, 150, 80, 20, "Data de Fim :")
  Date_1 = DateGadget(#PB_Any, 664, 150, 104, 20, "%dd/%mm/%yyyy")
  TaskConcluido = CheckBoxGadget(#PB_Any, 920, 134, 40, 48, "")
  TextGadget(#Text_28, 800, 150, 96, 20, "CONCLUÍDO :")
  ButtonGadget(#TaskScrumAdd, 504, 206, 80, 40, "Adicionar ao Scrum", #PB_Button_MultiLine)
  Frame_3 = FrameGadget(#PB_Any, 96, 190, 504, 64, "")
  TextGadget(#Text_29, 16, 198, 80, 20, "Scrum :")
  TaskScrum = ComboBoxGadget(#PB_Any, 104, 214, 392, 20)
  TaskBtnSubscrever = ButtonGadget(#PB_Any, 616, 198, 80, 20, "Subscrever")
  TaskBtnApagar = ButtonGadget(#PB_Any, 616, 230, 80, 20, "Apagar")
  TaskBtnNovo = ButtonGadget(#PB_Any, 712, 198, 80, 49, "Nova")
  CanvasGadget(#Cnv_Matrix_PvU, 708, 257, 290, 210)
  OptionGadget(#Opt_SortUnDone, 608, 297, 100, 25, "Em curso")
  OptionGadget(#Opt_SortRel, 608, 267, 100, 25, "Relacionadas")
  OptionGadget(#Opt_SortDone, 608, 327, 100, 25, "Concluídas")
  OptionGadget(#Opt_SortAll, 608, 357, 100, 25, "Todas")
  TextGadget(#Txt_TaskPerc, 608, 427, 90, 40, "", #PB_Text_Center | #PB_Text_Border)
  ImageGadget(#Img_HasNotes, 952, 206, 38, 40, ImageID(Img_Window_0_11))
  HideGadget(#Img_HasNotes, 1)
  GadgetToolTip(#Img_HasNotes, "Existem notas !")
  AddGadgetItem(Panel_0, -1, "Notas", 0, 4)
  LsI_Notas = ListIconGadget(#PB_Any, 24, 28, 960, 128, "#", 40, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(LsI_Notas, 1, "Criada", 100)
  AddGadgetColumn(LsI_Notas, 2, "Modificada", 100)
  AddGadgetColumn(LsI_Notas, 3, "Resumo", 715)
  Scintilla_0 = ScintillaGadget(#PB_Any, 24, 206, 960, 264, @ScintillaCallBack())
  ButtonImageGadget(#Btn_Sct_Normal, 40, 167, 32, 29, ImageID(Img_Window_0_3))
  GadgetToolTip(#Btn_Sct_Normal, "Normal")
  ButtonImageGadget(#Btn_Sct_Bold, 88, 167, 32, 29, ImageID(Img_Window_0_4))
  GadgetToolTip(#Btn_Sct_Bold, "Negrito")
  ButtonImageGadget(#Btn_Sct_Italic, 140, 167, 32, 29, ImageID(Img_Window_0_5))
  GadgetToolTip(#Btn_Sct_Italic, "Itálico")
  ButtonImageGadget(#Btn_Sct_Title, 190, 167, 32, 29, ImageID(Img_Window_0_6))
  GadgetToolTip(#Btn_Sct_Title, "Título")
  ButtonImageGadget(#Btn_Sct_Code, 240, 167, 32, 29, ImageID(Img_Window_0_7))
  GadgetToolTip(#Btn_Sct_Code, "Código")
  ButtonGadget(#Btn_Sct_OK, 908, 167, 50, 31, "OK")
  ButtonGadget(#Btn_Sct_Apagar, 824, 167, 54, 31, "Apagar")
  ButtonImageGadget(#Btn_Sct_Highl, 290, 167, 32, 30, ImageID(Img_Window_0_8))
  GadgetToolTip(#Btn_Sct_Highl, "Realçado")
  TextGadget(#TxtTaskNotes, 24, 6, 952, 20, "")
  ImageGadget(#ImgNotesOld, 760, 166, 38, 40, ImageID(Img_Window_0_9))
  HideGadget(#ImgNotesOld, 1)
  GadgetToolTip(#ImgNotesOld, "Editar Nota")
  ImageGadget(#ImgNotesNew, 760, 166, 38, 40, ImageID(Img_Window_0_10))
  GadgetToolTip(#ImgNotesNew, "Nova Nota")
  TextGadget(#Text_38, 536, 174, 104, 20, "Linhas/Caracteres :", #PB_Text_Right)
  Txt_NotasLinhasChars = TextGadget(#PB_Any, 648, 174, 96, 20, "", #PB_Text_Center | #PB_Text_Border)
  AddGadgetItem(Panel_0, -1, "Tempos", 0, 5)
  AddGadgetItem(Panel_0, -1, "Calendário", 0, 6)
  ListIconGadget(#LsI_TimeProj, 24, 30, 968, 217, "#", 40, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(#LsI_TimeProj, 1, "Projeto", 190)
  AddGadgetColumn(#LsI_TimeProj, 2, "Calendário / 'Timelines'", 1750)
  
  If LoadFont(0,"Courier New",9)
    SetGadgetFont(#PB_Default, FontID(0))   ; Set the loaded Courier 9 font as new standard
  EndIf
  
  ListIconGadget(#LsI_TimeTask, 24, 257, 968, 213, "#", 40, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#LsI_TimeTask, 1, "Tarefa", 190)
  AddGadgetColumn(#LsI_TimeTask, 2, "Calendário / 'Timelines'", 1750)
  
  If LoadFont(1,"Courier New",9, #PB_Font_Bold)
    SetGadgetFont(#PB_Default, FontID(1))
  EndIf
  
  TextGadget(#Txt_Calendario, 28, 7, 300, 20, "", #PB_Text_Center | #PB_Text_Border)
  
  SetGadgetFont(#PB_Default, #PB_Default)   ; Set Font to original
  
  CloseGadgetList()
EndProcedure


; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 169
; FirstLine = 150
; Folding = -
; EnableXP