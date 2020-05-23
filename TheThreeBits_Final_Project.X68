*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:  *Read starting memory location from user
        JSR         test
        NOP
        LEA         Start1,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVEQ.L     #0,D2
        JSR         ReadL
        MOVE.L      D3,StartMem
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
       
        *Read ending memory location from user
        LEA         Start2,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVEQ.L     #0,D2
        JSR         ReadL
        MOVE.L      D3,EndMem
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        
        *Param for Search loop
        MOVE.L      StartMem,CurrentAddr
        
Search  *Loop through start and end memory locations. Counter param for starting location and counting
        MOVE.L      CurrentAddr,D3
        CMP.L       EndMem,D3
        BGT         End
        MOVE.L      CurrentAddr,D4
        JSR         OutL
        JSR         JMPCHECK
        ADDQ.L      #$0002,CurrentAddr
        BRA         Search      
        
End     *End of program 
        SIMHALT
test
        RTS 
        
JMPCHECK
        MOVE.L      #0,D3
        MOVE.L      #0,D2
        MOVEA.L     CurrentAddr,A1
        MOVE.B      (A1)+,D2
        ASL.W       #4,D2
        ASL.W       #4,D2
        MOVE.B      (A1),D3
        ADD.W       D2,D3
        MOVE.L      D3,D4
        AND.W       #$F000,D3
        ASR.L       #4,D3
        ASR.L       #4,D3
        ASR.L       #4,D3
        CMP.B       #$05,D3
        BEQ         addq
        CMP.B       #$07,D3
        BEQ         moveql
        CMP.B       #$09,D3
        BEQ         sub
        CMP.B       #$08,D3
        BEQ         or
        CMP.B       #$0D,D3
        BEQ         addaadd
        CMP.B       #$0E,D3
        BEQ         lsroas
        CMP.B       #$04,D3
        BEQ         fourchecker
        CMP.B       #$01,D3
        BEQ         moveb
        BRA         BADDATA
        
moveb
        LEA         PrintMOVEB,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS   
        
fourchecker
        MOVE.W      D4,D3
        AND.W       #$0F00,D3
        CMP.W       #$0600,D3
        BEQ         not
        CMP.W       #$0800,D3
        BEQ         movem
        CMP.W       #$0E00,D3
        BEQ         noprtsjsr
        BRA         lea
        
noprtsjsr
        MOVE.W      D4,D3
        AND.W       #$00F0,D3
        CMP.W       #$0070,D3
        BEQ         noprts
        BRA         jsr
        
noprts
        MOVE.W      D4,D3
        AND.W       #$000F,D3
        CMP.W       #$0001,D3
        BEQ         nop
        BRA         rts

nop
        LEA         PrintNOP,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
jsr
        LEA         PrintJSR,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
rts
        LEA         PrintRTS,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS

not
        LEA         PrintNOT,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
movem
        LEA         PrintMOVEM,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
lsroas
        MOVE.W      D4,D3
        AND.W       #%0000000000011000,D3
        CMP.W       #%0000000000001000,D3
        BEQ         ls
        CMP.W       #%0000000000011000,D3
        BEQ         ro
        BRA         as
        
ls
        LEA         PrintLS,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        AND.W       #%0000000100000000,D3
        CMP.W       #%0000000100000000,D3
        BEQ         rightshift
        bra         leftshift
        
ro
        LEA         PrintRO,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        AND.W       #%0000000100000000,D3
        CMP.W       #%0000000100000000,D3
        BEQ         rightshift
        bra         leftshift
        
as
        LEA         PrintAS,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        AND.W       #%0000000100000000,D3
        CMP.W       #%0000000100000000,D3
        BEQ         rightshift
        bra         leftshift
        
rightshift
        LEA         PrintR,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
leftshift
        LEA         PrintL,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
addaadd
        MOVE.W      D4,D3
        AND.W       #%0000000011000000,D3
        CMP.W       #%0000000011000000,D3
        BEQ         adda
        BRA         add
        
adda
        LEA         PrintADDA,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVE.W      D4,D3
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
add
        LEA         PrintADD,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS 
addq
        LEA         PrintADDQ,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS

moveql
        LEA         PrintMOVEQL,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
sub
        LEA         PrintSUB,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
or
        LEA         PrintOR,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
lea
        LEA         PrintLEA,A1
        MOVE.B      #14,D0
        TRAP        #15
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
BADDATA
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
ReadL   *Reads word size hexa from keyboard input, bit shifting for byte size operations
        *param: D1 for trap tasks, D2 for calculations and final hexa
        *return: puts final hexa digit to D3

        *Read single character from input, convert to hex, bit shift left
        *3 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2
        
        *Read single character from input, convert to hex, bit shift left
        *3 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2
        
        *Read single character from input, convert to hex, bit shift left
        *3 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2
        
        *Read single character from input, convert to hex, bit shift left
        *3 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2

        *Read single character from input, convert to hex, bit shift left
        *3 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2

        *Read single character from input, convert to hex, bit shift left
        *2 bytes and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.L       #4,D1
        LSL.L       #4,D1
        ADD.L       D1,D2

        *Read single character from input, convert to hex, bit shift left
        *1 byte and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        LSL.B       #4,D1
        ADD.L       D1,D2

        *Read single character from input, convert to hex, and add to D2
        JSR         RCHR
        MOVE.B      D1,D6
        JSR         AtoH
        MOVE.L      D6,D1
        ADD         D1,D2
        MOVE.L      D2,D3
        RTS
        
