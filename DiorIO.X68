*-----------------------------------------------------------
* Title      : CSS 422 Disassembler
* Written by : Victor Ly, Jay Brar, Ahmed Elwalid
* Date       : 5/22
* Description: This file is the input and output for our disassembler
*-----------------------------------------------------------
    ORG    $1000
PROGSTART:                  ; first instruction of program
                           
                        LEA     WELCOME_MESS,A1  *Greet user with a welcome message
                        MOVE.B  #14,D0
                        TRAP    #15
                        
DISASSEMBLEAGAIN        
*Begin reading user input for a starting and ending address               
                        JSR     READINPUT

                        LEA     NEWLINE,A1  *print a new line
                        MOVE.B  #14,D0
                        TRAP    #15
                        
*Check that the size of the given addresses are not odd
                        BRA     CheckValidSize
ValidSize               
*Once the size is valid we can set up the loop
*Move the starting and ending address into A2 and A3         
                        MOVE.L  StartAd,A2      *Load for comparisons
                        MOVE.L  EndAd,A3
                        CMPA.L     A2,A3
                        BLT     END             *Branches if end address is greater than start addres
                        MOVE.B  #0,LINE_COUNT   *Set the amount of lines printed on the screen to 0
    
LOOP
*This will loop until the starting address is greater than the ending address
                        ADDI.B  #1,LINE_COUNT   *Increase our line counter by 1
                        *print address
                        
                        *Print the current address
                        MOVEQ   #15,D0
                        MOVEQ  #16,D2
                        MOVE.L  A2,D1
                        TRAP    #15
                        CLR     D1
                        
                        MOVEA.L A2,A5
                        MOVE.W  (A2)+,D0        *STORE INSTRUCTION // need to parse through more to determine what kind of instruction
                        MOVE.W  D0,D5           *keep original instruction in D5
                        
                        CMP.W   #$FFFF,D0       * compare to FFFF. Branch to end if no data exists
                        BEQ     LOOPEND
                        
                        *Now that instruction is stored we need to determine if there is actually an instruction in the data register
                        
                        MOVE.W  D0,D2       *Move instruction for manipulation
                        MOVE.B  #12,D3      *Load 12 into d3 to shift d2 12 times over
                        LSR.W   D3,D2       *shift d2 12 times
                        
                        *compare the front 4 bits to determine what instruction we have
                        CMP.B   ADDBYTE,D2
                        BEQ     ADDIO
                        
                        CMP.B   ADDQBYTE,D2
                        BEQ    ADDQIO
                        
                        CMP.B   MOVEQBYTE,D2
                        BEQ     MOVEQIO
                        
                        CMP.B   SUBBYTE,D2
                        BEQ     SUBIO
                        
                        CMP.B   MULSBYTE,D2
                        BEQ     MULSIO
                        
                        CMP.B   DIVUBYTE,D2
                        BEQ     DIVUIO
                        
                        CMP.B   MULTOPBYTE,D2
                        BEQ     MULTOPIO
                        
                        CMP.B   SHIFTSBYTE,D2
                        BEQ     SHIFTSIO
                        
                        CMP.B   BRANCHBYTE,D2
                        BEQ     BRANCHIO
                        
                        *0000 leading 4 digits is not supported by this disassembler
                        CMPI.B   #%0000,D2
                        BEQ     ERROR
                        
                        *If we reach here it could possibly be a move so we need to check the front 2 bits for 00
                        LSR.W   #2,D2
                        CMPI.B   #%0000,D2 *compare it to 0000 to see if it is a move
                        BEQ     MOVESIO
                        
                        
                        BRA     ERROR   *We reach here if we couldn't read anything so we branch to error
LOOPEND                 
                        CLR     D2
                        LEA     NEWLINE,A1  *print a new line
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR.L   D1
                        
                        CMPA.L  A2,A3                    *compare if start address is greater than end address
                        BLT     END                      *if end address is less than start address then we are finished
                        
                        CMP.B  #24,LINE_COUNT            *check that we haven't printed more than 24 lines
                        BEQ     ENTERWAITING             *if so we need to wait for the user to press a key to print 24 more lines
                       
                        BRA LOOP                         *Then we can go back and start the loop again
                        
