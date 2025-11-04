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
;║ Scintilla gadget for SCRUM as footnote gadget.                                ║
;╚═══════════════════════════════════════════════════════════════════════════════╝ 

; Style "0" - Normal                                           
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 0, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 0, 9)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 0, RGB(0,0,0))       
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 0, RGB(255, 255, 255))

; Style "1" - Bold                                              
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, 1, @"Arial")
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, 1, 9)
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFORE, 1, RGB(0,0,0))       
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBACK, 1, RGB(211, 211, 211))
  ScintillaSendMessage(MyGadget, #SCI_STYLESETBOLD, 1, #SC_WEIGHT_BOLD)    

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
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINWIDTHN, #MARGIN_FOOTNOTE_FOLD_INDEX, 0)
  
  ; Margin Type and Mask
  ScintillaSendMessage(MyGadget, #SCI_STYLESETFONT, #STYLE_DEFAULT, @"Courier New") 
  ScintillaSendMessage(MyGadget, #SCI_STYLESETSIZE, #STYLE_DEFAULT, 9) 
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINTYPEN,  #MARGIN_FOOTNOTE_FOLD_INDEX, #SC_MARGIN_SYMBOL)
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINMASKN, #MARGIN_FOOTNOTE_FOLD_INDEX, #SC_MASK_FOLDERS)
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINWIDTHN, #MARGIN_FOOTNOTE_FOLD_INDEX, 20)

; Choose folding icons
  ScintillaSendMessage(MyGadget,#SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_PLUS)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_MINUS)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_EMPTY)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_EMPTY)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_EMPTY)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_EMPTY)
  ScintillaSendMessage(MyGadget, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_EMPTY)
  
; Draw horizontal lines in Folded Lines
  ScintillaSendMessage(MyGadget,#SCI_SETFOLDFLAGS, 16, 0) ; // 16  	Draw line below if not expanded
  
; Tell scintilla we want to be notified about mouse clicks in the margin
  ScintillaSendMessage(MyGadget,#SCI_SETMARGINSENSITIVEN, #MARGIN_FOOTNOTE_FOLD_INDEX, 1);

  
  
  
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 22
; EnableXP