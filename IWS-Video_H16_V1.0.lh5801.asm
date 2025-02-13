; IWS-Video_H16_V1.0.asm
; IWS Video Interface
;

#define EOW(n8)        .BYTE n8 | $80    ; Sets bit 7 of character

#INCLUDE    "lib/PC-1500.lib"
#INCLUDE    "lib/CE-158.lib"
;#INCLUDE    "lib/CE-158N.lib"
#INCLUDE    "lib/CE-150.lib"
#INCLUDE    "lib/PC-1500_Macros.lib"

; IWS Videointerface RAM map
COLORRAM = $6000 ; $6000~$67FF ME1
GRAPHRAM = $6800 ; $6800~$67FF ME1
VIDEORAM = $7000 ; $7000-$77FF ME1
CRTCTRL  = $7800 ; $7800-$7801 ME1
NOTUSED  = $7802 ; $7802~$7FFF ME1

.ORG $8000

;------------------------------------------------------------------------------------------------------------
; BASIC Command Table 8000
;------------------------------------------------------------------------------------------------------------
;% B_TBL_8000 START
B_TBL_8000:
    .BYTE  $55                                          ; Marker that BASIC Table follows 

B_TBL_8000_TNUM:
    .BYTE  $05                                          ; Table number

B_TBL_8000_NAME:
    .TEXT  "CRT\r" \ .BYTE $9A,$9A,$9A,$9A              ; Table name

B_TBL_8000_INIT:
    JMP     TBL_INIT                                    ; $8DC1 - Table initilization vector

B_TBL_8000_INPUT_NUM:
    JMP     JMP_92D6 ; $92D6                            ; 82C5 - Table INPUT# vector

B_TBL_8000_PRINT_NUM:
    JMP     JMP_92D6 ; $92D6                            ; 82C9 - Table PRINT# vector

B_TBL_8000_JMPS:
    .BYTE  $9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A,$9A      ; Unused jumps 

B_TBL_8000_TRACE:
    .BYTE $93,$50,$FF                                   ; Unusual

B_TBL_8000_A_KW:
    .WORD $0000                                         ;

B_TBL_8000_B_KW:
    .WORD LET_B                                         ; $8056

B_TBL_8000_C_KW:
    .WORD LET_C                                         ; $8061

B_TBL_8000_D_KW:
    .WORD LET_D                                         ; $8095

B_TBL_8000_E_KW:
    .WORD LET_E                                         ; $80A5

B_TBL_8000_F_KW:
    .WORD $0000                                         ;

B_TBL_8000_G_KW:
    .WORD LET_G                                         ; $80BE

B_TBL_8000_H_KW:
    .WORD LET_H                                         ; $80E0

B_TBL_8000_I_KW:
    .WORD LET_I                                         ; $8102

B_TBL_8000_J_KW:
    .WORD $0000                                         ; 

B_TBL_8000_K_KW:
    .WORD LET_K                                         ; $810C

B_TBL_8000_L_KW:
    .WORD LET_L                                         ; $8114

B_TBL_8000_M_KW:
    .WORD LET_M                                         ; $8126

B_TBL_8000_N_KW:
    .WORD $0000                                         ; 

B_TBL_8000_O_KW:
    .WORD $0000                                         ; 

B_TBL_8000_P_KW:
    .WORD LET_P                                         ; $813B

B_TBL_8000_Q_KW:
    .WORD $0000                                         ; 

B_TBL_8000_R_KW:
    .WORD LET_R                                         ; $8145

B_TBL_8000_S_KW:
    .WORD LET_S                                         ; $815B

B_TBL_8000_T_KW:
    .WORD LET_T                                         ; $816E

B_TBL_8000_U_KW:
    .WORD $0000                                         ; 

B_TBL_8000_V_KW:
    .WORD LET_V                                         ; $8178

B_TBL_8000_W_KW:
    .WORD $0000                                         ; 

B_TBL_8000_X_KW:
    .WORD $0000                                         ; 

B_TBL_8000_Y_KW:
    .WORD $0000                                         ; 

B_TBL_8000_Z_KW:
    .WORD $0000                                         ; 

B_TBL_8000_CMD_LST:     ;Token LB < 80 command is function, else is proceedure
;Ctrl nibble    Ctrl nib calc            Name              Token  Vector
LET_B:  EQU ($ + 2) ; First keyword starting with 'B'. LET_B = Address of 'A' in BACKGR
CN1:    EQU $D6 \ CNIB($96,CN1)     \ .TEXT "BACKGR"    \ .WORD $F0DE, $9023        ; $8054

LET_C:  EQU ($ + 2) ; First keyword starting with 'C'. LET_C = Address of 'L' in CLS
CN2:    EQU $C3 \ CNIB(CN1,CN2)     \ .TEXT "CLS"       \ .WORD $F088, $8974        ; $805F
CN3:    EQU $A5 \ CNIB(CN2,CN3)     \ .TEXT "CHAIN"     \ .WORD $F0B2, $92DC        ; $8067
CN4:    EQU $C6 \ CNIB(CN3,CN4)     \ .TEXT "COLORV"    \ .WORD $F0EB, $914F        ; $8071
CN5:    EQU $C7 \ CNIB(CN4,CN5)     \ .TEXT "CONSOLE"   \ .WORD $F0B1, $89B5        ; $807C
CN6:    EQU $D6 \ CNIB(CN5,CN6)     \ .TEXT "CURSOR"    \ .WORD $F084, $8A49        ; $8088

LET_D:  EQU ($ + 2) ; First keyword starting with 'D'. LET_D = Address of 'EI' in DIR
CN7:    EQU $C3 \ CNIB(CN6,CN7)     \ .TEXT "DIR"       \ .WORD $F0E0, $92CA        ; $8093
CN8:    EQU $53 \ CNIB(CN7,CN8)     \ .TEXT "DEC"       \ .WORD $F070, $914C        ; $809B

LET_E:  EQU ($ + 2) ; First keyword starting with 'E'. LET_E = Address of 'D' in EDIT
CN9:    EQU $C4 \ CNIB(CN8,CN9)     \ .TEXT "EDIT"      \ .WORD $F0C7, $914F        ; $80A3
CN10:   EQU $C3 \ CNIB(CN9,CN10)    \ .TEXT "ERL"       \ .WORD $F053, $9088        ; $80AC
CN11:   EQU $D3 \ CNIB(CN10,CN11)   \ .TEXT "ERN"       \ .WORD $F052, $9082        ; $80B4

LET_G:  EQU ($ + 2) ; First keyword starting with 'G'. LET_G = Address of 'C' in GCLS
CN12:   EQU $C4 \ CNIB(CN11,CN12)   \ .TEXT "GCLS"      \ .WORD $F0E1, $9107        ; $80BC
CN13:   EQU $C8 \ CNIB(CN12,CN13)   \ .TEXT "GVCURSOR"  \ .WORD $F0E8, $914F        ; $80C5
CN14:   EQU $D7 \ CNIB(CN13,CN14)   \ .TEXT "GVPRINT"   \ .WORD $F0E9, $914F        ; $80D2

LET_H:  EQU ($ + 2) ; First keyword starting with 'H'. LET_H = Address of 'C' in HCURSOR
CN15:   EQU $C7 \ CNIB(CN14,CN15)   \ .TEXT "HCURSOR"   \ .WORD $F054, $8EFD        ; $80DE
CN16:   EQU $C8 \ CNIB(CN15,CN16)   \ .TEXT "HPCURSOR"  \ .WORD $F055, $8F04        ; $80EA
CN17:   EQU $B4 \ CNIB(CN16,CN17)   \ .TEXT "HEX$"      \ .WORD $F071, $8981        ; $80F7

LET_I:  EQU ($ + 2) ; First keyword starting with 'I'. LET_I = Address of 'N' in INPUT
CN18:   EQU $D5 \ CNIB(CN17,CN18)   \ .TEXT "INPUT"     \ .WORD $F091, $8C89        ; $8100

LET_K:  EQU ($ + 2) ; First keyword starting with 'K'. LET_K = Address of 'E' in KEY
CN19:   EQU $D3 \ CNIB(CN18,CN19)   \ .TEXT "KEY"       \ .WORD $F0E2, $9308        ; $810A

LET_L:  EQU ($ + 2) ; First keyword starting with 'L'. LET_L = Address of 'I' in LIST
CN20:   EQU $C4 \ CNIB(CN19,CN20)   \ .TEXT "LIST"      \ .WORD $F090, $8F16        ; $8112
CN21:   EQU $D4 \ CNIB(CN20,CN21)   \ .TEXT "LOAD"      \ .WORD $F080, $9244        ; $811B

LET_M:  EQU ($ + 2) ; First keyword starting with 'M'. LET_M = Address of 'O' in MONITOR
CN22:   EQU $C7 \ CNIB(CN21,CN22)   \ .TEXT "MONITOR"   \ .WORD $F0E4, $8EE1        ; $8124
CN23:   EQU $D4 \ CNIB(CN22,CN23)   \ .TEXT "MODE"      \ .WORD $F0DF, $91D3        ; $8130

LET_P:  EQU ($ + 2) ; First keyword starting with 'P'. LET_P = Address of 'R' in PRINT
CN24:   EQU $D5 \ CNIB(CN23,CN24)   \ .TEXT "PRINT"     \ .WORD $F097, $91A7        ; $8139

LET_R:  EQU ($ + 2) ; First keyword starting with 'R'. LET_R = Address of 'E' in REPKEY
CN25:   EQU $C6 \ CNIB(CN24,CN25)   \ .TEXT "REPKEY"    \ .WORD $F0C3, $90F1        ; $8143
CN26:   EQU $D6 \ CNIB(CN25,CN26)   \ .TEXT "REPROG"    \ .WORD $F0C5, $914F        ; $814E

LET_S:  EQU ($ + 2) ; First keyword starting with 'S'. LET_S = Address of 'A' in SAVE
CN27:   EQU $C4 \ CNIB(CN26,CN27)   \ .TEXT "SAVE"      \ .WORD $F081, $9234        ; $8159
CN28:   EQU $D5 \ CNIB(CN27,CN28)   \ .TEXT "SLEEP"     \ .WORD $F0E7, $90AA        ; $8162

LET_T:  EQU ($ + 2) ; First keyword starting with 'T'. LET_T = Address of 'E' in TESTV
CN29:   EQU $D5 \ CNIB(CN28,CN29)   \ .TEXT "TESTV"     \ .WORD $F0EA, $914F        ; $816C

LET_V:  EQU ($ + 2) ; First keyword starting with 'V'. LET_V = Address of 'E' in VERIFYQ
CN30:   EQU $C7 \ CNIB(CN29,CN30)   \ .TEXT "VERIFYQ"   \ .WORD $F083, $92D9        ; $8176
CN31:   EQU $C7 \ CNIB(CN30,CN31)   \ .TEXT "VCURSOR"   \ .WORD $F056, $8EE4        ; $8182
CN32:   EQU $C8 \ CNIB(CN31,CN32)   \ .TEXT "VPCURSOR"  \ .WORD $F050, $8EEB        ; $818E

CN33:  EQU $D0 \ .BYTE CN33

B_TBL_8000_END:
;% B_TBL_8000 END


FILLER: ; $819C
    .BYTE $00,$38

;------------------------------------------------------------------------------------------------------------
; $#### XCHE_INPUT- External Character Input Routine
; Called from: BR $826F, $827C, LIST:$8F8F
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_XCHR_INPUT START
XCHR_INPUT:
    PSH  Y                          ; 
    LDA  #(VIDEORAM + $07D9)        ; $77D9
    CPI  A,$01                      ; 
    BZR  BR_81B2                    ; $81B2
    LDI  A,$40                      ; 
    STA  (OPN)                      ; 
    ORI  #(VIDEORAM + $07D9),$02    ; $77D9

BR_81B2: ; BR $81A6
    ANI  (KB_BYPASS),$00            ; $79D4
    LDA  YL                         ; 
    STA  #(VIDEORAM + $07D4)        ; $77D4
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    CPI  A,$02                      ; Bit 1: Program waits for Enter after a print command
    BZS  BR_822F                    ; $822F
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$19                      ; 
    BZR  BR_81CF                    ; $81CF
    SJP  (JMP_8C57)                 ; $8C57
    BCS  BR_822F                    ; $822F

BR_81CF: ; BR $81C8
    SJP  (JMP_88EB)                 ; $88EB
    CPI  A,$19                      ; 
    BCR  BR_81D9                    ; $81D9
    SJP  (JMP_84D7)                 ; $84D7

BR_81D9: ; BR $81D4
    LDA  #(VIDEORAM + $07D3)        ; $77D3 
    CPI  A,$09                      ; 
    BZR  BR_81E9                    ; $81E9
    SJP  (JMP_8929)                 ; $8929
    BCR  BR_822F                    ; $822F
    SJP  (BR_8466)                  ; $8466

BR_81E9: ; BR $81DF
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$0D                      ; 
    BZR  BR_81F4                    ; $81F4
    SJP  (JMP_87CC)                 ; $87CC

BR_81F4: ; BR $81EF
    SJP  (JMP_88EB)                 ; $88EB
    CPI  A,$19                      ; 
    BCR  BR_81FE                    ; $81FE
    SJP  (JMP_84D7)                 ; $84D7

BR_81FE: ; BR $81F9
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    STA  YH                         ; 
    LDI  YL,$01                     ; 
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ; 
    BZR  BR_8215                    ; $8215
    LDA  (STRING_VARS + $FE)        ; 
    STA  YH                         ; 
    LDA  (STRING_VARS + $FF)        ; 
    STA  YL                         ; 

BR_8215: ; BR $820B
    SJP  (JMP_8D6B)                 ; $8D6B
    LDX  Y                          ; 
    LDI  YH,HB(IN_BUF)              ; $7B
    LDI  YL,LB(IN_BUF)              ; $B0
    ANI  #(VIDEORAM + $07D6),$00    ; $77D6
    SJP  (JMP_852C)                 ; $852C
    SJP  (JMP_8663)                 ; $8663
    SJP  (JMP_8456)                 ; $8456
    SJP  (JMP_8721)                 ; $8721

BR_822F: ; BR $81C0, $81CD, $81E4
    ANI  (APOW_CTR_H),$00           ; Auto power down counter (H)
    ANI  (APOW_CTR_M),$00           ; Auto power down counter (M)
    ANI  (APOW_CTR_L),$00           ; Auto power down counter (L)
    SJP  (JMP_9150)                 ; $9150
    SJP  (JMP_90DE)                 ; $90DE
    SJP  (JMP_8963)                 ; $8963
    PSH  A                          ; 
    LDA  (DISP_BUFF + $4E)          ; 
    ORI  A,$F7                      ; 
    CPI  A,$FF                      ; 
    BZS  BR_8252                    ; $8252
    JMP  BR_8271                    ; $8271

BR_8252: ; BR $824D
    PSH  X                          ; 
    PSH  Y                          ; 
    PSH  U                          ; 
    SJP  (KEY2ASCII)                ; Return ASCII code of key pressed in Accumulator. If no key: C=1.
    POP  U                          ; 
    POP  Y                          ; 
    POP  X                          ; 
    CPI  A,$09                      ; 
    BZR  BR_8271                    ; $8271
    ORI  (DISP_BUFF + $4E),$04      ; 
    ANI  (DISP_BUFF + $4E),$F7      ; 
    POP  A                          ; 
    BCH  XCHR_INPUT                 ; $819E

BR_8271: ; BR $824F, $8263
    POP  A                          ; 
    CPI  A,$1A                      ; 
    BZR  BR_827E                    ; $827E
    SJP  (JMP_8D41)                 ; $8D41
    POP  Y                          ; 
    BCH  XCHR_INPUT                 ; $819E

BR_827E: ; BR $8275
    CPI  A,$0B                      ; 
    BZR  BR_8299                    ; $8299
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZR  BR_8297                    ; $8297
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$03                      ; 
    BCR  BR_8297                    ; $8297
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2

BR_8297: ; BR $8288, $8290
    LDI  A,$0B                      ; 

BR_8299: ; BR $8280
    CPI  A,$0B                      ; 
    BZR  BR_82EA                    ; $82EA
    PSH  A                          ; 
    SJP  (JMP_86E4)                 ; $86E4
    BCS  BR_82A9                    ; $82A9
    ADI  #(VIDEORAM + $07D2),$01    ; 

BR_82A9: ; BR $82A2
    POP  A                          ; 
    ORI  #(VIDEORAM + $07DF),$01    ; $77DF
    LDI  A,$0A                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  #(VIDEORAM + $07DA)        ; $77DA
    STA  #(CRTCTRL + $01)           ; 
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$00                      ; 
    BZR  BR_82D3                    ; $82D3
    SJP  (JMP_9189)                 ; $9189
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2

BR_82D3: ; BR $82C9
    LDA  #(VIDEORAM + $07D9)        ; $77D9
    CPI  A,$99                      ; 
    BZR  BR_82E6                    ; $82E6
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    LDI  A,$02                      ; 
    STA  #(VIDEORAM + $07D9)        ; $77D9

BR_82E6: ; BR $82D9
    LDI  A,$0B                      ; 
    BCH  BR_83BB                    ; $83BB

BR_82EA: ; BR $829B
    CPI  A,$0A                      ; 
    BZR  BR_8317                    ; $8317
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZR  BR_8315                    ; $8315
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$17                      ; 
    BCR  BR_8310                    ; $8310
    SJP  (JMP_84D7)                 ; $84D7
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2

BR_8310: ; BR $82FC
    ADI  #(VIDEORAM + $07D2),$01    ; 

BR_8315: ; BR $82F4
    LDI  A,$0A                      ; 

BR_8317: ; BR $82EC
    CPI  A,$0A                      ; 
    BZR  BR_832E                    ; $832E
    PSH  A                          ; 
    SJP  (JMP_86FA)                 ; $86FA
    BCS  BR_8327                    ; $8327
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2

BR_8327: ; BR $8320
    POP  A                          ; 
    ORI  #(VIDEORAM + $07DF),$01    ; $77DF

BR_832E: ; BR $8319
    CPI  A,$0C                      ; 
    BZR  BR_8343                    ; $8343
    BII  #(VIDEORAM + $07DF),$01    ; $77DF
    BZS  BR_8343                    ; $8343
    ANI  #(VIDEORAM + $07DF),$00    ; $77DF
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2