END
                        *Prompt user to enter ascii characters y to try again
                        *any other valid ends it
                        CLR.L   D2
                        LEA     REPEAT_MESS,A1  *Prompt user to enter a number in hexadecimal
                        MOVE.B  #14,D0
                        TRAP    #15 
  
                        LEA     USER_INPUT,A1  
                        MOVE.B  #2,D0        *Use trap task 2 to read in a string from keyboard
                        TRAP    #15        
                        
                        CMP.B  #$79,(A1)   *Hex 79 is "y" in ASCII
                        BEQ     DISASSEMBLEAGAIN

                        *otherwise print thanks for using message
                        LEA     END_MESS,A1  *Prompt user to enter a number in hexadecimal
                        MOVE.B  #14,D0
                        TRAP    #15
                        SIMHALT             ; halt simulator
                        
                        
READINPUT               
                        LEA     SPEC_MESS,A1  *Specifications on how the user needs to enter the addresses
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        LEA     NEWLINE,A1  *Print a blank line
                        MOVE.B  #14,D0
                        TRAP    #15
    
                        LEA     STARTAD_MESS,A1  *Prompt user to enter a address
                        MOVE.B  #14,D0
                        TRAP    #15 

                        LEA     USER_INPUT,A1  *use this to ensure that we don't replace the starting message with the start address
                        MOVE.B  #2,D0        *Use trap task 2 to read in a string from keyboard
                        TRAP    #15
                        MOVE.B  #0,D2        *We will use D2 to loop through each character inputted (8 total)
                        JSR     CONVERT      *Convert ascii to hex
                        MOVE.L D4,StartAd    *Move what we got from the starting conversion to our variable
                        
                        CLR     D4 *clear d4 before we use it again
                        CLR     D2
                        CLR     D0
                        
                        LEA     ENDAD_MESS,A1  *Prompt user to enter a number in hexadecimal
                        MOVE.B  #14,D0
                        TRAP    #15   
                        
                        LEA     USER_INPUT,A1  *use this to ensure that we don't replace the starting message with the end address
                        MOVE.B  #2,D0        *Use trap task 2 to read in a string from keyboard
                        TRAP    #15
                        MOVE.B  #0,D2        *We will use D2 to loop through each character inputted (8 total)
                        JSR     CONVERT      *Convert ascii to hex
                        MOVE.L D4,EndAd
                        RTS


CONVERT
                        MOVE.B  (A1)+,D3     *Move the first byte of user input into D3
                        ADD.B   #1,D2        *Increment the amount of iterations
                        CMP.B   #9,D2        *If D2 == 9 then we have gone through 8 times
                        BEQ     RETURN      *Branch to continue
                           
                        ASL.L   #4,D4        *Shift it so that it is formatted correctly
                           
                           
                        CMP.B   #$3A,D3      *If the byte value is less than $3A (since 0-9 goes from $30-$39)
                        BLT     NUMBER       *Branch to the number conversion
                           
                        CMP.B   #$40,D3      *If the byte value is greater than $40 (since A-F is $41-$46)
                        BGT     LETTER       *Branch to letter conversion
                           
NUMBER
                        SUB.B   #$30,D3      *Subtract 30 to go from ASCII to hex for number
                        ADD.B   D3,D4        *Add the value into D4
                        BRA     CONVERT      *Go back to convert until we've hit all 8 characters
                           
LETTER
                        SUB.B   #$37,D3      *Subtract 37 to go from ASCII to hex for letter
                        ADD.B   D3,D4        *Add value into D4
                        BRA     CONVERT      *Go back to convert until we've hit all 8 characters
