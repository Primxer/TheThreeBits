*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
opMULU      
            LSR.L   #6,D6               
            ANDI.W  #$3,D6              
            CMP.B   #$3,D6             
            BEQ     muluHelp               
            JMP     opANDEXG            
muluHelp    
            MOVE.W  D7,D6              
            LSR.L   #3,D6               
            ANDI.W  #$7,D6             
            CMP.B   #$7,D6              
            BEQ     movePTR             
            JMP     BADDATA     

movePTR     
            ADDQ.W  #2,A0              
            JMP     BADDATA

opANDI      MOVE.B  #'A',(A2)+          
            MOVE.B  #'N',(A2)+
            MOVE.B  #'D',(A2)+
            MOVE.B  #'I',(A2)+
            MOVE.B  #'.',(A2)+
            JSR     SIZEBUF         
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+            
            MOVE.B  #'#',(A2)+           
            JSR     getAddr                      
            MOVE.B  #',',(A2)+         
            JSR     getEA               
            RTS            
            
opSUBI      MOVE.B  #'S',(A2)+          
            MOVE.B  #'U',(A2)+
            MOVE.B  #'B',(A2)+
            MOVE.B  #'I',(A2)+
            MOVE.B  #'.',(A2)+
            JSR     SIZEBUFF         
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+            
            MOVE.B  #'#',(A2)+
            
            JSR     getAddr             
            MOVE.B  #',',(A2)+          
            JSR     getEA               
            RTS            
            
opADDI      MOVE.B  #'A',(A2)+          
            MOVE.B  #'D',(A2)+
            MOVE.B  #'D',(A2)+
            MOVE.B  #'I',(A2)+
            MOVE.B  #'.',(A2)+
            JSR     SIZEBUF         
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+            
            MOVE.B  #'#',(A2)+
            JSR     getAddr             
            MOVE.B  #',',(A2)+          
            JSR     getEA               
            RTS            

opEORI      MOVE.B  #'E',(A2)+          
            MOVE.B  #'O',(A2)+
            MOVE.B  #'R',(A2)+
            MOVE.B  #'I',(A2)+
            MOVE.B  #'.',(A2)+
            JSR     SIZEBUF         
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+            
            MOVE.B  #'#',(A2)+
            JSR     getAdd             
            MOVE.B  #',',(A2)+          
            JSR     getEA               
            RTS           

opAND       MOVE.B  #'A',(A2)+         
            MOVE.B  #'N',(A2)+
            MOVE.B  #'D',(A2)+
            MOVE.B  #'.',(A2)+            
            JSR     SIZEBUF        
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            MOVE.B  #' ',(A2)+
            JSR     getDBit          
            CMP.B   #%0,D6             
            BNE     opAND01              
            JSR     EAFILL              
            MOVE.B  #',',(A2)+          
            MOVE.B  #'D',(A2)+          
            MOVE.W  D7,D6              
            LSR.L   #8,D6          
            LSR.L   #1,D6               
            ANDI.B  #$7,D6              
            ADD.B   #$30,D6            
            MOVE.B  D6,(A2)+        
            RTS

opAND01     MOVE.B  #'D',(A2)+          
            MOVE.W  D7,D6              
            LSR.L   #8,D6          
            LSR.L   #1,D6               
            ANDI.B  #$7,D6              
            ADD.B   #$30,D6            
            MOVE.B  D6,(A2)+           
            MOVE.B  #',',(A2)+          
            JSR     EAFILL                                 
            JMP     end1100

getDBit   
            MOVE.W  D7,D6              
            LSR.L   #8,D6          
            ANDI.B  #01,D6             
            RTS  
getAdd     
            CMP.B   #%00,D6             
            BEQ     by2Buff         
            CMP.B   #%01,D6            
            BEQ     w2Buff        
            CMP.B   #%10,D6            
            BEQ     l2Buff       
            RTS

by2Buff   
            MOVE.B  #'$',(A2)+
            CLR.L   D4          
            MOVE.W  (A0),D2      
            CLR.L   D4          
            MOVE.B  #2,D4       

w2Buff
            MOVE.B  #'$',(A2)+  
            CLR.L   D4          
            MOVE.W  (A0),D2      
            CLR.L   D4          
            MOVE.B  #4,D4      
l2Buffer
            MOVE.B  #'$',(A2)+
            CLR.L   D4         
            MOVE.L  (A0),D2      
            CLR.L   D4          
            MOVE.B  #8,D4       
getEA       
            LEA         EAMODE_TABLE,A5 
            CLR.L   D2
            CLR.L   D3
            CLR.L   D4           
            CLR.L   D6
            MOVE.W  D7,D6                
            ANDI.W  #$003F,D6             
            MOVE.B      #3,D1                            
            LSR.W       D1,D6                           

            MULU      #6,D6                       
            JSR         00(A5,D6)              

            RTS                                
        
            JMP         END
                   

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