BR_8343: ; BR $8330, $8337
    CPI  A,$08                      ; 
    BZR  BR_8358                    ; 
    BII  #(VIDEORAM + $07DF),$01    ; $77DF
    BZS  BR_8358                    ; 
    ANI  #(VIDEORAM + $07DF),$00    ; $77DF
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2

BR_8358: ; BR $8345, $834C
    CPI  A,$0E                      ; 
    BZR  BR_8361                    ; $8361
    ANI  #(VIDEORAM + $07D8),$00    ; $77D8

BR_8361: ; BR $835A
    CPI  A,$1F                      ; 
    BZR  BR_8367                    ; $8367
    BCH  BR_836B                    ; $836B

BR_8367: ; BR $8363
    CPI  A,$1E                      ; 
    BZR  BR_8374                    ; $8374

BR_836B: ; BR $8365
    PSH  A                          ; 
    SJP  (JMP_8D41)                 ; $8D41
    POP  A                          ; 
    BCH  BR_83BB                    ; $83BB

BR_8374: ; BR $8369
    CPI  A,$0E                      ; 
    BCS  BR_8381                    ; $8381
    CPI  A,$0A                      ; 
    BCR  BR_8381                    ; $8381
    SJP  (JMP_83C6)                 ; $83C6
    BCH  BR_83BB                    ; $83BB

BR_8381: ; BR $8376,$837A
    STA  YL                         ; 
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$0D                      ; 
    BZR  BR_838D                    ; $838D
    SJP  (JMP_842D)                 ; $842D

BR_838D: ; BR $8388
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$0A                      ; 
    BZR  BR_8398                    ; $8398
    SJP  (JMP_843B)                 ; $843B

BR_8398: ; BR $8393
    CPI  A,$0B                      ; 
    BZR  BR_839F                    ; 
    SJP  (JMP_843B)                 ; $843B
    
BR_839F:   
    LDA  YL                         ; 
    ANI  (CURS_CTRL),$FD            ; 
    PSH  A                          ; 
    LDI  A,$55                      ; 
    CPA  #(VIDEORAM + $07E2)        ; $77E2
    BZR  BR_83B9                    ; $83B9
    PSH  X                          ; 
    PSH  U                          ; 
    SJP  (BCMD_BEEP_STD)            ; 
    POP  U                          ; 
    POP  X                          ; 

BR_83B9: ; BR $83AC
    POP  A                          ; 

BR_83BB: ; BR $82E8,$8372,$837F
    POP  Y                          ;
    STA  #(VIDEORAM + $07D3)        ; $77D3
    ORI  (KB_BYPASS),$55            ; Set KB bypass
    RTN                             ; Done
;% LB_xxxx_INPUT END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $83C6- xxxx - Finds start of program?
; Called from: $837C
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_83C6:
    STA  YL                         ; 
    LDI  A,$3E                      ; 
    CPA  (IN_BUF)                   ;
    BZS  BR_8417                    ; $8417
    LDI  A,$0D                      ;
    CPA  #(VIDEORAM + $07D3)        ; $77D3
    BZR  BR_83E5                    ; $83E5
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$50                      ; 
    BZS  BR_83F0                    ; $83F0
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    BCH  BR_8417                    ; $8417
    
BR_83E5:   
    CPA  YL                         ; 
    BZS  BR_8419                    ; $8419
    CPI  YL,$08                     ; 
    BZS  BR_841F                    ; $841F
    CPI  YL,$0C                     ; 
    BZS  BR_841F                    ; $841F

BR_83F0: ; BR $83DC,$841D,$8425,$8428,$844D,$8454
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZR  BR_8417                    ; $8417
    PSH  Y                          ; 
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    DEC  A                          ; 
    STA  YH                         ;
    LDI  YL,$28                     ;
    SJP  (JMP_8D6B)                 ; $8D6B
    LDA  #(Y)                       ;
    POP  Y                          ;
    CPI  A,$0E                      ;
    BCR  BR_8417                    ; $8417
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2

BR_8417: ; BR $83CC,$83E3,$83FB,$8410,$842B,$8442,$844B,$8452
    LDA  YL                         ;
    RTN                             ; Done

BR_8419: ; BR $83E6
    CPI  YL,$0D                     ;
    BZS  BR_841F                    ; $841F
    BCH  BR_83F0                    ; $83F0

BR_841F: ; BR $841B
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$0A                      ; 
    BZS  BR_83F0                    ; $83F0
    CPI  A,$0B                      ; 
    BZS  BR_83F0                    ; $83F0
    BCH  BR_8417                    ; $8417

JMP_842D: ; BR $838A
    LDI  A,$3E                      ; 
    CPA  (IN_BUF)                   ;
    BZR  BR_8435                    ; $8435
    RTN                             ; Done

BR_8435: ; BR $8432
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $843B- xxxx - 
; Called from: $8395,$839C
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_843B:
    LDA  (DISP_BUFF + $4F)          ; 
    ANI  A,$20                      ; 
    CPI  A,$20                      ; 
    BZR  BR_8417                    ; $8417
    CPI  YL,$0A                     ; 
    BZR  BR_844F                    ; $844F
    SJP  (JMP_86FA)                 ;  $86FA
    BCR  BR_8417                    ; $8417
    BCH  BR_83F0                    ; $83F0

BR_844F:  ; BR $8446
    SJP  (JMP_86E4)                 ; $86E4
    BCR  BR_8417                    ; $8417
    BCH  BR_83F0                    ; $83F0

JMP_8456: ; BR $8229
    LDA  (IN_BUF)                   ; 
    CPI  A,$3E                      ; 
    BZS  BR_845E                    ; $845E
    RTN                             ; Done

BR_845E:  ; BR $845B
    LDA  (CURS_BLNK_POS)            ; $787B - Position of blink character in display, plus 8
    CPI  A,$09                      ; 
    BCR  BR_8466                    ; $8466
    RTN                             ; Done

BR_8466: ; BR $81E6,$8463,$8949
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    STA  YH                         ; 
    LDI  YL,$01                     ; 
    SJP  (JMP_8D6B)                 ; $8D6B
    PSH  X                          ; 
    LDI  XH,$8E                     ; In mystery table
    LDI  XL,$B3                     ;
    LDI  UH,$0D                     ; 
    LDI  A,$40                      ; 
    AND  (DISP_BUFF + $4F)          ; 
    CPI  A,$40                      ; 
    BZR  BR_8494                    ; $8494
    BII  #(VIDEORAM + $07F3),$01    ; $77F3
    BCS  BR_848D                    ; $848D
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2

BR_848D: ; BR $8486
    ANI  #(VIDEORAM + $07F3),$00    ; $77F3
    BCH  BR_84BB                    ; $84BB

BR_8494: ; BR $847F
    ANI  #(VIDEORAM + $07F3),$00    ; $77F3
    LDI  A,$20                      ; 
    AND  (DISP_BUFF + $4F)          ; 
    CPI  A,$20                      ; 
    BZS  BR_84BB                    ; $84BB
    LDI  A,$10                      ; 
    AND  (DISP_BUFF + $4F)          ; 
    CPI  A,$10                      ; 
    BZR  BR_84D4                    ; $84D4
    LDI  A,$06                      ; 
    ADR  X                          ; 
    LDI  UL,$0D                     ; 
    SJP  (JMP_88FD)                 ; $88FD
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    BCH  BR_84C5                    ; $84C5

BR_84BB:  ; BR $8492,$84A0
    CPI  A,$20                      ; 
    BZR  BR_84C3                    ; $84C3
    LDI  A,$03                      ; 
    ADR  X                          ; 

BR_84C3: ; BR $84BD
    LDI  UL,$02                     ; 

BR_84C5: ; BR $84B9
    LDI  A,$3E                      ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 
    SJP  (JMP_8D64)                 ; $8D64
    SJP  (JMP_8963)                 ; $8963
    INC  Y                          ; 
    LDA  UH                         ; 
    STA  #(Y)                       ; 

BR_84D4: ; BR $84A9
    POP  X                          ;
    RTN                             ; Done
;% LB_XCHR_INPUT END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $84D7- xxxx - Finds start of program?
; Called from: BR $829F,$844F
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_84D7: ; BR $819D6,$81FB,$82FE,$875F,$87C8,$8890,$8BA7,$8BEA
    STA  YL
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZS  BR_84E6                    ; $84E6
    CPI  YL,$19                     ; 
    BZR  BR_84E6                    ; $84E6
    LDA  YL                         ; 
    RTN                             ; Done

BR_84E6: ; BR $84DE,$84E2
    SJP  (Y2_VIDRAM)                ; $8E5F - Sets Yreg to point to Video RAM
    LDX  Y                          ; 
    ADR  X                          ; X = X + A + Carry
    CPI  A,$28                      ; 
    BZR  BR_84FD                    ; $84FD
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$19                      ; 
    BZS  BR_84FD                    ; $84FD
    LDI  A,$28                      ; 
    ADR  X                          ; X = X + A + Carry

BR_84FD: ; BR $84EF,$84F7
    LDI  UH,$07                     ; Loop counter
    LDI  UL,$80                     ; 

BR_8501: ; BR $8507,$850B
    LDA  #(X)                       ; 
    STA  #(Y)                       ; 
    INC  X                          ; 
    INC  Y                          ; 
    LOP  UL,BR_8501                 ; $8501
    DEC  UH                         ; 
    BCS  BR_8501                    ; $8501
    LDI  A,$00                      ; 
    LDI  UL,$4F                     ; 

BR_8511: ; BR $8514
    STA  #(Y)                       ; 
    INC  Y                          ;
    LOP  UL,BR_8511                 ; $8511
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZR  BR_8522                    ; $8522
    LDI  A,$18                      ; 
    BCH  BR_8524                    ; $8524

BR_8522: ; BR $851c
    LDI  A,$19                      ; 

BR_8524: ; BR $8520
    STA  #(VIDEORAM + $07D2)        ; $77D2
    STA  (STRING_VARS + $FE)        ; 
    RTN                             ; Done

JMP_852C: ; BR $8223
    LDI  UH,$00                     ; 
    LDI  UL,$4F                     ; 
    ANI  #(VIDEORAM + $07D7),$00    ; $77D7

BR_8535: ; BR $85B3,$8600
    SJP  (JMP_8854)                 ; $8854
    LDA  YL                         ; 
    CPA  #(VIDEORAM + $07D4)        ; $77D4
    BZR  BR_8556                    ; $8556
    LDA  #(VIDEORAM + $07D6)        ; $77D5
    CPI  A,$00                      ; 
    BZR  BR_8556                    ; $8556
    LDA  XH                         ; 
    STA  #(VIDEORAM + $07D4)        ; $77D4
    LDA  XL                         ; 
    STA  #(VIDEORAM + $07D5)        ; $77D5
    ORI  #(VIDEORAM + $07D6),$01    ; $77D6

BR_8556: ; BR $853D,$8545
    PSH  U                          ; 
    VEJ  (C0)                       ; (C0) Load next character/token into U-REG
    BCR  BR_85BB                    ; $85BB
    PSH  Y                          ; 
    PSH  X                          ; 
    LDI  YH,HB(RND_VAL)             ; $7B
    LDI  YL,LB(RND_VAL)             ; $00
    PSH  Y                          ; 
    VMJ  ($1C) \ ABYT($02)          ; (1C) Processes tokens corresponding to data bytes
    SJP  (BR_8656)                  ; $8656
    POP  X                          ; 
    ANI  (Y),$00                    ; 
    CPI  A,$00                      ; 
    BZR  BR_8576                    ; $8576
    LDI  A,$FE                      ; 
    STA  (X)                        ; 

BR_8576: ; BR $8571
    LDA  YL                         ; 
    STA  UL                         ; 
    POP  Y                          ; 

BR_857A: ; BR $85A4
    LIN  X                          ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 
    PSH  A                          ; 
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ;
    BZS  BR_858C                    ; $858C
    POP  A                          ; 
    BCH  BR_8595                    ; $8595

BR_858C: ; BR $8586
    POP  A                          ; 
    CPI  A,$0D                      ; 
    BZR  BR_8595                    ; $8595
    REC                             ; 
    BCH  BR_85B6                    ; $85B6

BR_8595: ; BR $858A,$8590
    ADI  #(VIDEORAM + $07D7),$01    ; $77D7
    SJP  (JMP_87E7)                 ; $87E7
    BCS  BR_85B6                    ; $85B6
    CPI  A,$FF                      ; 
    BZR  BR_85A4                    ; $85A4
    DEC  Y                          ; 

BR_85A4: ; BR $85A1
    LOP  UL,BR_857A                 ; $857A
    DEC  UH                         ; 
    DEC  UH                         ; 
    LDA  UH                         ; 
    LDX  Y                          ; 
    POP  Y                          ; 
    POP  U                          ; 
    INC  A                          ; 
    STA  UL                         ; 
    LOP  UL,BR_8535                 ; $8535
    RTN                             ; Done

BR_85B6: ; BR $8593,$859D
    POP  Y                          ; 
    POP  U                          ; 
    RTN                             ; Done

BR_85BB: ; BR $8559
    POP  U                          ; 
    CPI  UL,$4B                     ;
    BCR  BR_85C4                    ; $85C4
    SJP  (BR_8604)                  ; $8604

BR_85C4: ; BR $85BF
    STA  #(X)                       ; 
    INC  X                          ; 
    PSH  A                          ; 
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ; 
    BZS  BR_85D5                    ; $85D5
    POP  A                          ; 
    BCH  BR_85F0                    ; $85F0

BR_85D5: ; BR $85CF
    POP  A                          ; 
    CPI  A,$0D                      ; 
    BZR  BR_85F0                    ; $85F0
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$18                      ; 
    BZS  BR_85E9                    ; $85E9
    DEC  X                          ; 
    DEC  X                          ; 
    SJP  (JMP_88BF)                 ; $88BF
    RTN                             ; Done

BR_85E9: ; BR $85E1
    LDA  #(X)                       ; 
    CPI  A,$0E                      ; 
    BCS  BR_85F0                    ; 
    RTN                             ; Done

BR_85F0: ; BR $85D3,$85D9
    ADI  #(VIDEORAM + $07D7),$01    ; $77D7
    SJP  (JMP_87E7)                 ; $87E7
    BCR  BR_85FB                    ; $85FB
    RTN                             ; Done

BR_85FB: ; BR $85F8
    CPI  A,$FF                      ; 
    BZR  BR_8600                    ; $8600
    DEC  X                          ; 

BR_8600: ; BR $85FD
    LOP  UL,BR_8535                 ; $8535
    REC                             ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $86E4 - xxxx - Finds start of program?
; Called from: BR $829F,$844F
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
BR_8604: ; BR $85C1
    CPI  UH,$FF                     ; 
    BZR  BR_8609                    ; UH <> $FF
    RTN                             ; Done

BR_8609: ; BR $8606
    CPI  A,$3A                      ; 
    BCR  BR_8610                    ; A < $3A

BR_860D: ; BR $8612,$861F,$862A
    LDI  UH,$FF                     ; 
    RTN                             ; Done

BR_8610: ; BR $860B
    CPI  A,$30                      ; 
    BCR  BR_860D                    ; A < $30
    PSH  A                          ; 
    LDI  A,$40                      ; Bit 6: The display program shows from (Y-Reg)
    CPA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    BZR  BR_8621                    ; A <> DISPARAM
    POP  A                          ; 
    BCH  BR_860D                    ; $860D

BR_8621: ; BR $861B
    LDI  A,$20                      ; Bit 5: Result from AR-X is displayed
    CPA  (DISPARAM)                 ; Display Parameter: determines display at READY
    BZR  BR_862C                    ; $862C
    POP  A                          ; 
    BCH  BR_860D                    ; $860D

BR_862C: ; BR $8626
    LDI  A,$50                      ; 
    SEC                             ; 
    SBC  UL                         ; 
    PSH  U                          ; 
    LDI  UH,HB(ARZ)                 ; $7A
    LDI  UL,LB(ARZ)                 ; $08
    ADR  U                          ; 
    LDA  (U)                        ; 
    POP  U                          ; 
    CPI  A,$3A                      ; 
    BZS  BR_8646                    ; $8646
    CPI  A,$20                      ; 
    BZS  BR_8646                    ; $8646
    POP  A                          ; 
    RTN                             ; Done

BR_8646: ; BR $863D,$8641
    STA  UH                         ; 
    POP  A                          ; 
    STA  #(X)                       ; 
    ADI  #(VIDEORAM + $07D7),$01    ; $77D7
    INC  X                          ; 
    DEC  UL                         ; 
    LDA  UH                         ; 
    LDI  UH,$FF                     ; 
    RTN                             ; Done

BR_8656:
    LDX  S                          ; 
    PSH  A                          ; 
    LDI  A,$0A                      ; 
    ADR  X                          ; 
    LDA  (X)                        ; 
    STA  UH                         ; 
    POP  A                          ; 
    RTN                             ; Done

JMP_8663: ; BR $8226
    LDA  (DISPARAM)                 ; Display Parameter: determines display at READY
    CPI  A,$80                      ; Bit 7: Error message is in the display
    BZR  BR_866D                    ; $866D
    JMP  JMP_8963                   ; $8963

BR_866D: ; BR $8668
    CPI  A,$A0                      ; Bit 7: Error message is in the display, Bit 5: Result from AR-X is displayed
    BZR  BR_8674                    ; $8674
    JMP  JMP_8963                   ; $8963

BR_8674: ; BR $866F
    CPI  A,$01                      ; Bit 0: The input buffer was temporarily stored. A system message or a reserve text is shown in the display
    BZR  BR_867B                    ; $867B
    JMP  JMP_8963                   ; $8963


BR_867B: ; BR $8676
    LDA  #(VIDEORAM + $07D4)        ; $77D4
    STA  YH                         ; 
    LDA  #(VIDEORAM + $07D5)        ; $77D5
    STA  YL                         ; 
    LDI  A,$0E                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  YH                         ; 
    STA  #(CRTCTRL + $01)           ; 
    LDI  A,$0F                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  YL                         ; 
    STA  #(CRTCTRL + $01)           ; 
    LDA  #(VIDEORAM + $07DA)        ; $77DA
    PSH  X                          ; 
    PSH  A                          ; 
    LDI  XH,$8E                     ; 
    LDI  XL,$A1                     ; 
    LDI  A,$1C                      ; 
    ADR  X                          ; 
    BII  (CURSOR_BLNK),$01          ; 
    BZS  BR_86B6                    ; $86B6
    ORI  #(VIDEORAM + $07DA),$40    ; $77DA