OutL    *convert and output word size hexa from D4 to null terminated string for trap task #13 at $6000 to $6004
        *param: D4 to contain word size in hex for conversion, D5 used for calculations/bitshifting
        *output: outputs to terminal window ASCII conversion 
        
        *bit shift right 3 bytes to get first digit, place into $6000
        MOVE.L      D4,D5 
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6000
        
        *bit shift right 3 bytes to get first digit, place into $6000
        MOVE.L      D4,D5 
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        AND.L       #$0000000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6001
        
        *bit shift right 3 bytes to get first digit, place into $6000
        MOVE.L      D4,D5 
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        AND.L       #$0000000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6002
        
        *bit shift right 3 bytes to get first digit, place into $6000
        MOVE.L      D4,D5 
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        AND.L       #$0000000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6003

        *bit shift right 2 bytes and mask to get second digit, place into $6001
        MOVE.L      D4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        AND.L       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6004
        
        *bit shift right 1 byte and mask to get third digit, place into $6002
        MOVE.L      D4,D5
        ASR.L       #4,D5
        ASR.L       #4,D5
        AND.L       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6005
              
        *mask to get 4th and final digit, place into $6003  
        MOVE.L      D4,D5
        ASR.L       #4,D5
        AND.L       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6006
        
        *mask to get 4th and final digit, place into $6003  
        MOVE.L      D4,D5
        AND.L       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6007
        
        *add null-terminator and call trap task #13 on $6000 terminated at $6004
        MOVE.B      #$20,$6008
        MOVE.B      #$00,$6009
        MOVE.W      #$6000,A1
        MOVE.B      #14,D0
        TRAP        #15
        RTS
        
*reads single character from user input & stores into D1.L 
RCHR    MOVE.B      #5,D0
        TRAP        #15
        RTS
  
  *ASCII to Hex for the numbers. Requires D6 as parameter (0-9)
AtoH    MOVE.B      #0,D7
        CMPI.B      #$30,D6
        BLT.B       ERR
        CMP.B       #$39,D6
        BGT.B       ALPHA
        SUBI.B      #$30,D6
        RTS

HtoA    *converts Hexa to ASCII 
        CMPI.B      #$A,D6
        BGE.B       REVALPHA
        ADDI.B      #$30,D6 *if byte is number, add $30 to convert to respective ASCII
        RTS
        
REVALPHA *if byte is letter, add $37 to convert to ASCII   
        ADDI.B      #$37,D6
        RTS
  
*error catch for inproper user input
ERR     MOVE.B      #80,D1
        MOVE.B      #13,D0
        LEA         ERROR,A1
        TRAP        #15
        MOVE.B      #1,D7
        BRA         START 
  
*ASCII to Hex for the letters. Requires D6 as parameter(A-F all capitals)
ALPHA   CMPI.B      #$41,D6
        BLT.B       ERR
        CMPI.B      #$46,D6
        BGT.B       ERR
        SUBI.B      #$37,D6
        RTS

CR              EQU         $0D
LF              EQU         $0A
ERROR           DC.L    ' ERROR INVALID INPUT ',CR,0
Start1          DC.B    'Enter even Long starting memory location ',CR,LF,'(Capital for letters): ',0
Start2          DC.B    'Enter even Long ending memory location ',CR,LF,'(Capital for letters): ',0
StartMem        DS.L    1
EndMem          DS.L    1
CurrentAddr     DS.L    1
ENTER           DC.B    CR,LF,0
Print.W         DC.B    '.W ',0
Print.B         DC.B    '.B ',0
Print.L         DC.B    '.L ',0
PrintLEA        DC.B    'LEA',0
PrintADDQ       DC.B    'ADDQ',0
PrintMOVEQL     DC.B    'MOVEQ.L',0
PrintSUB        DC.B    'SUB',0
PrintOR         DC.B    'OR',0
PrintADDA       DC.B    'ADDA',0
PrintADD        DC.B    'ADD',0
PrintLS         DC.B    'LS',0
PrintRO         DC.B    'RO',0
PrintAS         DC.B    'AS',0
PrintR          DC.B    'R',0
PrintL          DC.B    'L',0
PrintNOT        DC.B    'NOT',0
PrintMOVEM      DC.B    'MOVEM',0
PrintNOP        DC.B    'NOP',0
PrintRTS        DC.B    'RTS',0
PrintJSR        DC.B    'JSR',0
PrintMOVEB      DC.B    'MOVE.B',0


    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
