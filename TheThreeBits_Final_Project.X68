*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:  *Read starting memory location
        LEA         Start1,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVEQ.L     #0,D2
        JSR         ReadW
        MOVE.W      D3,StartMem
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        
        *Read ending memory location
        LEA         Start2,A1
        MOVE.B      #14,D0
        TRAP        #15
        MOVEQ.L     #0,D2
        JSR         ReadW
        MOVE.W      D3,EndMem
        LEA         ENTER,A1
        MOVE.B      #14,D0
        TRAP        #15
        
        *Param for Search loop
        MOVE.W      StartMem,D3
        
Search  *Loop through start and end memory locations. D3 param for starting location
        CMP.W       EndMem,D3
        BGT         End
        MOVE.W      D3,D4
        JSR         OutW
        ADDQ.W      #$0002,D3
        *This is where our check/jumps for the machine code will need to happen
        BRA         Search      
        
End     *End of program 
        SIMHALT
        
ReadW   *Reads word size hexa from keyboard input, bit shifting for byte size operations
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
        
OutW    *convert and output word size hexa from D4 to null terminated string for trap task #13 at $6000 to $6004
        *param: D4 to contain word size in hex for conversion, D5 used for calculations/bitshifting
        *output: outputs to terminal window ASCII conversion 
        
        *bit shift right 3 bytes to get first digit, place into $6000
        MOVE.W      D4,D5 
        ASR.W       #4,D5
        ASR.W       #4,D5
        ASR.W       #4,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6000

        *bit shift right 2 bytes and mask to get second digit, place into $6001
        MOVE.W      D4,D5
        ASR.W       #4,D5
        ASR.W       #4,D5
        AND.W       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6001
        
        *bit shift right 1 byte and mask to get third digit, place into $6002
        MOVE.W      D4,D5
        ASR.W       #4,D5
        AND.W       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6002
              
        *mask to get 4th and final digit, place into $6003  
        MOVE.W      D4,D5
        AND.W       #$000F,D5
        MOVE.B      D5,D6
        JSR         HtoA
        MOVE.B      D6,$6003
        
        *add null-terminator and call trap task #13 on $6000 terminated at $6004
        MOVE.B      #$00,$6004
        MOVE.W      #$6000,A1
        MOVE.B      #13,D0
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

PREPADD MOVEA.L     A2,A1
        JSR         GETVAL
        MOVE.B      #$09,(A2)+
        RTS

PREBUFF MOVEA.L     A6,A2
        BSR         PREPADD
        JSR                
        
DECODE  MOVEM.L A4-A6/D0-D4/D6-D7,-(SP)      
        JSR     clrRegs                         
        MOVE.B  1,D5        
        MOVE.W  (A0)+,D7           
        MOVEA.L A2,A3                              
        JSR     DEHELP             

DEHELP  MOVE.W  D7,D5
        MOVE.B  12,D4
        LSR.W   D4,D5
        MULU
        
        
GETVAL  JSR         VAL1
        MOVE.B      12,D4   
        JSR         VAL2
        MOVE.B      8,D4
        JSR         VAL2
        MOVE.B      4,D4
        JSR         VAL2
        MOVE.B      0,D4
        JSR         VAL4
        MOVE.B      12,D4
        JSR         VAL4
        MOVE.B      8,D4
        JSR         VAL4
        MOVE.B      4,D4
        JSR         VAL4
        MOVE.B      #0,D4
        LSR.L       D4,D5
        ANDI.L      #$0000000F,D6
        JSR         HtoA

VAL1    MOVEQ   #$0, D5
        MOVE.L  A0,D5
        SWAP    D5
        RTS

VAL2    LSR.L   D4,D5
        ANDI.L  #$0000000F,D6
        JSR     HtoA
        JSR     VAL1
        RTS

VAL3    MOVEQ   #$0,D5
        MOVE.L  A0,D5
        RTS
        
VAL4    LSR.L   D4,D5
        ANDI.L  #$0000000F,D6
        JSR     HtoA
        JSR     VAL3
        RTS
        
        

CLEAR   CLR         D0
        CLR         D1
        CLR         D2
        CLR         D3
        CLR         D4
        CLR         D5
        CLR         D6
        CLR         D7
        
clearRegs
        CLR.L   D0                  
        CLR.L   D1
        CLR.L   D2
        CLR.L   D3
        CLR.L   D4
        CLR.L   D6
        CLR.L   D7
        RTS           
     


CR          EQU         $0D
LF          EQU         $0A
ERROR       DC.L    ' ERROR INVALID INPUT ',CR,0
Start1      DC.B    'Enter even starting memory location between',CR,LF,'(5000) and (5038) (Capital for letters): ',0
Start2      DC.B    'Enter even ending memory location between',CR,LF,'(5000) and (5038) (Capital for letters): ',0
StartMem    DS.W    1
EndMem      DS.W    1
ENTER       DC.B    CR,LF,0


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