BR_86B6: ; BR $8668
    BII  (CURSOR_BLNK),$01          ; 
    BZR  BR_86C1                    ; $86C1
    ANI  #(VIDEORAM + $07DA),$BF    ; $77DA

BR_86C1: ; BR $86BA
    LDI  A,$0A                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  #(VIDEORAM + $07DA)        ; $77DA
    STA  #(CRTCTRL + $01)           ; 
    LDI  A,$0B                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  #(VIDEORAM + $07DB)        ; $77DB
    ANI  A,$1F                      ; 
    STA  #(CRTCTRL + $01)           ; 
    POP  A                          ; 
    POP  X                          ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $86E4 - xxxx - Finds start of program?
; Called from: BR $829F,$844F
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_86E4: 
    LDA  (BASPRG_ST_H)              ; Start of Basic program in RAM (H)
    CPA  (SRCH_ADD_H)               ; Address of linefound during search (H)
    BZS  BR_86EE                    ; $86EE
    SEC                             ; 
    RTN                             ; Done

BR_86EE: ; BR $86EA
    LDA  (BASPRG_ST_L)              ; Start of Basic program in RAM (L)
    CPA  (SRCH_ADD_L)               ; Address of linefound during search (L)
    BZS  BR_86F8                    ; $86F8
    SEC                             ; 
    RTN                             ; Done

BR_86F8: ; BR $86F4
    REC                             ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_86FA: ; BR $831D,$8448
    PSH  X                          ; 
    LDA  (SRCH_ADD_H)               ; Address of linefound during search (H)
    STA  XH                         ; 
    LDA  (SRCH_ADD_L)               ; Address of linefound during search (L)
    STA  XL                         ; 
    INC  X                          ; 
    INC  X                          ; 
    LIN  X                          ; 
    ADR  X                          ; 
    LDA  (BASPRG_END_H)             ; End of Basic program in RAM (H)
    CPA  XH                         ; Is search at end of program HB??
    BZS  BR_8713                    ; $8713
    POP  X                          ; 
    SEC                             ; 
    RTN                             ; Done

BR_8713: ; BR $870D
    LDA  (BASPRG_END_L)             ; End of Basic program in RAM (L)
    CPA  XL                         ; Is search at end of program LB??
    BZS  BR_871D                    ; $871D
    POP  X                          ; 
    SEC                             ; 
    RTN                             ; Done

BR_871D: ; BR $8717
    POP  X                          ; 
    REC                             ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8721: ; BR $822C
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    PSH  A                          ; 
    CPI  A,$20                      ; Bit 5: Result from AR-X is displayed
    BZS  BR_8752                    ; $8752
    CPI  A,$80                      ; Bit 7: Error message is in the display
    BZS  BR_8752                    ; $8752
    CPI  A,$A0                      ; Bit 7: Error message is in the display, Bit 5: Result from AR-X is displayed
    BZS  BR_8752                    ; $8752
    CPI  A,$01                      ; Bit 1: Program waits for Enter after a print command
    BZS  BR_8752                    ; $8752
    POP  A                          ; 
    LDA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$0D                      ; 
    BZS  BR_8741                    ; $8741
    RTN                             ; Done

BR_8741: ; BR $873E
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZS  BR_874A                    ; $874A
    RTN                             ; Done

BR_874A: ; BR $8747
    LDA  (IN_BUF + $27)             ; 
    CPI  A,$0D                      ; CR?
    BZR  BR_87BB                    ; $87BB
    RTN                             ; Done

BR_8752: ; BR $8728,$872C,$8730,$8734
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$19                      ; 
    BCR  BR_8762                    ; $8762
    SJP  (JMP_84D7)                 ; $84D7

BR_8762: ; BR $875D
    SJP  (JMP_87D4)                 ; $87D4
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    STA  YH                         ; 
    LDI  YL,$01                     ; 
    SJP  (JMP_8D6B)                 ; $8D6B
    LDI  UL,$4F                     ; 
    POP  A                          ; 
    CPI  A,$20                      ; 
    BZR  BR_877D                    ; $877D
    LDI  XH,HB(OUT_BUF)             ; $7B
    LDI  XL,LB(OUT_BUF)             ; $60
    BCH  BR_8789                    ; $8789

BR_877D: ; BR $8775
    LDI  XH,$7A                     ; ARZ?
    LDI  XL,$10                     ; 
    LDI  UL,$19                     ; Loop counter?
    LDI  A,$0D                      ; 
    STA  #(VIDEORAM + $07D3)        ; $77D3

BR_8789: ; BR $877B
    LDI  UH,$00                     ; 

BR_878B: ; BR $
    LIN  X                          ; 
    CPI  A,$00                      ; 
    BZS  BR_879D                    ; $879D
    CPI  UH,$02                     ; 
    BZS  BR_879D                    ; $879D
    LDI  UH,$01                     ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 

BR_8799: ; BR $8799
    LOP  UL,BR_878B                 ; $878B
    BCH  BR_87A5                    ; $87A5

BR_879D: ; BR $878E,$8792
    CPI  UH,$01                     ; 
    BZR  BR_87A3                    ; $87A3
    INC  UH                         ;

BR_87A3: ; BR $879F
    BCH  BR_8799                    ; $8799

BR_87A5: ; BR $879B
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ;
    BZS  BR_87AE                    ; $87AE
    RTN                             ; Done

BR_87AE: ; BR $87AB
    CPI  XH,$7B                     ; 
    BZS  BR_87B3                    ; $87B3
    RTN                             ; Done

BR_87B3: ; BR $87B0                 
    LDA  (OUT_BUF + $27)            ; 
    CPI  A,$00                      ; 
    BZR  BR_87BB                    ; $87BB
    RTN                             ; Done

BR_87BB: ; BR $874F,$87B8,$8791,$87E5
    ADI  #(VIDEORAM + $07D2),$01    ; $77D2
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    CPI  A,$19                      ; 
    BCR  BR_87CB                    ; $87CB
    SJP  (JMP_84D7)                 ; $84D7

BR_87CB: ; BR $87C6
    RTN                             ; Done


JMP_87CC: ; BR $81F1
    LDA  (IN_BUF)                   ; 
    CPI  A,$3E                      ; 
    BZS  BR_87BB                    ; $87BB
    RTN                             ; Done

JMP_87D4: ; BR $8762
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$28                      ; 
    BZS  BR_87DD                    ; $87DD
    RTN                             ; Done

BR_87DD: ; BR $87DA
    LDA  (IN_BUF + $28)             ; 
    CPI  A,$0D                      ; 
    BZR  BR_87E5                    ; $87E5
    RTN                             ; Done

BR_87E5: ; BR $87E2
    BCH  BR_87BB                    ; $87BB
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_87E7: ; BR $859A,$85F5
    LDA  #(VIDEORAM + $07D7)        ; $77D7
    CPI  A,$50                      ; 
    BCS  BR_87F0                    ; $87F0
    RTN                             ; Done

BR_87F0: ; BR $87ED
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    CPI  A,$50                      ; Bit 6: The display program shows from (Y-Reg), 
    BZS  BR_87FD                    ; $87FD
    CPI  A,$54                      ;Bit 4: Program line is displayed
    BZS  BR_87FD                    ; $87FD
    SEC                             ; 
    RTN                             ; Done

BR_87FD: ; BR $87F5,$87F9
    LDA  #(VIDEORAM + $07D6)        ; $77D6
    CPI  A,$01                      ; 

BR_8803: ; BR $91C1
    BZR  BR_8807                    ; $8807
    SEC                             ; 
    RTN                             ; Done

BR_8807: ; BR $8803
    PSH  X                          ; 
    PSH  Y                          ; 
    PSH  U                          ; 
    LDA  #(VIDEORAM + $07D2)        ; $77D2
    STA  YH                         ; 
    LDI  YL,$01                     ; 
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ; 
    BZR  BR_8824                    ; $8824
    LDA  (STRING_VARS + $FE)        ; 
    STA  YH                         ; 
    LDA  (STRING_VARS + $FF)        ; 
    STA  YL                         ; 

BR_8824: ; BR $881A
    SJP  (JMP_8D6B)                 ; $8D6B
    LDI  XH,HB(IN_BUF)              ; $7B
    LDI  XL,LB(IN_BUF)              ; $B0
    LDI  UL,$4F                     ; 
    
BR_882D:   
    LIN  X                          ; 
    INC  Y                          ; 
    CPI  A,$30                      ; 
    BCR  BR_8839                    ; $8839
    CPI  A,$3A                      ; 
    BCS  BR_8839                    ; $8839
    LOP  UL,BR_882D                 ; 

BR_8839: ; BR $8331,$8335
    LDX  Y                          ; 
    INC  Y                          ; 
    DEC  UL                         ; 

BR_883D: ; BR $8843
    LDA  #(Y)                       ; 
    INC  Y                          ; 
    STA  #(X)                       ; 
    INC  X                          ; 
    LOP  UL,BR_883D                 ; $883D
    POP  U                          ; 
    POP  Y                          ; 
    POP  X                          ; 
    ADI  #(VIDEORAM + $07D7),$FF    ; $77
    LDI  A,$FF                      ; 
    REC                             ; 
    RTN                             ; Done


JMP_8854: ; BR $8835
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ; 
    BZS  BR_885D                    ; $885D
    RTN                             ; Done

BR_885D: ; BR $885A
    LDA  (STRING_VARS + $FE)        ; 
    CPI  A,$16                      ; 
    BCS  BR_8865                    ; $8865
    RTN                             ; Done

BR_8865: ; BR $8862
    PSH  Y                          ; 
    PSH  U                          ; 
    PSH  X                          ; 
    LDA  XL                         ; 
    SEC                             ; 
    SBC  (SHADOW_RAM + $01)         ; 
    STA  XL                         ; 
    LDA  XH                         ; 
    SBC  (SHADOW_RAM)               ; 
    STA  XH                         ; 
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$50                      ; 
    BZR  BR_8886                    ; $8886
    CPI  XH,$07                     ; 
    BZR  BR_8884                    ; $8884
    CPI  XL,$D0                     ; 

BR_8884: ; BR $8880
    BCH  BR_888C                    ; $888C

BR_8886: ; BR $887C
    CPI  XH,$03                     ;
    BZR  BR_888C                    ; $888C
    CPI  XL,$E8                     ;

BR_888C: ; BR $8884,$8888
    BCR  BR_88AE                    ; $88AE
    LDI  A,$1A                      ; 
    SJP  (JMP_84D7)                 ; $84D7
    LDA  (STRING_VARS + $FE)        ; 
    STA  YH                         ;
    LDI  YL,$01                     ;
    SJP  (JMP_8D6B)                 ; $8D6B
    POP  X                          ; 
    PSH  Y                          ; 
    SJP  (JMP_88B5)                 ; $88B5
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  A,$50                      ;
    BZS  BR_88AE                    ; $88AE
    SJP  (JMP_88B5)                 ; $88B5

BR_88AE: ; BR $888C,$88A9
    POP  X                          ; 
    POP  U                          ; 
    POP  Y                          ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_88B5: ; BR $88A0,$88AB
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2
    ADI  (STRING_VARS + $FE),$FF    ; 
    RTN                             ; Done
    ;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_88BF: ; BR $85E5,$8C17
    LDA  XL                         ; 
    SEC                             ; 
    SBC  (SHADOW_RAM + $01)         ; 
    STA  XL                         ; 
    LDA  XH                         ; 
    SBC  (SHADOW_RAM)               ; 
    STA  XH                         ; 
    LDI  UL,$01                     ; 

BR_88CC: ; BR $88E3
    INC  UL                         ; 
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    CPI  XH,$00                     ; 
    BZR  BR_88DA                    ; $88DA
    CPA  XL                         ; 
    BZS  BR_88DA                    ; $88DA
    BCS  BR_88E5                    ; $88E5

BR_88DA: ; BR $88D3,$88D6
    STA  UH                         ; 
    LDA  XL                         ; 
    SEC                             ; 
    SBC  UH                         ; 
    STA  XL                         ; 
    LDA  XH                         ; 
    SBI  A,$00                      ;
    STA  XH                         ; 
    BCH  BR_88CC                    ; $88CC

BR_88E5: ; BR $88D8
    LDA  UL
    STA  #(VIDEORAM + $07D2)        ; $77D2
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_88EB: ; BR $81CF,$81F4
    LDA  #(VIDEORAM + $07D8)        ; $77D8
    CPI  A,$01                      ; 
    BZR  BR_88F8                    ; $88F8
    LDA  (STRING_VARS + $FE)        ; 
    BCH  BR_88FC                    ; $88FC

BR_88F8: ; BR $88F1
    LDA  #(VIDEORAM + $07D2)        ; $77D2

BR_88FC: ; BR $88F6
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_88FD: ; BR $84B1
    LDI  UH,$33                     ; 
    LDI  A,$10                      ; 
    AND  (DISP_BUFF + $4E)          ; 
    CPI  A,$10                      ; 
    BZR  BR_8909                    ; $8909
    RTN                             ; 

BR_8909: ; BR $8906
    DEC  UH                         ;
    LDI  A,$20                      ; 
    AND  (DISP_BUFF + $4E)          ; 
    CPI  A,$20                      ; 
    BZR  BR_8915                    ; $8915
    RTN                             ; 

BR_8915: ; BR $8912
    DEC  UH                         ;
    LDI  A,$40                      ; 
    AND  (DISP_BUFF + $4E)          ; 
    CPI  A,$40                      ; 
    BZR  BR_8926                    ; $8926
    ANI  #(VIDEORAM + $07DF),$00    ; $77DF
    RTN                             ; 

BR_8926: ; BR $891E
    LDI  UH,$0D                     ; 
    RTN                             ; 
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: BR $8241,$84CD,$866A,$8671,$8678,$8A98
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8929: ; BR $81E1
    ANI  #(VIDEORAM + $07DF),$00    ; $77DF
    LDA  (DISP_BUFF + $4F)          ; 
    BII  A,$10                      ; 
    BZS  BR_894E                    ; $894E
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    ANI  A,$01                      ; 
    CPI  A,$01                      ; Bit 0: The input buffer was temporarily stored. A system message or a reserve text is shown in the display.
    BZS  BR_8940                    ; $8940
    SEC                             ; 
    RTN                             ; Done

BR_8940: ; BR $893C
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    ANI  A,$01                      ; 
    CPI  A,$01                      ; Bit 0: The input buffer was temporarily stored. A system message or a reserve text is shown in the display.
    BZR  BR_894E                    ; $894E
    SJP  (BR_8466)                  ; $8466
    REC                             ; 
    RTN                             ; Done

BR_894E: ; BR $8933,$8947
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    ANI  A,$01                      ; 
    CPI  A,$00                      ; Nothing but Bit 0 was set
    BZR  BR_8959                    ; $8959
    SEC                             ; 
    RTN                             ; Done

BR_8959:
    SJP  (JMP_8C57)                 ; $8C57
    ADI  #(VIDEORAM + $07D2),$FF    ; $77D2
    REC                             ; 
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx
; Called from: BR $8241,$84CD,$866A,$8671,$8678,$8A98
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8963:
    PSH  A                          ; 
    LDI  A,$0A                      ; 
    STA  #(CRTCTRL)                 ; &7800
    LDI  A,$20                      ;
    STA  #(CRTCTRL + $01)           ; $7801
    POP  A                          ; 
    RTN                             ; 
;% LB_xxxx START
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; CLS - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_CLS START
CLS: ; $8974
    PSH  Y                          ; 
    SJP  (JMP_8D41)                 ; $8D41
    ANI  #(VIDEORAM + $07D3),$00    ; $77D3
    POP  Y                          ; 
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

    SJP  ($DFB4)                    ; ***STRBUF_OK
    VEJ  (D0) \ ABYT($00) \ ABRF(BR_89A0) ; $89A0
    CPI  UH,$00                     ; 
    BZS  BR_898F                    ; $898F
    LDA  UH                         ; 
    SJP  (BR_8981)                  ; $89A1

BR_898F:
    LDA  UL                         ; 
    SJP  (BR_8981)                  ; $89A1
    LDI  UL,$04                     ; 
    CPI  UH,$00                     ; 
    BZR  BR_899B                    ; $899B
    LDI  UL,$02                     ; 

BR_899B:
    SJP  (ARX2STRBUF+1)             ; $DFC5
    LDI  UH,$00                     ; 

BR_89A0: 
    RTN                             ; Done

BR_8981:
    PSH  A                          ; 
    AEX                             ; 
    SJP  (BR_89A9)                  ; $89A9
    POP  A                          ; 

BR_89A9:
    ANI  A,$0F                      ; 
    ORI  A,$30                      ; 
    CPI  A,$3A                      ;
    BCR  BR_89B3                    ; $89B3
    ADI  A,$06                      ; 

BR_89B3: 
    SIN  Y                          ; 
    RTN                             ;
;% LB_CLS END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; CONSOLE - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_CONSOLE START
CONSOLE:
    LDA  (Y)                        ; 
    CPI  A,$49                      ; 
    BZR  BR_89C4                    ; $89C4
    ORI  #(VIDEORAM + $07F4),$02    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    INC  Y                          ;
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_89C4:
    CPI  A,$4E                      ; 
    BZR  BR_89D2                    ; $89D2
    ANI  #(VIDEORAM + $07F4),$05    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    INC  Y                          ; 
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_89D2:
    VEJ  (DE) \ ABRF(BR_8A48)       ; $8A48
    VEJ  (D0) \ ABYT($06) \ ABRF(BR_8A48 ) ; $8A48
    LDA  UL                         ; 
    CPI  A,$01                      ; 
    BZR  BR_89E5                    ; $89E5
    ANI  #(VIDEORAM + $07F4),$03    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_89E5:
    CPI  A,$02                      ; 
    BZR  BR_89F2                    ; $89F2
    ORI  #(VIDEORAM + $07F4),$04    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_89F2:
    CPI  A,$00                      ; 
    BZR  BR_8A07                    ; $8A07
    ANI  #(VIDEORAM + $07F4),$00    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    LDI  XH,$8E                     ; ***In unknown table
    LDI  XL,$A1                     ; 
    SJP  (JMP_8DA8)                 ; $8DA8
    BCH  CLS                        ; 