CheckValidSize
*Check that last bits of start and end address are not 1
*xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxy
                        CLR.L D2
                        CLR.L D6
                        
                        MOVE.L  StartAd,D2
                        *we want to shift 31 every time
                        MOVE.B  #31,D6
                        
                        LSL.L   D6,D2   *y000 0000 0000 0000 0000 0000 0000 0000
                        LSR.L   D6,D2   *0000 0000 0000 0000 0000 0000 0000 000y
                        
                        CMPI.B  #%0001,D2
                        BEQ     INVALIDSIZE
                        
                        *Do again for ending address
                        CLR.L D2
                        MOVE.L  EndAd,D2
                        
                        LSL.L   D6,D2   *y000 0000 0000 0000 0000 0000 0000 0000
                        LSR.L   D6,D2   *0000 0000 0000 0000 0000 0000 0000 000y
                        
                        *if the last bit is a 1 then it is an odd address which is invalid
                        CMPI.B  #%0001,D2
                        BEQ     INVALIDSIZE
                        
                        BRA     ValidSize   *size is valid if we reach here

INVALIDSIZE
                        *Jump to print error size message
                        JSR     SIZEMESS
                        *branch to where we start taking in user input
                        BRA     DISASSEMBLEAGAIN
RETURN
                        RTS
*Beneath is where we jump into the opcode file if we were able to find an instruction off the front 4 bits                        
ADDIO
                        CLR D2
                        JSR ADDANDADDA
                        BRA LOOPEND
ADDQIO
                        CLR D2
                        JSR ADDQ
                        BRA LOOPEND
MOVEQIO
                        CLR D2
                        JSR MOVEQ
                        BRA LOOPEND
SUBIO
                        CLR D2
                        JSR SUB
                        BRA LOOPEND
MULSIO
                        CLR D2
                        JSR MULSAND
                        BRA LOOPEND
DIVUIO
                        CLR D2
                        JSR DIVUOR
                        BRA LOOPEND
MULTOPIO
                        CLR D2
                        JSR MULTOP
                        BRA LOOPEND
SHIFTSIO
                        CLR D2
                        JSR SHIFTSANDROT
                        BRA LOOPEND
BRANCHIO
                        CLR D2
                        JSR BRANCHING
                        BRA LOOPEND
MOVESIO
                        CLR D2
                        JSR MOVEANDMOVEA
                        BRA LOOPEND
                        
ERROR
                        JSR ERROROP
                        BRA LOOPEND
ENTERWAITING
*This is where we jump to the opcode file to wait for user input to print more lines on the screen
                        LEA     NEWLINE,A1  *print a new line
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        *jump to wait for user input
                        JSR WAITFORINPUT
                        MOVE.B  #0,LINE_COUNT   *Set the linecount back to 0
                        
                        LEA     NEWLINE,A1  *print a new line
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        BRA     LOOP
                        
CR          EQU             $0D
LF          EQU             $0A
WELCOME_MESS    DC.B    'Welcome to the luxorious Diorfanclub disassembler!',0
END_MESS        DC.B    CR,LF,'Thank you for using our disassembler',0
NEWLINE         DC.B    CR,LF,0
STARTAD_MESS    DC.B    CR,LF,'Enter a starting address: ',0
ENDAD_MESS      DC.B    CR,LF,'Enter an ending address: ',0
SPEC_MESS       DC.B    CR,LF,'All addresses must have 8 hexadecimal characters and letters must be capital',0
REPEAT_MESS     DC.B    CR,LF,'Enter "y" to use the disassembler again. Otherwise enter anything to end: ',0
StartAd         DS.L    1
EndAd           DS.L    1
USER_INPUT      DS.L    1
LINE_COUNT      DS.L    1
ERROR_MESS      DC.L   ' INVALID OP CODE: DATA $',0
MOVEBYTE        DC.B   %0000
MOVEQBYTE       DC.B   %0111
ADDBYTE         DC.B   %1101
ADDQBYTE        DC.B   %0101
SUBBYTE         DC.B   %1001
MULSBYTE        DC.B   %1100
DIVUBYTE        DC.B   %1000
MULTOPBYTE      DC.B   %0100
SHIFTSBYTE      DC.B   %1110
BRANCHBYTE      DC.B   %0110

    INCLUDE     "DiorOP.x68"
    INCLUDE     "DiorEA.x68"
    END    PROGSTART        ; last line of source























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
