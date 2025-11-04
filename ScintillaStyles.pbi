;╔═══════════════════════════════════════════════════════════════════════════════╗
;║                    ScintillaStyles.pbi  - version 0.33-alpha                  ║
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
;║ Include file with Scintilla text styles and other Scintilla messages.         ║
;║ Scintilla gadget for notes.                                                   ║
;╚═══════════════════════════════════════════════════════════════════════════════╝ 

; Style "0" - Normal                                           
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 0, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 0, 12)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 0, RGB(0,0,0))       
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 0, RGB(255, 255, 255))

; Style "1" - Bold                                              
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 1, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 1, 12)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 1, RGB(0,0,0))       
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 1, RGB(255, 255, 255))
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBOLD, 1, #SC_WEIGHT_BOLD)    

; Style "2" - Itálico                                               
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 2, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 2, 12)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 2, RGB(0,0,0))       
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 2, RGB(255, 255, 255))
  ScintillaSendMessage(MyGadget, #SCI_STYLESETITALIC, 2, 1)      


; Style "3" - Título                                      ; Font "Arial"
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 3, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 3, 18)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 3, RGB(255, 0, 0))       ; Red - RGB (Red, Gree, Blue)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 3, RGB(255, 255, 255))   ; White
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBOLD, 3, #SC_WEIGHT_BOLD)      

;Style "4" - Code                                             ; Font "Courier New"
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 4, @"Courier New")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 4, 12)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 4, RGB(211,211,211))     ;LightGray
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 4, RGB(0,0,255))         ; Blue

;Style "5" - Highlighted                                              ; Font "Courier New"
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 5, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 5, 12)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 5, RGB(0,0,0))     ;LightGray
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 5, RGB(255, 255, 0))         ; Blue 
  
;WRAP MODE
  ScintillaSendMessage(MyGadget, #SCI_SETWRAPMODE, #SC_WRAP_WORD)            ; Line WRAP mode
  
  ; Delete Tab Key For Tab in Scintilla -> Permite o TAB no Scintilla
  RemoveKeyboardShortcut(Window_0, #PB_Shortcut_Tab)                        ;Considerou-se a variável GLOBAL WINDOW_0 como a do Scintilla
  RemoveKeyboardShortcut(Window_0, #PB_Shortcut_Tab | #PB_Shortcut_Shift)
  
;FOLDING STRUCTURE
; Working Fold 
  ScintillaSendMessage(MyGadget, #SCI_SETPROPERTY, @"fold", @"1")
  ScintillaSendMessage(MyGadget, #SCI_SETPROPERTY, @"fold.compact", @"0")
  ;ScintillaSendMessage(MyGadget, #SCI_SETPROPERTY, @"fold.comment", @"1") ; If enable this Line Your Comment get Fold
  ScintillaSendMessage(MyGadget, #SCI_SETPROPERTY, @"fold.preprocessor", @"1")
  
;Resize all the margins To zero
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINWIDTHN, #MARGIN_SCRIPT_FOLD_INDEX, 0)
  
  ; Margin Type and Mask
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, #STYLE_DEFAULT, @"Courier New") 
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, #STYLE_DEFAULT, 9) 
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINTYPEN,  #MARGIN_SCRIPT_FOLD_INDEX, #SC_MARGIN_SYMBOL)
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINMASKN, #MARGIN_SCRIPT_FOLD_INDEX, #SC_MASK_FOLDERS)
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINWIDTHN, #MARGIN_SCRIPT_FOLD_INDEX, 20)
  ScintillaSendMessage(MyGadget, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER) 
  ScintillaSendMessage(MyGadget, #SCI_SETMARGINWIDTHN, 0, 40)

; Choose folding icons
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_BOXMINUS)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_BOXPLUS)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNER)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_BOXPLUSCONNECTED)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_BOXMINUSCONNECTED)
ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNER)
;

; Choose folding icon colours
ScintillaSendMessage(MyGadget, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, RGB(236, 233, 216))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, RGB(236, 233, 216))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, RGB(236, 233, 216))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, RGB(236, 233, 216))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, RGB(128, 128, 128))
ScintillaSendMessage(MyGadget, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, RGB(128, 128, 128))
  
; Draw horizontal lines in Folded Lines
  ScintillaSendMessage(MyGadget,#SCI_SETFOLDFLAGS, 16, 0) ; // 16  	Draw line below if not expanded
  
; Tell scintilla we want to be notified about mouse clicks in the margin
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINSENSITIVEN, #MARGIN_SCRIPT_FOLD_INDEX, 1);

  
  
  
  
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 20
; EnableXP