BR_8A07:
    LDA  UL                         ; 
    CPI  A,$50                      ; 
    BZS  BR_8A27                    ; $8A27
    CPI  A,$28                      ; 
    BZR  BR_8A46                    ; $8A46
    ORI  #(VIDEORAM + $07F4),$01    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    LDI  XH,$8E                     ; *** start of unknown table
    LDI  XL,$8F                     ; 
    SJP  (JMP_8DA8)                 ; $8DA8
    LDI  A,$28                      ; 
    STA  #(VIDEORAM + $07D1)        ; $77D1
    BCH  CLS                        ; 

BR_8A27:
    ANI  #(VIDEORAM + $07F4),$06    ; $77F4
    SJP  (JMP_8A38)                 ; $8A38
    LDI  XH,$8E                     ; *** in unknown table
    LDI  XL,$A1                     ; 
    SJP  (JMP_8DA8)                 ; $8DA8
    BCH  CLS                        ; 

JMP_8A38:
    LDA  #(VIDEORAM + $07F4)        ; $77F4
    STA  #($D400)                   ; ***
    RTN                             ; 

;$8A41: 
    SJP  (JMP_8DA8) $8DA8           ; Dead code?
    BCH  CLS                        ;

BR_8A46: ; BR $8A0E
    LDI  UH,$13                     ; 

BR_8A48:
    VEJ  (E0)                       ; (E0) Output error from UH
;% LB_CONSOLE ND
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; CURSOR - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_CURSOR START
CURSOR:
    VEJ  (DE) \ ABRF(BR_8A8A)       ; $8A8A
    VEJ  (D0) \ ABYT($0C) \ ABRF(BR_8A8A) ; $8A8A
    LDA  #(VIDEORAM + $07D1)        ; $77D1
    DEC  A                          ; 
    CPA  UL                         ; 
    BCR  BR_8A59                    ; $8A59
    JMP  JMP_8A5D                   ; $8A5D

BR_8A59:
    LDI  UH,$13                     ; 
    BCH  BR_8A8A                    ; $8A8A

JMP_8A5D:
    LDA  UL                         ; 
    INC  A                          ; 
    PSH  A                          ; 
    VEJ  (C2) \ ACHR($2C) \ ABRF(BR_8A75) ; $8A75
    VEJ  (DE) \ ABRF(BR_8A8A)       ; $8A8A
    VEJ  (D0) \ ABYT($10) \ ABRF(BR_8A88) ; $8A88
    LDA  UL                         ; 
    INC  A                          ; 
    STA  UL                         ; 
    CPI  A,$1A                      ; 
    BZR  BR_8A73                    ; $8A73
    LDI  UH,$13                     ; 
    VEJ  (E0)                       ; (E0) Output error from UH

BR_8A73:
    BCH  BR_8A7E                    ; $8A7E

BR_8A75:
    DEC  Y                          ; 
    PSH  A                          ; 
    LDA  (STRING_VARS + $FE)        ; 
    STA  UL                         ; 
    POP  A                          ; 

BR_8A7E:
    LDA  UL                         ; 
    STA  (STRING_VARS + $FE)        ; 
    POP  A                          ; 
    STA  (STRING_VARS + $FF)        ; 
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_8A88:
    POP  A                          ; 

BR_8A8A:
    VEJ  (E0)                       ; (E0) Output error from UH
;% LB_CURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8A8B:
    LDI  A,$60                      ; 
    STA  (OUTBUF_PTR)               ; $788F
    SJP  (JMP_8C4A)                 ; $8C4A
    ORI  #(VIDEORAM + $07F3),$01    ; $77F3
    SJP  (JMP_8963)                 ; $8963
    LDI  A,$00                      ; 
    LDI  UL,$4F                     ; 
    LDI  XH,HB(OUT_BUF)             ; $7B
    LDI  XL,LB(OUT_BUF)             ; $60 

BR_8AA3:
    SIN  X                          ; 
    LOP  UL,BR_8AA3                 ; $8AA3

BR_8AA6:
    VEJ  (C0)                       ; (C0) Load next character/token into U-REG
    CPI  UH,$F0                     ; 
    BZR  BR_8AAD                    ; $8AAD
    CPI  UL,$85                     ; 

BR_8AAD:
    BZS  BR_8AB2                    ; $8AB2
    VEJ  (C6)                       ; (C6) Correct program pointer
    BCH  BR_8AB6                    ; $8AB6

BR_8AB2:
    VMJ  ($9A)                      ; (9A) Determines and transmits USING parameters
    VCS  ($E0)                      ; (E0) Output error from UH

BR_8AB6:
    LDA  (Y)                        ; 
    CPI  A,$0D                      ; 
    BZS  BR_8B9E                    ; $8B9E

BR_8ABB:
    LDA  (Y)                        ; 
    CPI  A,$3A                      ; 
    BZS  BR_8B9E                    ; $8B9E
    VMJ  ($2E) \ ABRF(BR_8AC5)      ; $8AC5
    BCH  BR_8AC8                    ; $8AC8

BR_8AC5:
    JMP  JMP_8C38                   ; $8C38

BR_8AC8:
    LDA  (ARX + $04)                ; 
    CPI  A,$C1                      ; 
    BZS  BR_8B27                    ; $8B27
    CPI  A,$D0                      ; 
    BZS  BR_8B27                    ; $8B27
    LDA  (USINGF)                   ; 
    CPI  A,$00                      ; 
    BZR  BR_8AF7                    ; $8AF7
    LDI  A,$10                      ; 
    STA  (STR_BUF_PTR_L)            ; 
    PSH  Y                          ; 
    SJP  (BCMD_STR)                 ; 
    POP  Y                          ; 
    CPI  UH,$00                     ; 
    BZR  BR_8AC5                    ; $8AC5
    LDA  (ARX + $01)                ; 
    CPI  A,$00                      ; 
    BZR  BR_8AF5                    ; $8AF5
    ADI  (OUTBUF_PTR),$01           ; $788F

BR_8AF5:
    BCH  BR_8B27                    ; $8B27

BR_8AF7:
    PSH  Y                          ; 
    VEJ  (D2) \ ABRF(BR_8AFC-1) \ ABYT($80) ; -1 hack as target calc 1 off

BR_8AFC:
    VMJ  ($96)                      ; 
    LDA  YL                         ; 
    REC                             ; 
    SBC  XL                         ; 
    STA  UL                         ; 

BR_8B02:
    LIN  X                          ; 
    CPI  A,$20                      ; 
    BZR  BR_8B0C                    ; $8B0C
    LOP  UL,BR_8B02                 ; $8B02
    LDI  UH,$01                     ;
    VEJ  (E0)                       ; (E0) Output error from UH

BR_8B0C:
    DEC  X                          ; 
    LDA  (ARX + $01)                ; 
    CPI  A,$80                      ; 
    BZS  BR_8B15                    ; $8B15
    DEC  X                          ; 

BR_8B15:
    LDA  YL                         ; 
    SEC                             ; 
    INC  A                          ; 
    SBC  XL                         ; 
    INC  A                          ; 
    STA  UL                         ; 
    LDI  YH,HB(ARX)                 ; $7A
    LDI  YL,LB(ARX+5)               ; $05
    LDA  XH                         ; 
    SIN  Y                          ; 
    LDA  XL                         ; 
    SIN  Y                          ; 
    LDA  UL                         ; 
    STA  (Y)                        ; 
    POP  Y                          ; 

BR_8B27:
    PSH  Y                          ; 
    VEJ  (DC)                       ; (DC) Load CSI from AR-X to X-Reg
    LDA  (USING_CHR)                ; 
    CPI  A,$00                      ; 
    BZR  BR_8B35                    ; $8B35

BR_8B31:
    PSH  A                          ; 
    BCH  BR_8B52                    ; $8B52

BR_8B35:
    PSH  A                          ; 
    LDA  (ARX + $04)                ; 
    CPI  A,$D0                      ; 
    BZS  BR_8B44                    ; $8B44
    POP  A                          ; 
    LDI  A,$00                      ; 
    BCH  BR_8B31                    ; $8B31

BR_8B44:
    POP  A                          ; 
    CPA  UL                         ; 
    BCS  BR_8B4E                    ; $8B4E
    STA  UL                         ; 
    LDI  A,$00                      ; 
    BCH  BR_8B31                    ; $8B31

BR_8B4E:
    SEC                             ; 
    SBC  UL                         ; 
    PSH  A                          ; 

BR_8B52:
    VMJ  ($94)                      ; (94) Transfers string whose address is in the X-Reg to the output buffer (*VMJ diss is wrong)
    POP  A                          ; 
    CPI  A,$00                      ; 
    BZS  BR_8B69                    ; $8B69
    STA  UL                         ; 
    LDI  A,$20                      ; 
    DEC  UL                         ; 
    CPI  UL,$50                     ; 
    BCS  BR_8B69                    ; $8B69

BR_8B62:
    CPI  YL,$B0                     ; 
    BCS  BR_8B69                    ; $8B69
    SIN  Y                          ; 
    LOP  UL,BR_8B62                 ; $8B62

BR_8B69:
    LDA  YL                         ; 
    STA  (OUTBUF_PTR)               ; $788F
    POP  Y                          ;
    LIN  Y                          ; 
    STA  #(VIDEORAM + $07D3)        ; $77D3
    CPI  A,$3B                      ; 
    BZS  BR_8AA6                    ; $8AA6
    CPI  A,$2C                      ; 
    BZR  BR_8B91                    ; $8B91
    LDI  A,$11                      ; 
    SEC                             ; 
    SBC  (ARX + $07)                ; 
    CPI  A,$11                      ; 
    BCR  BR_8B88                    ; $8B88
    LDI  A,$01                      ; 

BR_8B88:
    REC                             ; 
    ADC  (OUTBUF_PTR)               ; $788F
    STA  (OUTBUF_PTR)               ; $788F
    BCH  BR_8ABB                    ; $8ABB

BR_8B91:
    DEC  Y                          ; 
    CPI  A,$3A                      ; 
    BZS  BR_8B9E                    ; $8B9E
    CPI  A,$0D                      ; 
    BZS  BR_8B9E                    ; $8B9E
    LDI  UH,$01                     ; 
    BCH  JMP_8C38                   ; $8C38

BR_8B9E:
    PSH  Y                          ; 
    LDA  (STRING_VARS + $FE)        ; 
    CPI  A,$19                      ; 
    BCR  BR_8BAA                    ; $8BAA
    SJP  (JMP_84D7)                 ; $84D7

BR_8BAA:
    STA  YH                         ; 
    LDA  (STRING_VARS + $FF)        ; 
    STA  YL                         ; 
    SJP  (JMP_8D6B)                 ; $8D6B
    LDI  XH,HB(OUT_BUF)             ; $7B
    LDI  XL,LB(OUT_BUF)             ; $60
    LDA  (OUTBUF_PTR)               ; $788F 
    REC                             ; 
    SBI  A,$60                      ; 
    BCS  BR_8BBF                    ; $8BBF
    INC  A                          ; 

BR_8BBF:
    STA  UL                         ; 

BR_8BC0:
    LIN  X                          ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 
    ADI  (STRING_VARS + $FF),$01    ; 
    LDA  (STRING_VARS + $FF)        ; 
    CPA  #(VIDEORAM + $07D1)        ; $77D1
    BCR  BR_8BFC                    ; $8BFC
    BZS  BR_8BFC                    ; $8BFC
    ANI  (STRING_VARS + $FF),$01    ; 
    ADI  (STRING_VARS + $FE),$01    ; 
    LDA  (STRING_VARS + $FE)        ; 
    CPI  A,$1A                      ; 
    BCR  BR_8BFC                    ; $8BFC
    CPI  UL,$00                     ; 
    BZS  BR_8BFC                    ; $8BFC
    PSH  X                          ; 
    PSH  U                          ; 
    SJP                             ; (JMP_84D7) ; $84D7
    LDA  (STRING_VARS + $FE)        ; 
    STA  YH                         ; 
    LDA  (STRING_VARS + $FF)        ; 
    STA  YL                         ; 
    SJP  (JMP_8D6B)                 ; $8D6B
    POP  U                          ; 
    POP  X                          ; 

BR_8BFC:
    LOP  UL,BR_8BC0                 ; $8BC0
    LDX  Y                          ; 
    DEC  X                          ; 
    POP  Y                          ; 
    DEC  Y                          ; 
    LIN  Y                          ; 
    CPI  A,$3B                      ; 
    BZS  BR_8C17                    ; $8C17
    LDI  A,$01                      ; 
    CPA  (STRING_VARS + $FF)        ; 
    BZS  BR_8C17                    ; $8C17
    STA  (STRING_VARS + $FF)        ; 
    ADI  (STRING_VARS + $FE),$01    ; 

BR_8C17:
    SJP  (JMP_88BF)                 ; $88BF
    LDI  UH,$00                     ; 
    ANI  #(VIDEORAM + $07D3),$00    ; $77D3
    VEJ  (D8)                       ; 
    BZR  BR_8C29                    ; $8C29
    LDI  A,$03                      ; 
    STA  (WAIT_CFG)                 ; 

BR_8C29:
    LDA  (WAIT_CFG)                 ; 
    CPI  A,$02                      ; 
    BZS  BR_8C3F                    ; $8C3F
    LDA  (STRING_VARS + $FE)        ; 
    STA  #(VIDEORAM + $07D2)        ; $77D2
    VEJ  (E2)                       ; 

JMP_8C38:
    LDI  A,$0D                      ; 
    STA  #(VIDEORAM + $07D3)        ; $77D3
    VEJ  (E0)                       ; 

BR_8C3F:
    LDA  (WAIT_CTR_H)               ;
    STA  UH                         ; 
    LDA  (WAIT_CTR_L)               ; 
    STA  UL                         ; 
    VMJ  ($AC)                      ; 
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8C4A:
    LDI  A,$0A                      ; 
    STA  #(CRTCTRL)                 ; 
    LDI  A,$10                      ;
    STA  #(CRTCTRL + $01)           ; 
    RTN                             ; Done
;% LB_xxxx START
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; xxxx - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8C57:
    LDA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    ANI  A,$01                      ; 
    CPI  A,$01                      ; Bit 0: The input buffer was temporarily stored. A system message or a reserve text is shown in the display.
    BZS  BR_8C62                    ; $8C62
    REC                             ; 
    RTN                             ; Done

BR_8C62:
    VMJ  ($38)                      ; 
    LDI  UH,$02                     ; 
    LDI  UL,$19                     ; 
    LDA  #(VIDEORAM + $07D2)        ; 
    STA  YH                         ; 
    LDI  YL,$01                     ; 
    SJP  (JMP_8D6B)                 ; $8D6B

BR_8C72:
    SJP  (JMP_8D64)                 ; $8D64
    DEC  UH                         ; 
    BCS  BR_8C80                    ; $8C80
    ADI  #(VIDEORAM + $07D2),$01    ; 
    SEC                             ; 
    RTN                             ; Done

BR_8C80:
    LDI  A,$20                      ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 
    LDI  UL,$19                     ; 
    BCH  BR_8C72                    ; $8C72
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; INPUT - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_INPUT START
INPUT:
    VEJ  (C2) \ ACHR($23) \ ABRF(BR_8C8F) ; $8C8F
    JMP  BCMD_CLEAR+8               ; $C8FD

BR_8C8F:
    VEJ  (D8)                       ; (D8) Checks calculator mode
    BZR  BR_8C95                    ; $8C95
    LDI  UH,$1A                     ;
    VEJ  (E0)                       ; (E0) Output error from UH

BR_8C95:
    VEJ  (C6)                       ; (C6) Correct program pointer
    SJP  (INBUF_CLR)                ; 
    VEJ  (C2) \ ACHR($22) \ ABRF(BR_8CFB) ; $8CFB
    VMJ  ($0C)                      ; 
    PSH  Y                          ; 
    LDI  YL,HB(IN_BUF)              ; $B0
    LDI  YH,LB(IN_BUF)              ; $7B
    PSH  A                          ; 
    LDA  (STRING_VARS + $FE)        ; 
    STA  #(VIDEORAM + $07D2)        ; 
    POP  A                          ; 
    ADI  (STRING_VARS + $FE),$01    ; 
    LDA  (ARX + $07)                ; 
    STA  UL                         ; 
    SJP  (UL_XREG2YREG)             ; 
    LDA  YL                         ; 
    STA  (INBUFPTR_L)               ; 
    POP  Y                          ; 
    VEJ  (C2) \ ACHR($3B) \ ABRF(BR_8CC7) ; $8CC7
    LDI  A,$40                      ; 
    BCH  BR_8CD1                    ; 

BR_8CC7:
    VEJ  (C4) \ ACHR($2C) \ ABRF(BR_8D15) ; $8D15

BR_8CCA:
    LDI  A,$B0                      ; 
    STA  (INBUFPTR_L)               ; 
    LDI  A,$00                      ; 

BR_8CD1:
    STA  (DISPARAM)                 ; $7880 - Reset Display Parameter: determines display at READY
    VEJ  (CE) \ ABYT($58) \ ABRF($8D05) ; ***
    VEJ  (F6) \ AWRD(LASTVARADD_H)  ;
    INC  X                          ; 
    LDA  (ARX + $07)                ; 
    STA  (X)                        ; 
    VEJ  (D4) \ ABYT($A0)           ; 
    VEJ  (D4) \ ABYT($AC)           ; 
    SJP  (PREPLCDOUT)               ; 
    LDI  UH,$20                     ; 
    VCS  ($E0)                      ; 
    ORI  (BREAKPARAM),$50           ; 
    LDA  (INBUFPTR_L)               ; 
    STA  YL                         ; 
    LDI  YH,$7B                     ; 
    ANI  (CURS_CTRL),$9F            ; 
    JMP  JMP_8D18                   ; $8D18

