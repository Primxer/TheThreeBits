*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
TEST_VALUE      EQU   $1202
SRC_MODE        EQU   $1504
SRC_REGISTER    EQU   $1508 
DEST_MODE       EQU    $1512
DEST_REGISTER   EQU    $1516  
OP_SIZE         EQU    $1520 
    ORG       $1000
START:     
* Hardcode some input passed from OP code            
    MOVE.W #%111,SRC_MODE    
    MOVE.W #%100,SRC_REGISTER
    MOVE.W #%001,DEST_MODE
 
    MOVE.W #%111,DEST_REGISTER
    MOVE.L #$3456789A,TEST_VALUE    *store value in mem to test printing address/immediate 
    MOVE.B #1,OP_SIZE   *0 = .B, 1 = .W, 2 = .L
    MOVE.L  #$1200,A2   *assume current index is on $1200,

* EA code start
    MOVE.W SRC_MODE,D1      *decode and print source EA   
    MOVE.W SRC_REGISTER,D2
    JSR DECODE_EA   
        
    LEA     PRINT_COMMA,A1   *print comma 
    MOVE.B  #14,D0                     
    TRAP    #15 
   
    MOVE.W  DEST_MODE,D1    *decode and print destination EA
    MOVE.W DEST_REGISTER,D2
    JSR DECODE_EA   
    
    JMP END
        
DECODE_EA 
    LEA EAMODE_TABLE,A3 *load EA mode juno table to A3
    LEA HEX_CHAR,A4
    MULU #6,D1  
    JSR 0(A3,D1)
    RTS
    
EAMODE_TABLE
    JMP MODE_000
    JMP MODE_001
    JMP MODE_010
    JMP MODE_011
    JMP MODE_100
    JMP MODE_101
    JMP MODE_110
    JMP MODE_111
    
*Data register mode
MODE_000
    MOVE.L #26,D4
    LEA 0(A4,D4),A1
    MOVE.B  #14,D0
    TRAP    #15     *Print 'D' using HEX_CHAR table        
    MULU #2,D2
    LEA  0(A4,D2),A1
    MOVE.B #14,D0
    TRAP #15
    RTS
    
*Address register mode
MODE_001
    MOVE.L #20,D4
    LEA 0(A4,D4),A1
    MOVE.B  #14,D0
    TRAP    #15      *Print 'A' using HEX_CHAR table
    
    MULU #2,D2
    LEA  0(A4,D2),A1
    MOVE.B #14,D0
    TRAP #15
    RTS

*Indirect Address register mode
MODE_010
    LEA     PRINT_LPAREN,A1
    MOVE.B  #14,D0    
    TRAP    #15    
    JSR     Mode_001
    LEA     PRINT_RPAREN,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

*Address register with post-increment
MODE_011
    JSR     MODE_010
    LEA     PRINT_PLUS,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
*Address register with post-increment
MODE_100
    LEA     PRINT_MINUS,A1
    MOVE.B  #14,D0
    TRAP    #15
    JSR     MODE_010
    RTS

MODE_101
    JMP INVALID
MODE_110
    JMP INVALID
    
MODE_111    MOVEA.L A2,A3
    CMP.B   #%000,D2
    BEQ     ABS_Short     
    CMP.B   #%001,D2
    BEQ     ABS_Long      
    CMP.B   #%100,D2
    BEQ     IMMEDIATE       
    BRA     INVALID


*Absolute long mode
ABS_LONG  LEA     PRINT_OCTOTH,A1
          MOVE.B  #14,D0
          TRAP    #15    
          ADDA.W  #2,A3                
          MOVE.L  (A3),D6
          MOVE.L  #8,D5               
          JSR     PRINT_HEX
          ADDA.W  #4,A2
          RTS
          
*Absolute short mode
ABS_SHORT
        LEA     PRINT_DOLLAR,A1
        MOVE.B  #14,D0
        TRAP    #15
        ADDA.W  #2,A3                
        MOVE.W  (A3),D6      
        MOVE.L  #4,D5              
        JSR     PRINT_HEX
        ADDA.W  #2,A2
        RTS
        
*Immediate short mode
IMMEDIATE       
        LEA     PRINT_OCTOTH,A1  
        MOVE.B  #14,D0
        TRAP    #15   
        LEA     PRINT_DOLLAR,A1                     
        MOVE.B  #14,D0                
        TRAP    #15
        CLR.L   D3                
        MOVE.B  OP_SIZE,D3          
        CMP.B   #1,D3        
        BGT     IMMED_L                                
        ADDA.W  #2, A3
        CLR.L   D6
        MOVE.W  (A3),D6                
        MOVE.L  #4,D5        *4 characters to display       
        JSR     PRINT_HEX
        ADDA.W  #2,A2 
        RTS

IMMED_L      
        ADDA.W  #2,A3
        CLR.L   D6                
        MOVE.L  (A3),D6                
        MOVE.L  #8,D5               *8 characters to display
        JSR     PRINT_HEX                
        ADDA.W  #4,A2 
        RTS 
                
PRINT_HEX       
        MOVEM.L D2-D5,-(SP)                                        
        LEA     HEX_CHAR,A3
        MULU.W  #4,D5              
        MOVE.L  #32,D2              *set the total number of bits                
        SUB.L   D5,D2                              
        MOVE.L  #28,D3              
LOOP         
        MOVE.L  D6,D4               *display one char per iteraiton               
        LSL.L   D2,D4               
        LSR.L   D3,D4               
        MULU    #2,D4               *find location character in char_table
        LEA     0(A3,D4),A1                        
        MOVE.B  #14,D0                             
        TRAP    #15                 
                
        ADD.B   #4,D2               *add 4 to displacement to get next nibble
        CMP.B   #32,D2                        
        BNE     LOOP
        MOVEM.L (SP)+,D2-D5         
        RTS

**
*Invalid EA mode. Jump to "prompt uset to input" when merging
**
INVALID 
    LEA     PRINT_INVALIDEA,A1
    MOVE.B  #14,D0
    TRAP    #15
END
      SIMHALT             ; halt simulator
      
HEX_CHAR     
    DC.B    '0',0
    DC.B    '1',0
    DC.B    '2',0
    DC.B    '3',0    
    DC.B    '4',0    
    DC.B    '5',0
    DC.B    '6',0
    DC.B    '7',0
    DC.B    '8',0
    DC.B    '9',0
    DC.B    'A',0
    DC.B    'B',0
    DC.B    'C',0
    DC.B    'D',0
    DC.B    'E',0
    DC.B    'F',0

PRINT_LPAREN DC.B    '(',0
PRINT_RPAREN DC.B    ')',0
PRINT_MINUS DC.B    '-',0
PRINT_PLUS DC.B    '+',0
PRINT_DOLLAR DC.B   '$',0
PRINT_OCTOTH DC.B    '#',0
PRINT_COMMA DC.B    ',',0
PRINT_INVALIDEA DC.B    'Invalid EA',0


    END    START        ; last line of source