BR_8CFB:
    PSH  A                          ; 
    LDA  (STRING_VARS + $FE)        ; 
    STA  #(VIDEORAM + $07D2)        ; 
    POP  A                          ; 
    ADI  (STRING_VARS + $FE),$01    ; 
    VEJ  (C6)                       ; 
    LDI  A,$3F                      ; 
    STA  (IN_BUF)                   ; 
    BCH  BR_8CCA                    ; $8CCA
    LDI  UH,$07                     ; 
    VEJ  (E0)                       ; (E0) Output error from UH

BR_8D15:
    JMP  BCMD_DIM + $5B             ; $C9E3

JMP_8D18:
    SJP  (PRGMDISP)                 ; 
    ANI  (CURR_LINE_L),$00          ; 
    ANI  (CURR_LINE_H),$00          ; 
    ANI  (DISP_BUFF + $4E),$FE      ; 
    LDI  S,(CPU_STACK + $4F)        ; 
    SJP  (WAIT4KB)                  ; 
    BII  #(VIDEORAM + $07F3),$01    ; 
    BZR  BR_8D39 ; $8D39            ; 
    ADI  #(VIDEORAM + $07D2),$FF    ; 

BR_8D39:
    ANI  #(VIDEORAM + $07F3),$00    ; 
    JMP  $CA92                      ; $CA92 ***EDITOR + $12 

JMP_8D41:
    LDI  UH,$07                     ; 
    LDI  UL,$CF                     ; 
    LDI  A,$00                      ; 
    SJP  (Y2_VIDRAM)                ; $8E5F - Sets Yreg to point to Video RAM

BR_8D4A:
    SJP  (BR_8D5E)                  ; $8D5E
    DEC  UH                         ; 
    BCS  BR_8D4A                    ; $8D4A
    LDI  A,$01                      ; 
    STA  #(VIDEORAM + $07D2)        ; 
    STA  (STRING_VARS + $FE)        ; 
    STA  (STRING_VARS + $FF)        ; 
    RTN                             ; Done

BR_8D5E:
    STA  #(Y)                       ; 
    INC  Y                          ; 
    LOP  UL,BR_8D5E                 ; $8D5E
    RTN                             ; Done

JMP_8D64:
    LIN  X                          ; 
    STA  #(Y)                       ; 
    INC  Y                          ; 
    LOP  UL,JMP_8D64                ; $8D64
    RTN                             ; Done

JMP_8D6B:
    PSH  A                          ; 
    PSH  X                          ; 
    PSH  U                          ; 
    LDX  Y                          ; 
    DEC  XH                         ; 
    DEC  XL                         ; 
    SJP  (Y2_VIDRAM)                ; $8E5F - Sets Yreg to point to Video RAM
    LDA  YL                         ; 
    SEC                             ; 
    SBI  A,$50                      ; 
    STA  YL                         ; 
    LDA  YH                         ; 
    SBI  A,$00                      ; 
    STA  YH                         ; 
    CPI  XH,$19                     ; 
    BCS  BR_8DA3                    ; $8DA3
    CPI  XL,$50                     ; 
    BCS  BR_8DA3                    ; $8DA3
    LDA  XH                         ; 
    STA  UL                         ; 
    LDA  #(VIDEORAM + $07D1)        ; 
    CPI  A,$28                      ; 
    BZR  BR_8D95                    ; $8D95
    INC  UL                         ; 

BR_8D95:
    ADR  Y                          ; 
    LOP  UL,BR_8D95                 ; $8D95
    LDA  XL                         ; 
    ADR  Y                          ; 

BR_89DC:
    POP  U                          ; 
    POP  X                          ; 
    POP  A                          ; 
    RTN                             ; Done

BR_8DA3:
    SJP  (Y2_VIDRAM)                ; $8E5F - Sets Yreg to point to Video RAM
    BCH  BR_89DC                    ; $8D9C

JMP_8DA8:
    LDI  UH,$00                     ; 
    LDI  UL,$11                     ; 

BR_8DAC:
    LDA  UH                         ; 
    STA  #(CRTCTRL)                 ; 
    LIN  X                          ; 
    STA  #(CRTCTRL + $01)           ; 
    INC  UH                         ; 
    LOP  UL,BR_8DAC                 ; $8DAC
    LDI  A,$50                      ; 
    STA  #(VIDEORAM + $07D1)        ; 
    RTN                             ; 
;% LB_INPUT END
;------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------
; $8DC1 - TBL_INIT: Called by table init vector
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_TBL_INIT START
TBL_INIT: ; 
    PSH  X                          ; Save registers
    PSH  Y                          ; 
    PSH  U                          ; 
    LDA  (WAIT4KB + $74)            ; $E2B7 = $F4 (A01 ROM), $CC (A03/4 ROM)
    CPI  A,$CC                      ; Is this ROM A03/4?
    BZR  BR_8DD0 ; $8DD0            ; If A <> $CC, i.e. A01 ROM
    BCH  BR_8E03 ; $8E03            ; If A = $CC

BR_8DD0:                            ; A01 ROM Init
    LDI  XL,$1A                     ; Length of text                    
    LDI  UH,HB(IWS_SPLASH)          ; $93 - Prints IWS contact info 
    LDI  UL,LB(IWS_SPLASH)          ; $6D
    SJP  (TEXTUREG_XL)              ; $ED38 - Outputs text from U-Reg. XL = number of characters
    SJP  (BCMD_BEEP_STD)            ;
    BCH  BR_8DEA ; $8DEA            ;

BR_8DDE:
    LDI  XL,$1A                     ; Length of text
    LDI  UH,HB(IWS_SPLASH)          ; $93 - Prints IWS contact info
    LDI  UL,LB(IWS_SPLASH)          ; $6D
    SJP  (TEXTUREG_XL)              ; $ED38 - Outputs text from U-Reg. XL = number of characters
    SJP  (BCMD_BEEP_STD)            ;

BR_8DEA:
    SJP  (WAIT4KB)                  ; Waiting for character input from keyboard. Accumulator=character
    CPI  A,$0E                      ; $0E is not a key
    BZS  BR_8DF4 ; $8DF4            ; If A==$0E
    JMP  BR_8DF8 ; $8DF8            ; If A<>$0E

BR_8DF4:
    BCR  BR_8DDE ; $8DDE            ; If A<$0E loop back to character output, don't think this will ever be true
    BCH  BR_8DFA ; $8DFA            ; To exit

BR_8DF8:
    BCS  BR_8DDE ; $8DDE            ; If A>$0E loop back to character output

BR_8DFA:
    POP  U                          ; restore registers
    POP  Y                          ; 
    POP  X                          ; 
    JMP  JMP_92D6 ; $92D6           ; Exit where output error $1B from UH


BR_8E03:                            ; ROM A03/4 Init
    LDI  A,$00                      ;
    STA  (KATAFLAGS)                ; Turn off Katakana mode?
    STA  #($D400)                   ; Some HW register on IWS board?
    STA  #(VIDEORAM + $07F4)        ; 
    SJP  (JMP_8D41)                 ; $8D41
    LDI  A,$0F                      ;
    SJP  (COLOR_FILL)                 ; $906A
    LDI  A,$00                      ;
    SJP  (JMP_911A)                 ; $911A
    LDI  A,$55                      ; 
    STA  ($79D5)                    ; This is an unkown bypass, perhaps used as IWS active?
    LDI  A,$01                      ; 
    STA  #(VIDEORAM + $07D9)        ; 
    LDI  XH,$8E                     ; Inisde mystry table
    LDI  XL,$A1                     ; 
    SJP  (JMP_8DA8)                 ; $8DA8
    LDI  A,$80                      ; 
    STA  #(VIDEORAM + $07DA)        ;
    LDI  A,$07                      ; 
    STA  #(VIDEORAM + $07DB)        ;
    ANI  (KB_BYPASS),$00            ; $79D4
    LDI  A,HB(XCHR_INPUT)           ; $81 - Address of exernal character input routine (H)
    STA  (XCHRINPT_H)               ; $785B
    LDI  A,LB(XCHR_INPUT)           ; $9E - Address of exernal character input routine (L)
    STA  (XCHRINPT_L)               ; $785C
    ANI  #(VIDEORAM + $07D7),$00    ;
    ANI  #(VIDEORAM + $07D8),$00    ;
    LDI  A,$55                      ;
    STA  (KB_BYPASS) ; $79D4        ; Enable KB bypass
    POP  U                          ; restore registers
    POP  Y                          ; 
    POP  X                          ; 
    RTN                             ; Done
;% LB_TBL_INIT END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8E5F - Y2_VIDRAM: Reset Y to point to Video RAM -> $7000
; Called from: $84E6, $8D47, $8D76, $8DA3, $8E5F, $8E86
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_Y2_VIDRAM START
Y2_VIDRAM: 
    LDI  YH,HB(VIDEORAM)            ; $70  - video RAM
    LDI  YL,LB(VIDEORAM)            ; $00 
    RTN
;% LB_Y2_VIDRAM END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8E64 - CL_SCR
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_CL_SCR START
CL_SCR:
    PSH  Y                          ; 
    SJP  (JMP_8E86)                 ; $8E86
    LDI  A,$00                      ;
    BCH  BR_8E78                    ; $8E78
    PSH  Y                          ;
    SJP  (JMP_8E86)                 ; $8E86
    REC                             ; 
    ADI  A,$08                      ; 
    STA  YH                         ; 
    LDI  A,$F0                      ; 

BR_8E78:
    LDI  UH,$07                     ; Size of Video RAM?
    LDI  UL,$FF                     ;

BR_8E7C:
    SJP  (BR_8D5E)                  ; $8D5E
    DEC  UH                         ; 
    BCS  BR_8E7C                    ; $8E7C
    POP  Y                          ;
    RTN                             ;
;% LB_CL_SCR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; 8E86 - Sets Color RAM address based on video RAM?
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8E86:
    SJP  (Y2_VIDRAM)                ; $8E5F - Sets Yreg to point to Video RAM
    LDA  YH                         ; A = $70
    AEX                             ; A = $07, High nibble & low nibble swapped
    DEC  A                          ; A = $06
    AEX                             ; A = $60
    STA  YH                         ; Y = $60, Color RAM
    RTN                             ; Done
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
;$8E8F ~ $8EEA
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
    .BYTE  $3B,$28,$30,$74,$1C,$00,$19,$1A
    .BYTE  $00,$0A,$68,$00,$70,$00,$00,$00
    .BYTE  $00,$00,$74,$50,$5C,$35,$1C,$00
    .BYTE  $19,$1A,$00,$0A,$68,$00,$70,$00
    .BYTE  $00,$00,$00,$00,$52,$55,$4E,$50
    .BYTE  $52,$4F,$52,$45,$53,$45,$52,$56
    .BYTE  $45,$20,$45,$42,$45,$4E,$45,$3A
    .BYTE  $28,$43,$29,$20,$62,$79,$20,$49
    .BYTE  $6E,$67,$2E,$42,$75,$65,$72,$6F
    .BYTE  $20,$57,$2E,$53,$70,$65,$69,$64
    .BYTE  $65,$6C
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8EE1 - MONITOR
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_MONITOR START
MONITOR:
    JMP JMP_92D6                    ; $92D6
;% LB_MONITOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8EE4 - VCURSOR
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_VCURSOR START
VCURSOR:
    LDA  (STRING_VARS + $FE)        ;
    DEC  A                          ; 
    JMP  BCMD_LEN + $0D             ; $D9E4
;% LB_VCURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8EEB - VPCURSOR: 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_VPCURSOR START
VPCURSOR: ; 
    LDI  A,$10                      ; 
    STA  #(CRTCTRL)                 ; 
    LDA  #(CRTCTRL + $01)           ; 
    STA  #(VIDEORAM + $07F6)        ; $77F6
    DEC  A                          ; 
    JMP  BCMD_LEN + $0D             ; $D9E4
;% LB_VPCURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8EFD - HCURSOR:  
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_HCURSOR START
HCURSOR:
    LDA  (STRING_VARS + $FF)        ; 
    DEC  A                          ; 
    JMP  BCMD_LEN + $0D             ; $D9E4
;% LB_HCURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8F04 - HPCURSOR: 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_HPCURSOR START
HPCURSOR:
    SBC  XL                         ; 
    SBC  (Y)                        ;                      
    STA  #(CRTCTRL)                 ;
    LDA  #(CRTCTRL + $01)           ;
    STA  #(VIDEORAM + $07F5)        ;
    DEC  A                          ;
    JMP  BCMD_LEN + $0D             ; $D9E4
;% LB_HPCURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8F16 - LIST: 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_LIST START
LIST:
    LDA  (DISP_BUFF + $4F)          ; 
    ANI  A,$07                      ; 
    ORI  A,$20                      ; 
    STA  (DISP_BUFF + $4F)          ; 
    LDA  (Y)                        ; 
    CPI  A,$0D                      ; CR = EOL
    BZR  BR_8F27 ; $8F27            ; A = $0D
    BCH  JMP_8F46 ; $8F46           ; A <> $0D

BR_8F27:
    CPI  A,$50                      ; 
    BZR  BR_8F33                    ; A = $$50
    INC  Y                          ; 
    LDA  (Y)                        ; 
    CPI  A,$0D                      ; 
    BZR  BR_8F33                    ; A = $0D
    BCH  BR_8F54                    ; A <> $0D

BR_8F33:
    CPI  A,$56                      ; 
    BZR  BR_8F40                    ; A = $56
    INC  Y                          ; 
    LDA  (Y)                        ; 
    CPI  A,$0D                      ;
    BZR  BR_8F40                    ; A = $0D
    JMP  JMP_92D6                   ; A <> $0D

BR_8F40:
    JMP  BCMD_LIST + 1              ; $C96F
;% LB_LIST START
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8F43 - JMP_8F43: 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_JMP_8F43 START
JMP_8F43: ; VLISTALL
    JMP  B_TBL_8000                 ; $8000
;% LB_JMP_8F43 END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $8F46 - xxxx: 
; Called from LIST:$8F25
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
JMP_8F46:
    SJP  (JMP_908E)                 ; $908E
    VEJ  (CC) \ ABYTL(ROM_ST_H)     ; $7861
    LDI  A,$FF                      ; 
    CPA  XH                         ; 
    BZR  BR_8F54                    ; $8F54
    VEJ  (CC) \ ABYTL(BASPRG_ST_H)  ; $7865
    BCH  BR_8F56                    ; $8F56

BR_8F54:
    VEJ  (CC) \ ABYTL(BASPRG_EDT_H) ; $7869

BR_8F56:
    LDA  (X)                        ; 
    CPI  A,$FF                      ; 
    BZR  BR_8F5C                    ; $8F5C
    VEJ  (E2)                       ; 

BR_8F5C:
    LDI  A,$55                      ; 
    STA  #(VIDEORAM + $07D9)        ; 
    LDA  (WAIT_CFG)                 ; WAIT setting
    CPI  A,$00                      ; 
    BZR  BR_8F76                    ; $8F76
    LDI  A,$02                      ; 
    STA  (WAIT_CFG)                 ; WAIT setting
    LDI  A,$00                      ; 
    STA  (WAIT_CTR_H)               ; WAIT time counter (H)
    STA  (WAIT_CTR_L)               ; WAIT time counter (L)

BR_8F76:
    LDI  A,$03                      ; 
    ADR  X                          ; 
    VEJ  (CA) \ ABYTL(SRCH_ADD_H)   ; $78A6

BR_8F7C:
    DEC  X                          ; 
    DEC  X                          ; 
    SJP  (XFRLINE2INBUF)            ; $D2D0
    LDI  A,$14                      ; Bit 0: The input buffer was temporarily stored. A system message or a reserve text is shown in the display.
                                    ; Bit 6: The display program shows from (Y-Reg)
    STA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    SJP  (PRGMDISP)                 ; 
    LDI  A,$02                      ; 
    STA  #(PC1500_IF_REG)           ; 
    SJP  (XCHR_INPUT)               ; $819E
    VEJ  (F4) \ AWRD(WAIT_CTR_H)    ; 

BR_8F95:
    PSH  U                          ; 

BR_8F97:
    NOP                             ;
    NOP                             ;
    LOP  UL,BR_8F97                 ; $8F97
    POP  U                          ;
    LOP  UL,BR_8F95                 ; $8F95
    CPI  UH,$00                     ; 
    BZS  BR_8FA7                    ; $8FA7
    DEC  UH                         ; 
    BCH  BR_8F95                    ; $8F95

BR_8FA7:
    SJP  (KEY2ASCII)                ; Return ASCII code of key pressed in Accumulator. If no key: C=1.
    CPI  A,$20                      ; 
    BZR  BR_8FB0                    ; $8FB0
    BCH  BR_8FA7                    ; $8FA7

BR_8FB0:
    SJP  (KEY2ASCII)                ; Return ASCII code of key pressed in Accumulator. If no key: C=1.
    CPI  A,$0B                      ; 
    BZR  BR_8FBF                    ; $8FBF
    LDI  A,$99                      ; 
    STA  #(VIDEORAM + $07D9)        ; 
    BCH  BR_9010                    ; $9010

BR_8FBF:
    LDA  #(PC1500_MSK_REG)          ; 
    ANI  A,$20                      ; 
    CPI  A,$20                      ; 
    BZR  BR_8FD7                    ; $8FD7
    LDI  A,$00                      ; 
    STA  (ERR_LINE_L)               ; 
    ANI  #(VIDEORAM + $07DF),$00    ; 
    SJP  ($DC32)                    ; Stores 8 bytes from address X-Reg to AR-X.
    VEJ  (E2)                       ; 

BR_8FD7:
    LDA  #(VIDEORAM + $07D2)        ; 
    INC  A                          ; 
    STA  #(VIDEORAM + $07D2)        ; 
    VEJ  (CC) \ ABYTL(SRCH_ADD_H)   ; $78A6
    INC  X                          ; 
    INC  X                          ; 
    LDA  (X)                        ; 
    ADR  X                          ; 
    INC  X                          ; 
    LDE  X                          ; 
    CPI  A,$FF                      ; 
    BZR  BR_8FEF                    ; $8FEF
    BCH  BR_9010                    ; $9010

BR_8FEF:
    VEJ  (CA) \ ABYTL(SRCH_ADD_H)   ; $78A6
    LDI  A,$04                      ; 
    ADR  X                          ; 
    STX  Y                          ; 
    LDA  #(VIDEORAM + $07D9)        ; 
    CPI  A,$55                      ; 
    BZR  BR_900E                    ; $900E
    LDI  A,$00                      ; 
    STA  #(VIDEORAM + $07D9)        ; 
    LDA  #(VIDEORAM + $07D2)        ; 
    DEC  A                          ; 
    STA  #(VIDEORAM + $07D2)        ;

BR_900E:
    BCH  BR_8F7C                    ; $8F7C

BR_9010:
    VEJ  (CC) \ ABYTL(SRCH_ADD_H)   ; $78A6
    LDI  A,$04                      ; 
    ADR  X                          ; 
    STX  Y                          ; 
    VEJ  (CA) \ ABYTL(ERR_ADD_H)    ; $78B2
    LDI  A,$01                      ; 
    STA  (ERR_LINE_L)               ; 
    SJP  ($DC32)                    ; Stores 8 bytes from address X-Reg to AR-X.
    VEJ  (E2)                       ; 
;% LB_LIST END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; BACKGR - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_BACKGR START
BACKGR:
    VEJ  (DE) \ ABRF(BR_9081)       ; $9081
    VEJ  (D0) \ 
         ABYT($10) \ ABRF(BR_9081)  ; $9081
    CPI  A,$10                      ;
    BCR  BR_902F                    ; $902F
    LDI  UH,$13                     ; 
    VEJ  (E0)                       ; 

BR_902F:
    LDA  UL                         ; 
    AEX                             ; 
    STA  #(STRING_VARS + $18D)      ; $77DD
    VEJ  (C0)                       ; 
    CPI  UL,$0D                     ; 
    BZR  BR_9045                    ; $9045
    LDA  #(STRING_VARS + $18D)      ; 
    CPI  A,$0A                      ; 
    ORI  A,$0F                      ; 
    STA  UL                         ; 
    BCH  BR_9065                    ; $9065

BR_9045:
    CPI  A,$2C                      ; 
    BZR  BR_9064                    ; $9064
    VEJ  (DE) \ ABRF(BR_9081)       ; $9081
    VEJ  (D0) \ ABYT($10) \ ABRF(BR_9081) ; $9081
    CPI  A,$10                      ; 
    BCR  BR_9055                    ; $9055
    LDI  UH,$13                     ; 
    VEJ  (E0)                       ; 

BR_9055:
    STA  #(VIDEORAM + $07DE)        ; $77DE
    ORA  #(VIDEORAM + $07DD)        ; $77DD
    STA  UL                         ; 
    STA  #(VIDEORAM + $07DC)        ; $77DC
    BCH  BR_9065                    ; $9065

BR_9064:
    VEJ  (E4)                       ; 

BR_9065:
    LDA  UL                         ;
    SJP  (COLOR_FILL)               ; $906A
    VEJ  (E2)                       ;
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $906A - COLOR_FILL: Fills Color RAM with value passed in A
; Called from: TBL_INIT:8E15, BACKGR:9066
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_COLOR_FILL START
COLOR_FILL:
    LDI  XH,$60                     ; IWS $6000~$67FF color RAM
    LDI  XL,$00                     ; 
    LDI  UH,$07                     ; Loop counter
    LDI  UL,$D0                     ; $6000~$67D0

BR_9072:
    STA  #(X)                       ; Store color in A to Color RAM
    INC  X                          ; Inc address pointer
    DEC  U                          ; Dec counter
    CPI  UH,$00                     ; 
    BZR  BR_907F                    ; HB of count = 0
    CPI  UL,$00                     ; 
    BZR  BR_907F                    ; LB of count = 0
    RTN                             ; Done

BR_907F:
    BCH  BR_9072                    ; $9072

BR_9081:
    VEJ  (E0)                       ; (E0) Error according to UH
;% LB_COLOR_FILL END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $9082 - ERN:
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_ERN START
ERN:
    LDA  (ERL)                      ;
    JMP  BCMD_LEN + $0D             ; $D9E4
;% LB_ERN END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $9088 - ERL:
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_ERL START
IWS_ERL:
    VEJ  (F4) \ AWRD(ERR_LINE_H)    ;
    JMP  BCMD_MEM + $0F             ; $DA6C

JMP_908E:
    LDA  (ST_ROM_MOD)               ; $7860
    STA  XH                         ; 
    CPI  A,$FF                      ; 
    BZR  BR_909A                    ; $909A
    LDA  (RAM_ST_H)                 ; 
    STA  XH                         ; 

BR_909A:
    LDI  XL,$00                     ; 
    LDA  (X)                        ;
    CPI  A,$55                      ; 
    BZR  BR_90A9                    ; $90A9
    LDI  XL,$07                     ; 
    LDA  (X)                        ; 
    CPI  A,$00                      ; 
    BZR  BR_90A9                    ; $90A9
    VEJ  (E2)                       ;

BR_90A9:
    RTN                             ; 
;% LB_ERL END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $90AA - SLEEP:
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;% LB_SLEEP START
SLEEP:
    LDA  YH                         ;
    CPI  A,$7B                      ;
    BZS  BR_90B3                    ; Skip sleep if YH = $7B. Why?
    SJP  (AUTO_OFF)                 ; Power down
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_90B3: 
    LDI  S,(CPU_STACK + $4F)        ; 
    SJP  ($CFCC)                    ; (INITSYSADDR) $CFCC Init Sys Addr, turn off trace
    SJP  ($D02B)                    ; (INBUF_CLRINIT) $D02B Clear IN_BUF w/$0D
    LDI  A,$3E                      ; 
    STA  (Y)                        ; 
    ANI  (BREAKPARAM),$EF           ;
    ANI  (DISP_BUFF + $4E),$FE      ;
    LDI  A,$00                      ; Resest Display Parameter
    STA  (DISPARAM)                 ; $7880 - Display Parameter: determines display at READY
    STA  (CURR_LINE_H)              ;
    STA  (CURR_LINE_L)              ; 
    SJP  (PRGMDISP)                 ; 
    LDI  XH,$CA                     ; HB(EDITOR+$12) $CA
    LDI  XL,$92                     ; HB(EDITOR+$12) $92
    PSH  X                          ;
    JMP  AUTO_OFF                   ; $E33F

JMP_90DE:
    PSH  A                          ; 
    LDA  ($79D5)                    ; ***mystery bypass
    CPI  A,$55                      ; Check for $55 bypass flag
    BZR  BR_90EE                    ; If not bypassed
    POP  A                          ; If bypassed
    ORI  (CURS_CTRL),$40            ; Cursor Control Parameter
    RTN                             ;

BR_90EE:
    POP  A                          ; 
    RTN                             ; 
;% LB_SLEEP END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; REPKEY - 
; Called from:
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_REPKEY START
REPKEY:
    VEJ  (C2) \ AWRD($F19C) \ ABRF(BR_90FB) ; BCMD_LOG ($F165+?) \ $90FB
    LDI  A,$55                      ; 

BR_90F7:
    STA  ($79D5)                    ; ***mystery bypass
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_90FB:
    DEC  Y                          ;
    DEC  Y                          ;
    VEJ  (C2) \ AWRD($F19E) \ ABRF(BR_9105) ; DIVISION ($F084) \ $9105
    LDI  A,$00                      ;
    BCH  BR_90F7                    ; $90F7

BR_9105:
    INC  Y                          ; 
    VEJ  (E4)                       ; (E4) Output Error 1 and return to the editor
;% LB_REPKEY END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; GCLS - Clears graphics RAM?
; Called from: 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_GCLS START
GCLS:
    LDA  (Y)                        ;
    CPI  A,$0D                      ; A <> $0D
    BZR  BR_9110                    ;
    LDI  A,$00                      ; 
    BCH  BR_9116                    ; $9116

BR_9110:
    VEJ  (DE) \ ABRF(BR_914B)       ; $914B
    VEJ  (D0) \ ABYT($10) \ ABRF(BR_914B) ; $914B
    LDA  UL                         ;

BR_9116:
    SJP  (JMP_911A)                 ; $911A
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

JMP_911A:
    LDI  A,$55                      ; 
    STA  #($3000)                   ; ***IWS ME1???
    CPA  #($3000)                   ; ***
    BZR  BR_912E                    ; $912E
    LDI  UH,$07                     ; Next 4 lines don't seem to do anything
    LDI  UL,$D0                     ; Loop counter
    LDI  XH,HB(GRAPHRAM)            ; $68 - HB Graphics RAM
    LDI  XL,LB(GRAPHRAM)            ; $00 - LB Graphics RAM

BR_912E:
    LDI  A,$00                      ; 
    STA  #($3000)                   ; ***
    LDI  UH,$3E                     ; Why set U,X again after just set above?
    LDI  UL,$81                     ; 
    LDI  XH,$30                     ;
    LDI  XL,$00                     ; 

BR_913C:
    STA  #(X)                       ; 
    INC  X                          ;
    DEC  U                          ; 
    CPI  UH,$00                     ;
    BZR  BR_9149                    ; $9149
    CPI  UL,$00                     ; 
    BZR  BR_9149                    ; $9149
    RTN                             ; Done

BR_9149:
    BCH  BR_913C                    ; $913C

BR_914B:
    VEJ  (E0)                       ; (E0) Error according to UH
;% LB_GCLS END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; DEC - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_DEC START
DEC:
    JMP  JMP_92D6 ; $92D6
;% LB_END 
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; GVCURSOR - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_GVCURSOR START
GVCURSOR:
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

JMP_9150:
    LDA  ($79D6)                    ; *** unused section of PC-1500 used as flag for?
    CPI  A,$55                      ; 
    BZR  BR_9159                    ; $9159
    BCH  BR_9176                    ; $9176

BR_9159:
    LDI  A,$BE                      ; 
    STA  (OUTSTAT_REG)              ; 
    LDI  A,$E2                      ; 
    STA  (CONSOLE_REG)              ; $7851
    LDI  A,$67                      ; 
    STA  (CONSOLE2)                 ; $7852

BR_9168:
    LDI  A,$9A                      ;
    STA  (CE158_UNDEF1)             ; $7853
    LDI  A,$9A                      ;
    STA  (CE158_UNDEF2)             ; $7854
    SJP  (OUTSTAT_REG)              ; 
    RTN                             ; Done

BR_9176:
    LDI  A,$BE                      ; 
    STA  (OUTSTAT_REG)              ; 
    LDA  (ZONE_REG)                 ; $7856
    STA  (CONSOLE_REG)              ; $7851
    LDA  (SETDEV_REG)               ; $7857
    STA  (CONSOLE2)                 ; $7852
    BCH  BR_9168                    ; $9168


JMP_9189:
    LDI  XH,$77                     ; IWS Video RAM area
    LDI  XL,$7F                     ; 
    LDI  YH,$77                     ; IWS Video RAM area
    LDI  YL,$CF                     ; 
    LDI  UH,$07                     ; Loop counter?
    LDI  UL,$80                     ; 

BR_9195:
    LDA  #(X)                       ; Moves block of video RAM
    STA  #(Y)                       ; 
    DEC  X                          ; 
    DEC  Y                          ; 
    DEC  U                          ; 
    CPI  UH,$00                     ; 
    BZR  BR_91A5                    ; $91A5
    CPI  UL,$00                     ; 
    BZR  BR_91A5                    ; $91A5
    RTN                             ; 

BR_91A5:
    BCH  BR_9195                    ; $9195
;% LB_GVCURSOR END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; PRINT - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_PRINT START
PRINT:
    VEJ  (C2) \ ACHR($23) \ ABRF(BR_91B1) ; $91B1
    VEJ  (C2) \ ACHR($2D) \ ABRF(BR_91BB) ; $91BB
    VEJ  (C6)                       ; (C6) Correct program pointer
    JMP  BCMD_PRINT + $03           ; $E4EE 

BR_91B1:
    VEJ  (C6)                       ; (C6) Correct program pointer
    VEJ  (D8)                       ; (D8) Checks calculator mode
    BZR  BR_91B8                    ; $91B8
    JMP  BCMD_PRINT                 ; $E4EB

BR_91B8:
    JMP  JMP_8A8B                   ; $8A8B

BR_91BB:
    VEJ  (C6)                       ; (C6) Correct program pointer
    VEJ  (DE) \ ABRF(BR_91D2)       ; $91D2
    VEJ  (D0) \ ABYT($80) \ ABRF(BR_91D2) ; $91D2
    VEJ  (F4) \ AWRD(BR_8803)       ; $8803
    CPI  UH,$44                     ; 
    BZR  BR_91CF                    ; $91CF
    CPI  UL,$49                     ; 
    BZR  BR_91CF                    ; $91CF
    JMP  $88F7                      ; ***bug? seems to jump to middle of line

BR_91CF:
    LDI  UH,$1B                     ; 
    VEJ  (E0)                       ; (E0) Error according to UH

BR_91D2:
    VEJ  (E0)                       ; (E0) Error according to UH
;% LB_PRINT END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; MODE - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_MODE START
MODE: ; $91D3
    ANI  #(VIDEORAM + $07E0),$00    ; $77E0

BR_91D8:
     VEJ  (C2) \ ACHR($4D) \ ABRF(BR_9219) ; $9219
     SJP  (BR_91EF)                 ; $91EF
     LDA  (Y)                       ; 
     CPI  A,$2C                     ; 
     BZR  BR_91E6                   ; $91E6
     INC  Y                         ; 
     BCH  BR_91D8                   ; $91D8

BR_91E6:
    LDA  #(VIDEORAM + $07E0)        ; 
    STA  #($D800)                   ; ***IWS??
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_91EF:
    VEJ  (DE) \ ABRF(BR_9218)       ; $9218
    VEJ  (D0) \ ABYT($10) \ ABRF(BR_9218) ; $9218
    CPI  UH,$01                     ; 
    BCR  BR_91FB                    ; $91FB
    LDI  UH,$13                     ; 
    VEJ  (E0)                       ; (E0) Error according to UH

BR_91FB:
    CPI  UL,$09                     ; 
    BZR  BR_9202                    ; $9202
    LDI  UH,$13                     ; 
    VEJ  (E0)                       ; (E0) Error according to UH

BR_9202: 
    CPI  UL,$00                     ; 
    BZR  BR_9208                    ; $9208
    LDI  UL,$09                     ; 

BR_9208:
    DEC  UL                         ; 
    LDI  A,$00                      ; 
    SEC                             ; 

BR_920C:
    ROL                             ; 
    LOP  UL,BR_920C                 ; $920C
    ORA  #(VIDEORAM + $07E0)        ; 
    STA  #(VIDEORAM + $07E0)        ; 
    RTN

BR_9218:
    VEJ  (E0)                       ; (E0) Error according to UH

BR_9219:
    DEC  Y
    LDA  (Y)
    VMJ  ($04) \ ABRF(BR_921F)      ; 921F
    VEJ  (E2)                       ; (E2) - BASIC interpreter: Y-Reg points to command or line end

BR_921F:
    CPI  A,$22                      ; 
    BZR  BR_9225                    ; $9225
    BCH  BR_91D8                    ; $91D8

BR_9225:
    VEJ  (C2) \ ACHR($53) \ ABRF(BR_9232) ; $9232
    VEJ  (DE) \ ABRF($9233)         ; 
    VEJ  (D0) \ ABYT($08) \ ABRF(BR_9233) ; $9233
    LDA  UL                         ; 
    ATP                             ; 
    BCH  BR_91D8                    ; $91D8

BR_9232:
    VEJ  (E4)                       ; (E4) Output Error 1 and return to the editor

BR_9233:
    VEJ  (E0)                       ; (E0) Error according to UH
;% LB_MODE END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; SAVE - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_SAVE START
SAVE:
    LDA  (Y)                        ;
    INC  Y                          ;
    VMJ  ($34) \ ABYT($04) \            ;
          ABYT($43) \ ABRF(BR_9277) \   ;
          ABYT($46) \ ABRF(BR_9287) \   ;
          ABYT($51) \ ABRF(BR_9297) \   ;
          ABYT($44) \ ABRF(BR_929A) \   ;
          ABYT($52) \ ABRF(BR_92B2)     ;
    VEJ  (E4)                           ; (E4) Output Error 1 and return to the editor
;% LB_SAVE END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; LOAD - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_LOAD START
LOAD:
     LDA  (Y)                       ; 
     INC  Y                         ; 
     VMJ  ($34) \ ABYT($04) \           ; 
           ABYT($43) \ ABRF(BR_9254) \  ;  
           ABYT($46) \ ABRF(BR_9264) \  ;  
           ABYT($51) \ ABRF(BR_9274) \  ; 
           ABYT($44) \ ABRF(BR_92A6) \  ; 
           ABYT($52) \ ABRF(BR_92BE)    ; 
     VEJ  (E4)                      ; (E4) Output Error 1 and return to the editor

BR_9254:
    VEJ  (F4) \ AWRD($B802)         ; ***CMT_PNAME $B800 CMT Periph name
    CPI  UH,$43                     ; 
    BZR  BR_9262                    ; $9262
    CPI  UL,$4D                     ; 
    BZR  BR_9262                    ; $9262
    JMP  CLOAD_150                  ; $B8F9 

BR_9262:
    BCH  JMP_92D6                   ; $92D6

BR_9264:
    VEJ  (F4) \ AWRD($A805)         ; *** PRINT_150 $A781
    CPI  UH,$4C                     ;
    BZR  BR_9272                    ; $9272
    CPI  UL,$32                     ;
    BZR  BR_9272                    ; $9272
    JMP  GRAPH + $E8                ; $ADBB (CE150)

BR_9272:
    BCH  JMP_92D6                   ; $92D6

BR_9274:
    JMP  JMP_92D6                   ; $92D6

BR_9277:
    VEJ  (F4) \ AWRD($B802)         ; ***CMT Perips name $B800
    CPI  UH,$43                     ; 
    BZR  BR_9285                    ; $9285
    CPI  UL,$4D                     ; 
    BZR  BR_9285                    ; $9285
    JMP  CSAVE_150                  ; $B8A6

BR_9285:
    BCH  JMP_92D6                   ; $92D6

BR_9287:
    VEJ  (F4) \ AWRD($A805)         ; *** PRINT_150 $A781
    CPI  UH,$4C                     ; 
    BZR  BR_9295                    ; $9295
    CPI  UL,$32                     ;
    BZR  BR_9295                    ; $9295
    JMP  PENUPDOWN + $AC            ; $AB8F CE150 

BR_9295:
    BCH  JMP_92D6                   ; $92D6

BR_9297:
    JMP  JMP_92D6                   ; $92D6

BR_929A:
    VEJ  (F4) \ AWRD($A803)         ; *** PRINT_150 $A781
    CPI  UH,$44                     ;
    BZR  BR_92A4                    ; $92A4
    JMP  MOTDRV + $14               ; $A8F4 CE150 

BR_92A4:
    BCH  JMP_92D6                   ; $92D6

BR_92A6:
    VEJ  (F4) \ AWRD($A803)         ; ***PRINT_150
    CPI  UH,$44                     ; 
    BZR  BR_92B0                    ; $92B0
    JMP PRINT_150 + $170            ; $A8F1 CE150

BR_92B0:
    BCH  JMP_92D6                   ; $92D6

BR_92B2:
    VEJ  (F4) \ AWRD($A803)         ; ***PRINT_150
    CPI  UH,$44                     ;
    BZR  BR_92BC                    ; $92BC
    JMP  MOTDRV + $11               ; $A8EE CE150

BR_92BC:
    BCH  JMP_92D6                   ; $92D6

BR_92BE:
    VEJ  (F4) \ AWRD($A803)         ; ***
    CPI  UH,$44                     ; 
    BZR  BR_92C8                    ; $92C8
    JMP  MOTDRV + $0E               ; $A8EB CE150

BR_92C8:
    BCH  JMP_92D6                   ; $92D6
    VEJ  (F4) \ AWRD($A803)         ; ***
    CPI  UH,$44                     ; 
    BZR  BR_92D4                    ; $92D4
    JMP  MOTDRV + $0B               ; $A8E8 CE150

BR_92D4:
    ;BCH  JMP_92D6 ; $92D6
    .BYTE $9E,$00                   ; asessembler calcualtes  wrong direction on 0 lenght branch

JMP_92D6:
    LDI  UH,$1B                     ; 
    VEJ  (E0)                       ; (E0) Error according to UH
;% LB_LOAD END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; VERIFYQ - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_VERIFYQ START
VERIFYQ:
    JMP  JMP_92D6                   ; $92D6
;% LB_VERIFYQ END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; CHAIN - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_CHAIN START
CHAIN:
    LIN  Y                          ;
    VMJ  ($34) \ ABYT($01) \            ;
          ABYT($43) \ ABRF(BR_92F5) \   ;
          ABYT($51) \ ABRF(BR_9305)     ;
    VEJ  (F4) \ AWRD($B802)         ; 
    CPI  UH,$43                     ; 
    BZR  BR_92F3                    ; $92F3
    CPI  UL,$4D                     ; 
    BZR  BR_92F3                    ; $92F3
    DEC  Y                          ; 
    JMP  CHAIN_150                  ; $BB6A

BR_92F3:
    BCH  JMP_92D6                   ; $92D6

BR_92F5:
    VEJ  (F4) \ AWRD($B802)         ; ***CMT Periph name $B800
    CPI  UH,$43                     ;
    BZR  BR_9303                    ; $9303
    CPI  UL,$4D                     ;
    BZR  BR_9303                    ; $9303
    JMP  CHAIN_150                  ; $BB6A

BR_9303:
    BCH  JMP_92D6                   ; $92D6

BR_9305:
    JMP  JMP_92D6                   ; $92D6
;% LB_CHAIN END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; KEY - 
; Called from 
; Arguments: 
; Outputs: 
; RegMod: 
;------------------------------------------------------------------------------------------------------------
;% LB_KEY START
KEY:
    VEJ  (C2) \ AWRD($F182) \ ABRF(BR_9323) ; $9323
    VEJ  (C2) \ AWRD($F19C) \ ABRF(BR_9317) ; $9317
    LDI  A,$55
    STA  #(VIDEORAM + $07E2) ; $77E2
    VEJ  (E2)

BR_9317:
    VEJ  (C6)
    VEJ  (C2) \ AWRD($F19E) \ ABRF(BR_9322) ; $9322
    ANI  #(VIDEORAM + $07E2),$00
    VEJ  (E2)

BR_9322:
    VEJ  (E4)

BR_9323:
    VEJ  (C6)
    VEJ  (C2) \ AWRD($F19C) \ ABRF(BR_9339) ; $9339
    VEJ  (F4) \ AWRD($A803) ; ***PRINT_150
    CPI  UH,$44
    BZR  BR_9336 ; $9336
    CPI  UL,$49
    BZR  BR_9336 ; $9336
    JMP  $A8FD ; ***MOTDRV

BR_9336:
    LDI  UH,$1B
    VEJ  (E0)

BR_9339:
    VEJ  (C6)
    VEJ  (C2) \ AWRD($F19E) \ ABRF(BR_934F) ; $934F
    VEJ  (F4) \ AWRD($A803) ; ***
    CPI  UH,$44
    BZR  BR_934C ; $934C
    CPI  UL,$49
    BZR  BR_934C ; $934C
    JMP  $A8FA ; ***MOTDRV

BR_934C: 
    LDI  UH,$1B
    VEJ  (E0)

BR_934F:
    VEJ  (E4)
    PSH  A
    LDA  #(VIDEORAM + $07F0) ; $77F0
    CPI  A,$55
    BZR  BR_9368 ; $9368
    LDA  #(VIDEORAM + $07F1)
    STA  XH
    LDA  #(VIDEORAM + $07F2)
    STA  XL
    POP  A
    STX  P

BR_9368:
    POP  A
    JMP  TRCROUTINE ; $C4AF
;% LB_KEY END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $936D-$9394 - IWS Spalsh screen text
;------------------------------------------------------------------------------------------------------------
;% LB_IWS_SPLASH START
IWS_SPLASH:
    .TEXT  "TEL. 071"
    .TEXT  "61/79021"
    .TEXT  " anrufen"
    .TEXT  " !HO V.1"
    .TEXT  ".0 859  "
;% LB_IWS_SPLASH END
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $9395 - $93FF Unknown table
;------------------------------------------------------------------------------------------------------------
;% LB_IWS_xxxx START
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00
;% LB_IWS_xxxx END
;------------------------------------------------------------------------------------------------------------


;------------------------------------------------------------------------------------------------------------
; last character of name has bit 7 set. Use macro EOW to accomplish this.
; $9400 - $9F80
;------------------------------------------------------------------------------------------------------------
;% LB_IWS_xxxx START
;         NAME              BIT 7 SET      ADDRESS
    .TEXT "VLIS"         \  EOW('T')  \  .WORD $8000
    .TEXT "OPNCR"        \  EOW('T')  \  .WORD $0040
    .TEXT "TESTEN"       \  EOW('D')  \  .WORD $0004
    .TEXT "CHANGETOKE"   \  EOW('N')  \  .WORD $001C
    .TEXT "SEARCHENTE"   \  EOW('R')  \  .WORD $0020
    .TEXT "MAKEPARAME"   \  EOW('T')  \  .WORD $002E
    .TEXT "MEHRFACHVE"   \  EOW('R')  \  .WORD $0034
    .TEXT "LDXRESERVE"   \  EOW('S')  \  .WORD $0038
    .TEXT "RSHIFT7BY"    \  EOW('T')  \  .WORD $0074
    .TEXT "MOVESTROUT"   \  EOW('P')  \  .WORD $0094
    .TEXT "DISPLAYTEX"   \  EOW('T')  \  .WORD $0092
    .TEXT "MAKEUSIN"     \  EOW('G')  \  .WORD $0096
    .TEXT "WARTEULAN"    \  EOW('G')  \  .WORD $00AC
    .TEXT "LDUZEICHE"    \  EOW('N')  \  .WORD $00C0
    .TEXT "TESTTOKZE"    \  EOW('I')  \  .WORD $00C2
    .TEXT "TESTUTOKZ"    \  EOW('E')  \  .WORD $00C4
    .TEXT "DECYTOKZE"    \  EOW('I')  \  .WORD $00C6
    .TEXT "NOENDTES"     \  EOW('T')  \  .WORD $00C8
    .TEXT "LADE78NN"     \  EOW('X')  \  .WORD $00CA
    .TEXT "LADEXAUS7"    \  EOW('8')  \  .WORD $00CC
    .TEXT "ARITMETI"     \  EOW('K')  \  .WORD $00D0
    .TEXT "TESTSTRNU"    \  EOW('M')  \  .WORD $00D2
    .TEXT "TESTBASICRU"  \  EOW('N')  \  .WORD $00D8
    .TEXT "STRINGINF"    \  EOW('O')  \  .WORD $00DC
    .TEXT "AUSDRUC"      \  EOW('K')  \  .WORD $00DE
    .TEXT "ERRO"         \  EOW('R')  \  .WORD $00E0
    .TEXT "INTERPRETE"   \  EOW('R')  \  .WORD $00E2
    .TEXT "ERROR"        \  EOW('1')  \  .WORD $00E4
    .TEXT "CLEARLC"      \  EOW('D')  \  .WORD $00F2
    .TEXT "LADEUAUSNNN"  \  EOW('N')  \  .WORD $00F4
    .TEXT "TESTKE"       \  EOW('Y')  \  .WORD $E42C
    .TEXT "STORESTRIN"   \  EOW('G')  \  .WORD $DFB4
    .TEXT "STOREINDST"   \  EOW('R')  \  .WORD $DFC5
    .TEXT "FARBRA"       \  EOW('M')  \  .WORD $6000
    .TEXT "GRAPHIKRA"    \  EOW('M')  \  .WORD $3000
    .TEXT "VIDEORA"      \  EOW('M')  \  .WORD $7000
    .TEXT "VIDEOPROZE"   \  EOW('S')  \  .WORD $7800
    .TEXT "BASICEND"     \  EOW('H')  \  .WORD $7867
    .TEXT "BASICEND"     \  EOW('L')  \  .WORD $7868
    .TEXT "BASICANF"     \  EOW('H')  \  .WORD $7865
    .TEXT "BASICANF"     \  EOW('L')  \  .WORD $7866
    .TEXT "STATUS"       \  EOW('H')  \  .WORD $764E
    .TEXT "STATUS"       \  EOW('L')  \  .WORD $764F
    .TEXT "INPUTBUFFE"   \  EOW('R')  \  .WORD $7BB0
    .TEXT "TASTUMLEI"    \  EOW('T')  \  .WORD $79D4
    .TEXT "TASTUMPOI"    \  EOW('H')  \  .WORD $785B
    .TEXT "TASTUMPOI"    \  EOW('L')  \  .WORD $785C
    .TEXT "WAITY"        \  EOW('N')  \  .WORD $7871
    .TEXT "WAITCOUNT"    \  EOW('H')  \  .WORD $7872
    .TEXT "WAITCOUNT"    \  EOW('L')  \  .WORD $7873
    .TEXT "BLINKFLA"     \  EOW('G')  \  .WORD $787C
    .TEXT "OUTPBUFFP"    \  EOW('O')  \  .WORD $788F
    .TEXT "STRIBUFFP"    \  EOW('O')  \  .WORD $7894
    .TEXT "USINGFORMA"   \  EOW('T')  \  .WORD $7895
    .TEXT "USINGLAEN"    \  EOW('G')  \  .WORD $7896
    .TEXT "USINGSTRIN"   \  EOW('G')  \  .WORD $7897
    .TEXT "SEARCHADR"    \  EOW('H')  \  .WORD $78A6
    .TEXT "SEARCHADR"    \  EOW('L')  \  .WORD $78A7
    .TEXT "MODULS"       \  EOW('W')  \  .WORD $D800
    .TEXT "MODU"         \  EOW('L')  \  .WORD $77E0
    .TEXT "KEYBEE"       \  EOW('P')  \  .WORD $77E2
    .TEXT "LREC"         \  EOW('L')  \  .WORD $77D1
    .TEXT "UP"           \  EOW('L')  \  .WORD $77D2
    .TEXT "IN"           \  EOW('P')  \  .WORD $77D3
    .TEXT "CUR"          \  EOW('H')  \  .WORD $77D4
    .TEXT "CUR"          \  EOW('L')  \  .WORD $77D5
    .TEXT "CURP"         \  EOW('1')  \  .WORD $77D6
    .TEXT "MOMENTVCU"    \  EOW('R')  \  .WORD $774E
    .TEXT "MOMENTHCU"    \  EOW('R')  \  .WORD $774F
    .TEXT "KOM"          \  EOW('P')  \  .WORD $77D7
    .TEXT "INP"          \  EOW('P')  \  .WORD $77D8
    .TEXT "VARIABL"      \  EOW('E')  \  .WORD $77D9
    .TEXT "CURSORAR"     \  EOW('T')  \  .WORD $77DA
    .TEXT "CURSORART"    \  EOW('L')  \  .WORD $77DB
    .TEXT "FARB"         \  EOW('E')  \  .WORD $77DC
    .TEXT "HINTERG"      \  EOW('R')  \  .WORD $77DD
    .TEXT "ZEICHFARB"    \  EOW('E')  \  .WORD $77DE
    .TEXT "VAR"          \  EOW('2')  \  .WORD $77DF
    .TEXT "USRT"         \  EOW('R')  \  .WORD $77F0
    .TEXT "USRTR"        \  EOW('1')  \  .WORD $77F1
    .TEXT "USRTR"        \  EOW('2')  \  .WORD $77F2
    .TEXT "PRINTFLA"     \  EOW('G')  \  .WORD $77F3
    .TEXT "INFOR"        \  EOW('M')  \  .WORD $77F4
    .TEXT "INPFLA"       \  EOW('G')  \  .WORD $77E1
    .TEXT "TOKEN0"       \  EOW('1')  \  .WORD $F0DD
    .TEXT "TOKEN0"       \  EOW('2')  \  .WORD $F0DE
    .TEXT "TOKEN0"       \  EOW('3')  \  .WORD $F0DF
    .TEXT "TOKEN0"       \  EOW('4')  \  .WORD $F088
    .TEXT "TOKEN0"       \  EOW('5')  \  .WORD $F0EB
    .TEXT "TOKEN0"       \  EOW('6')  \  .WORD $F0B1
    .TEXT "TOKEN0"       \  EOW('7')  \  .WORD $F084
    .TEXT "TOKEN0"       \  EOW('8')  \  .WORD $F0E0
    .TEXT "TOKEN0"       \  EOW('9')  \  .WORD $F070
    .TEXT "TOKEN1"       \  EOW('0')  \  .WORD $F0C7
    .TEXT "TOKEN1"       \  EOW('1')  \  .WORD $F053
    .TEXT "TOKEN1"       \  EOW('2')  \  .WORD $F052
    .TEXT "TOKEN1"       \  EOW('3')  \  .WORD $F0E1
    .TEXT "TOKEN1"       \  EOW('4')  \  .WORD $F0E8
    .TEXT "TOKEN1"       \  EOW('5')  \  .WORD $F0E9
    .TEXT "TOKEN1"       \  EOW('6')  \  .WORD $F054
    .TEXT "TOKEN1"       \  EOW('7')  \  .WORD $F055
    .TEXT "TOKEN1"       \  EOW('8')  \  .WORD $F071
    .TEXT "TOKEN1"       \  EOW('9')  \  .WORD $F091
    .TEXT "TOKEN2"       \  EOW('0')  \  .WORD $F0E2
    .TEXT "TOKEN2"       \  EOW('1')  \  .WORD $F0B2
    .TEXT "TOKEN2"       \  EOW('2')  \  .WORD $F090
    .TEXT "TOKEN2"       \  EOW('3')  \  .WORD $F080
    .TEXT "TOKEN2"       \  EOW('4')  \  .WORD $F0E4
    .TEXT "TOKEN2"       \  EOW('5')  \  .WORD $F097
    .TEXT "TOKEN2"       \  EOW('6')  \  .WORD $F0C3
    .TEXT "TOKEN2"       \  EOW('7')  \  .WORD $F0C5
    .TEXT "TOKEN2"       \  EOW('8')  \  .WORD $F081
    .TEXT "TOKEN2"       \  EOW('9')  \  .WORD $F0E7
    .TEXT "TOKEN3"       \  EOW('0')  \  .WORD $F0EA
    .TEXT "TOKEN3"       \  EOW('1')  \  .WORD $F056
    .TEXT "TOKEN3"       \  EOW('2')  \  .WORD $F050
    .TEXT "TOKEN3"       \  EOW('3')  \  .WORD $F083
    .TEXT "T"            \  EOW('B')  \  .WORD $8055
    .TEXT "T"            \  EOW('C')  \  .WORD $8060
    .TEXT "T"            \  EOW('D')  \  .WORD $8094
    .TEXT "T"            \  EOW('E')  \  .WORD $80A4
    .TEXT "T"            \  EOW('G')  \  .WORD $80BD
    .TEXT "T"            \  EOW('H')  \  .WORD $80DF
    .TEXT "T"            \  EOW('I')  \  .WORD $8101
    .TEXT "T"            \  EOW('K')  \  .WORD $810B
    .TEXT "T"            \  EOW('L')  \  .WORD $8113
    .TEXT "T"            \  EOW('M')  \  .WORD $8125
    .TEXT "T"            \  EOW('P')  \  .WORD $813A
    .TEXT "T"            \  EOW('R')  \  .WORD $8144
    .TEXT "T"            \  EOW('S')  \  .WORD $815A
    .TEXT "T"            \  EOW('T')  \  .WORD $816D
    .TEXT "T"            \  EOW('V')  \  .WORD $8177
    .TEXT "ANFAN"        \  EOW('G')  \  .WORD $819E
    .TEXT "ANF"          \  EOW('1')  \  .WORD $81F4
    .TEXT "KE"           \  EOW('Y')  \  .WORD $822F
    .TEXT "MODE"         \  EOW('T')  \  .WORD $836B
    .TEXT "ALTE"         \  EOW('R')  \  .WORD $8381
    .TEXT "BASI"         \  EOW('C')  \  .WORD $83BB
    .TEXT "NEXT"         \  EOW('L')  \  .WORD $83C6
    .TEXT "NEXT"         \  EOW('0')  \  .WORD $83F0
    .TEXT "NEXT"         \  EOW('E')  \  .WORD $8417
    .TEXT "ENTE"         \  EOW('R')  \  .WORD $8419
    .TEXT "NEXT"         \  EOW('C')  \  .WORD $841F
    .TEXT "NEXT"         \  EOW('D')  \  .WORD $842D
    .TEXT "NEXT"         \  EOW('2')  \  .WORD $843B
    .TEXT "MODU"         \  EOW('S')  \  .WORD $8456
    .TEXT "MOD"          \  EOW('1')  \  .WORD $8466
    .TEXT "RPMOD"        \  EOW('E')  \  .WORD $84BB
    .TEXT "MOD"          \  EOW('C')  \  .WORD $84C5
    .TEXT "MODEN"        \  EOW('D')  \  .WORD $84D4
    .TEXT "SCROL"        \  EOW('L')  \  .WORD $84D7
    .TEXT "SCR"          \  EOW('1')  \  .WORD $84E6
    .TEXT "SCR"          \  EOW('2')  \  .WORD $84FD
    .TEXT "SCROL"        \  EOW('1')  \  .WORD $8501
    .TEXT "SCRO"         \  EOW('2')  \  .WORD $8511
    .TEXT "SCREN"        \  EOW('D')  \  .WORD $8524
    .TEXT "DECOD"        \  EOW('E')  \  .WORD $852C
    .TEXT "DECOD"        \  EOW('1')  \  .WORD $8535
    .TEXT "DECOD1"       \  EOW('A')  \  .WORD $8556
    .TEXT "DECOD"        \  EOW('2')  \  .WORD $8576
    .TEXT "DECOD"        \  EOW('3')  \  .WORD $857A
    .TEXT "DCD"          \  EOW('3')  \  .WORD $8595
    .TEXT "TRUN"         \  EOW('K')  \  .WORD $85B6
    .TEXT "NOCOD"        \  EOW('E')  \  .WORD $85BB
    .TEXT "NC"           \  EOW('D')  \  .WORD $85F0
    .TEXT "TREN"         \  EOW('N')  \  .WORD $8604
    .TEXT "TRENRE"       \  EOW('T')  \  .WORD $860D
    .TEXT "TREN"         \  EOW('E')  \  .WORD $8643
    .TEXT "TREN"         \  EOW('1')  \  .WORD $8646
    .TEXT "TRUN"         \  EOW('C')  \  .WORD $8656
    .TEXT "CURSO"        \  EOW('R')  \  .WORD $8663
    .TEXT "TO"           \  EOW('F')  \  .WORD $86E4
    .TEXT "EO"           \  EOW('F')  \  .WORD $86FA
    .TEXT "OB"           \  EOW('F')  \  .WORD $8721
    .TEXT "OUBF"         \  EOW('1')  \  .WORD $8752
    .TEXT "OUBF"         \  EOW('0')  \  .WORD $878B
    .TEXT "OUBF"         \  EOW('2')  \  .WORD $8799
    .TEXT "OUBF"         \  EOW('3')  \  .WORD $879D
    .TEXT "OUBF"         \  EOW('4')  \  .WORD $87A5
    .TEXT "OBF"          \  EOW('5')  \  .WORD $87BB
    .TEXT "STE"          \  EOW('P')  \  .WORD $87CC
    .TEXT "LENGT"        \  EOW('H')  \  .WORD $87D4
    .TEXT "OVERF"        \  EOW('L')  \  .WORD $87E7
    .TEXT "OVFL"         \  EOW('0')  \  .WORD $87FD
    .TEXT "OVF"          \  EOW('0')  \  .WORD $882D
    .TEXT "OVF"          \  EOW('1')  \  .WORD $8839
    .TEXT "OVF"          \  EOW('2')  \  .WORD $883D
    .TEXT "OUTSC"        \  EOW('R')  \  .WORD $8854
    .TEXT "OUTSC"        \  EOW('1')  \  .WORD $885D
    .TEXT "OUTSC"        \  EOW('2')  \  .WORD $8865
    .TEXT "OUTSC"        \  EOW('E')  \  .WORD $88AE
    .TEXT "DCU"          \  EOW('V')  \  .WORD $88B5
    .TEXT "OBTUP"        \  EOW('L')  \  .WORD $88BF
    .TEXT "OBTUP"        \  EOW('0')  \  .WORD $88CC
    .TEXT "OBTUP"        \  EOW('1')  \  .WORD $88DA
    .TEXT "OBTUP"        \  EOW('E')  \  .WORD $88E5
    .TEXT "UO"           \  EOW('V')  \  .WORD $88EB
    .TEXT "RPLAN"        \  EOW('E')  \  .WORD $88FD
    .TEXT "RESMO"        \  EOW('D')  \  .WORD $8929
    .TEXT "RSM"          \  EOW('0')  \  .WORD $8940
    .TEXT "RSM"          \  EOW('1')  \  .WORD $894E
    .TEXT "CUROF"        \  EOW('F')  \  .WORD $8963
    .TEXT "VCL"          \  EOW('S')  \  .WORD $8974
    .TEXT "HE"           \  EOW('X')  \  .WORD $8981
    .TEXT "VH"           \  EOW('1')  \  .WORD $898F
    .TEXT "VHAS"         \  EOW('C')  \  .WORD $89A1
    .TEXT "VHAS"         \  EOW('1')  \  .WORD $89A9
    .TEXT "VHAS"         \  EOW('2')  \  .WORD $89B3
    .TEXT "CONSOL"       \  EOW('E')  \  .WORD $89B5
    .TEXT "VSIZ"         \  EOW('1')  \  .WORD $8A27
    .TEXT "DI"           \  EOW('P')  \  .WORD $8A38
    .TEXT "VSIZ"         \  EOW('F')  \  .WORD $8A46
    .TEXT "VSIZF"        \  EOW('A')  \  .WORD $8A48
    .TEXT "VCUR"         \  EOW('S')  \  .WORD $8A49
    .TEXT "CURS1"        \  EOW('W')  \  .WORD $8A75
    .TEXT "CURS2"        \  EOW('W')  \  .WORD $8A7E
    .TEXT "ERRCU"        \  EOW('R')  \  .WORD $8A88
    .TEXT "ERRCURSO"     \  EOW('R')  \  .WORD $8A8A
    .TEXT "VPRIN"        \  EOW('T')  \  .WORD $8A8B
    .TEXT "CLO"          \  EOW('B')  \  .WORD $8AA3
    .TEXT "VPA"          \  EOW('N')  \  .WORD $8AA6
    .TEXT "VPAN"         \  EOW('0')  \  .WORD $8AB6
    .TEXT "VPR"          \  EOW('0')  \  .WORD $8ABB
    .TEXT "PRF"          \  EOW('0')  \  .WORD $8AC5
    .TEXT "VPR"          \  EOW('1')  \  .WORD $8AC8
    .TEXT "USIN"         \  EOW('G')  \  .WORD $8AF7
    .TEXT "US"           \  EOW('1')  \  .WORD $8B02
    .TEXT "US"           \  EOW('2')  \  .WORD $8B0C
    .TEXT "PRAS"         \  EOW('C')  \  .WORD $8B27
    .TEXT "PRSC"         \  EOW('0')  \  .WORD $8B31
    .TEXT "PRSC"         \  EOW('1')  \  .WORD $8B52
    .TEXT "PRSC"         \  EOW('2')  \  .WORD $8B62
    .TEXT "PRSC"         \  EOW('3')  \  .WORD $8B69
    .TEXT "VPR"          \  EOW('2')  \  .WORD $8B91
    .TEXT "OUTBU"        \  EOW('F')  \  .WORD $8B9E
    .TEXT "OBF"          \  EOW('0')  \  .WORD $8BC0
    .TEXT "OBF"          \  EOW('1')  \  .WORD $8BFC
    .TEXT "PRTEN"        \  EOW('D')  \  .WORD $8C17
    .TEXT "PRFEH"        \  EOW('L')  \  .WORD $8C38
    .TEXT "WAI"          \  EOW('T')  \  .WORD $8C3F
    .TEXT "NOV"          \  EOW('C')  \  .WORD $8C4A
    .TEXT "KOM"          \  EOW('L')  \  .WORD $8C57
    .TEXT "KOML"         \  EOW('1')  \  .WORD $8C72
    .TEXT "INPU"         \  EOW('T')  \  .WORD $8C89
    .TEXT "XINP"         \  EOW('1')  \  .WORD $8C8F
    .TEXT "XINP"         \  EOW('3')  \  .WORD $8CC7
    .TEXT "XINP"         \  EOW('6')  \  .WORD $8CCA
    .TEXT "XINP"         \  EOW('4')  \  .WORD $8CD1
    .TEXT "XINP"         \  EOW('2')  \  .WORD $8CFB
    .TEXT "XINP"         \  EOW('5')  \  .WORD $8D15
    .TEXT "EDITO"        \  EOW('R')  \  .WORD $8D18
    .TEXT "CLEARSC"      \  EOW('R')  \  .WORD $8D41
    .TEXT "CL"           \  EOW('1')  \  .WORD $8D4A
    .TEXT "WRITE"        \  EOW('1')  \  .WORD $8D5E
    .TEXT "WRITE"        \  EOW('2')  \  .WORD $8D64
    .TEXT "OBTAI"        \  EOW('N')  \  .WORD $8D6B
    .TEXT "OBT"          \  EOW('1')  \  .WORD $8D95
    .TEXT "OBT"          \  EOW('2')  \  .WORD $8D99
    .TEXT "OBTEN"        \  EOW('D')  \  .WORD $8D9C
    .TEXT "OBT"          \  EOW('F')  \  .WORD $8DA3
    .TEXT "INITIA"       \  EOW('L')  \  .WORD $8DA8
    .TEXT "INITIA"       \  EOW('1')  \  .WORD $8DAC
    .TEXT "FIRS"         \  EOW('T')  \  .WORD $8DC1
    .TEXT "WARTE"        \  EOW('V')  \  .WORD $8DD0
    .TEXT "AN"           \  EOW('Z')  \  .WORD $8DDE
    .TEXT "TA"           \  EOW('S')  \  .WORD $8DEA
    .TEXT "FIRST"        \  EOW('1')  \  .WORD $8E03
    .TEXT "STRTA"        \  EOW('D')  \  .WORD $8E5F
    .TEXT "CLS"          \  EOW('0')  \  .WORD $8E64
    .TEXT "CLS"          \  EOW('1')  \  .WORD $8E6D
    .TEXT "CLS"          \  EOW('A')  \  .WORD $8E78
    .TEXT "CLSA"         \  EOW('0')  \  .WORD $8E7C
    .TEXT "STO"          \  EOW('R')  \  .WORD $8E86
    .TEXT "DAT"          \  EOW('1')  \  .WORD $8E8F
    .TEXT "DAT"          \  EOW('2')  \  .WORD $8EA1
    .TEXT "MOD"          \  EOW('T')  \  .WORD $8EB3
    .TEXT "TXT"          \  EOW('5')  \  .WORD $8EC7
    .TEXT "MONITO"       \  EOW('R')  \  .WORD $8EE1
    .TEXT "VCURSO"       \  EOW('R')  \  .WORD $8EE4
    .TEXT "VPCURSO"      \  EOW('R')  \  .WORD $8EEB
    .TEXT "HCURSO"       \  EOW('R')  \  .WORD $8EFD
    .TEXT "HPCURSO"      \  EOW('R')  \  .WORD $8F04
    .TEXT "LIS"          \  EOW('T')  \  .WORD $8F16
    .TEXT "VLISTAL"      \  EOW('L')  \  .WORD $8F43
    .TEXT "LISTAL"       \  EOW('L')  \  .WORD $8F46
    .TEXT "PLISTAL"      \  EOW('L')  \  .WORD $8F54
    .TEXT "LISTCR"       \  EOW('T')  \  .WORD $8F56
    .TEXT "LISTSCROL"    \  EOW('L')  \  .WORD $8F76
    .TEXT "LISTLABE"     \  EOW('L')  \  .WORD $8F7C
    .TEXT "HOLD"         \  EOW('1')  \  .WORD $8F95
    .TEXT "HOLD"         \  EOW('2')  \  .WORD $8F97
    .TEXT "WART"         \  EOW('E')  \  .WORD $8FA7
    .TEXT "LISTEDI"      \  EOW('T')  \  .WORD $9010
    .TEXT "BACKG"        \  EOW('R')  \  .WORD $9023
    .TEXT "BACKGRS"      \  EOW('T')  \  .WORD $9065
    .TEXT "BACKGRB"      \  EOW('E')  \  .WORD $906A
    .TEXT "BACKGRLADE"   \  EOW('N')  \  .WORD $9072
    .TEXT "ERRBACKG"     \  EOW('R')  \  .WORD $9081
    .TEXT "ER"           \  EOW('N')  \  .WORD $9082
    .TEXT "ER"           \  EOW('L')  \  .WORD $9088
    .TEXT "SCHUT"        \  EOW('Z')  \  .WORD $908E
    .TEXT "SLEE"         \  EOW('P')  \  .WORD $90AA
    .TEXT "REPZE"        \  EOW('I')  \  .WORD $90DE
    .TEXT "REPKE"        \  EOW('Y')  \  .WORD $90F1
    .TEXT "LDRE"         \  EOW('P')  \  .WORD $90F7
    .TEXT "REPOF"        \  EOW('F')  \  .WORD $90FB
    .TEXT "ERRRE"        \  EOW('P')  \  .WORD $9105
    .TEXT "GCL"          \  EOW('S')  \  .WORD $9107
    .TEXT "CLEARG"       \  EOW('R')  \  .WORD $9116
    .TEXT "CLRGRAP"      \  EOW('H')  \  .WORD $911A
    .TEXT "CLRGS"        \  EOW('T')  \  .WORD $913C
    .TEXT "ERRGCL"       \  EOW('S')  \  .WORD $914B
    .TEXT "DE"           \  EOW('Z')  \  .WORD $914C
    .TEXT "TES"          \  EOW('T')  \  .WORD $914F
    .TEXT "COLO"         \  EOW('R')  \  .WORD $914F
    .TEXT "EDI"          \  EOW('T')  \  .WORD $914F
    .TEXT "GCURSO"       \  EOW('R')  \  .WORD $914F
    .TEXT "GPRIN"        \  EOW('T')  \  .WORD $914F
    .TEXT "REPRO"        \  EOW('G')  \  .WORD $914F
    .TEXT "KEYRA"        \  EOW('M')  \  .WORD $9150
    .TEXT "SETP"         \  EOW('V')  \  .WORD $9168
    .TEXT "KEYBOUMLEI"   \  EOW('T')  \  .WORD $9176
    .TEXT "SCROLLMINU"   \  EOW('S')  \  .WORD $9189
    .TEXT "COP"          \  EOW('Y')  \  .WORD $9195
    .TEXT "PRIN"         \  EOW('T')  \  .WORD $91A7
    .TEXT "PRINTNOKREU"  \  EOW('Z')  \  .WORD $91B1
    .TEXT "PRINTDIS"     \  EOW('K')  \  .WORD $91BB
    .TEXT "ERRPRK"       \  EOW('R')  \  .WORD $91D2
    .TEXT "MOD"          \  EOW('E')  \  .WORD $91D3
    .TEXT "MODEC"        \  EOW('L')  \  .WORD $91D8
    .TEXT "SUBM"         \  EOW('O')  \  .WORD $91EF
    .TEXT "MODULBI"      \  EOW('T')  \  .WORD $920C
    .TEXT "MER"          \  EOW('R')  \  .WORD $9218
    .TEXT "SPEEDS"       \  EOW('W')  \  .WORD $9219
    .TEXT "SPEED"        \  EOW('2')  \  .WORD $921F
    .TEXT "SER"          \  EOW('R')  \  .WORD $9232
    .TEXT "SERR"         \  EOW('2')  \  .WORD $9233
    .TEXT "SAV"          \  EOW('E')  \  .WORD $9234
    .TEXT "LOA"          \  EOW('D')  \  .WORD $9244
    .TEXT "LOAD"         \  EOW('C')  \  .WORD $9254
    .TEXT "LOAD"         \  EOW('F')  \  .WORD $9264
    .TEXT "LOAD"         \  EOW('Q')  \  .WORD $9274
    .TEXT "SAVE"         \  EOW('C')  \  .WORD $9277
    .TEXT "SAVE"         \  EOW('F')  \  .WORD $9287
    .TEXT "SAVE"         \  EOW('Q')  \  .WORD $9297
    .TEXT "SAVE"         \  EOW('D')  \  .WORD $929A
    .TEXT "LOAD"         \  EOW('D')  \  .WORD $92A6
    .TEXT "SAVE"         \  EOW('R')  \  .WORD $92B2
    .TEXT "LOAD"         \  EOW('R')  \  .WORD $92BE
    .TEXT "DI"           \  EOW('R')  \  .WORD $92CA
    .TEXT "NODER"        \  EOW('R')  \  .WORD $92D6
    .TEXT "VERI"         \  EOW('Q')  \  .WORD $92D9
    .TEXT "CHAI"         \  EOW('N')  \  .WORD $92DC
    .TEXT "CHAI"         \  EOW('C')  \  .WORD $92F5
    .TEXT "CHAI"         \  EOW('Q')  \  .WORD $9305
    .TEXT "KEYBOAR"      \  EOW('D')  \  .WORD $9308
    .TEXT "KBEEOF"       \  EOW('F')  \  .WORD $9317
    .TEXT "KBER"         \  EOW('R')  \  .WORD $9322
    .TEXT "KTAS"         \  EOW('T')  \  .WORD $9323
    .TEXT "KTASOF"       \  EOW('F')  \  .WORD $9339
    .TEXT "KTAER"        \  EOW('R')  \  .WORD $934F
    .TEXT "TRAC"         \  EOW('E')  \  .WORD $9350
    .TEXT "TELEFO"       \  EOW('N')  \  .WORD $936D
;% LB_IWS_xxxx START
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; Unknown
    .BYTE $FF,$00,$C5,$14,$00,$51,$D5
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; $9F82 - $9FFF Filler
;------------------------------------------------------------------------------------------------------------
;% LB_xxxx START
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00,$00,$00
    .BYTE  $00,$00,$00,$00,$00,$00
;% LB_xxxx END
;------------------------------------------------------------------------------------------------------------

.END
