*-----------------------------------------------------------
* Title      : CSS 422 Disassembler
* Written by : Victor Ly, Jay Brar, Ahmed Elwalid
* Date       : 5/22
* Description: This file is for the effective addressing of our program. Within this file we have a format where things
*              Will be listed as xxxx xxxx xxxx xxxx with 3,4,6, or 7 placed in them. These numbers are used to find the mode and register
*-----------------------------------------------------------

MoveEA
*Xn,M,M,Xn
*Registers D3, D4, D6, and D7
*Xn Source = 3, M Source = 4, Xn Dest = 7, M Dest = 6
*Those are what we need to read to find effective address
            MOVE.B   D7,SIZE
            CLR      D2
            CLR      D3
            CLR      D4
            CLR      D6
            CLR      D7
            MOVE.W   D5,D2


*xxxx xxxx xx66 6xxx
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x777
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE
            
            
            JSR     ModeComp    *print out message accordingly
           
           
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15   
           
           
*xxxx 777x xxxx xxxx
            CLR     D2
            CLR     D6
            MOVE.W  D5,D2
            
            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Xn into D7 DESTINATION

*xxxx xxx6 66xx xxxx
            CLR     D2
            MOVE.W  D5,D2
            
            LSL.W   #7,D2   *666x xxxx x000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0666
            MOVE.B  D2,D6   *store M into D6 DESTINATION
            
            MOVE.B  D6,D3
            MOVE.B  D7,D4
            
            CMP.B  AnModeBYTE,D3
            BEQ    InvalidEA

            CMP.B  OthersBYTE,D3
            BEQ    MoveCheckImm
            
            JSR     ModeComp
            
            RTS     *Return to OP file
MoveCheckImm
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp            
MoveaEA
*An,M,Xn
*Registers D3, D4, D7
*M = 3, Xn = 4, An = 7
*Those are what we need to read to find effective address
            
            
*xxxx xxxx xx33 3xxx
            MOVE.B   D7,SIZE
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE
            
            *Now do compares here
            JSR     ModeComp    *print out message accordingly
           
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15      
            
            *Shifting and putting An in D7
*xxxx 777x xxxx xxxx
            CLR     D2
            CLR     D6
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store An into D7 DESTINATION
            
*xxxx xxx6 66xx xxxx
            CLR     D2
            MOVE.W  D5,D2
            
            LSL.W   #7,D2   *666x xxxx x000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0666
            MOVE.B  D2,D6   *store M into D6 DESTINATION
            
            MOVE.B  D6,D3
            MOVE.B  D7,D4
            *Compare and then RTS
            
            CMP.B  AnModeBYTE,D3
            BNE    InvalidEA
            
            JSR     ModeComp
            
            RTS     *return to op file
            
DivuMulsEA
*Only Dn, M, Xn
*Registers D3, D4, D7
*M = D3, Xn = D4, Dn = D7

*xxxx xxxx xx33 3xxx
            MOVE.B   D7,SIZE
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE   

            *Compare after we have found sources
            *can't be address mode so we need to check for that
            CMP.B   AnModeBYTE,D3
            BEQ     DivuMulsInvalid 
            
            JSR     ModeComp
            
DivuMulsSecondHalf 
           
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15
            
*xxxx 777x xxxx xxxx
            CLR     D2
            CLR     D6
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store An into D7 DESTINATION 
            *Compare and then RTS
            
            MOVE.B  D7,D4
            
            JSR     DnOUTPUT
            RTS     *Return to Opcode file
            
DivuMulsInvalid
            JSR     InvalidEA
            
            BRA     DivuMulsSecondHalf
AddSubEA
*Dn, M, Xn
            MOVE.B   D7,SIZE
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            
*Check for Direction bit
*xxxx xxxy xxxx xxxx
            MOVE.W  D5,D2
            LSL.W   #7,D2
            MOVE.B  #15,D0
            LSR.W   D0,D2
            
            CMPI.B  #%0000,D2
            BEQ     AddSubToDReg

            CMPI.B  #%0001,D2
            BEQ     AddSubFromDReg

AddSubToDReg
*This is adding and subtracting to a data register
*Find the source mode
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE

            JSR     ModeComp              
            
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15  
            
*Find Dn
*xxxx 777x xxxx xxxx
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            *Printing stuff
            MOVE.B  D7,D4
            
            JSR     DnOUTPUT
            
            RTS     *Go back to opcode file

AddSubFromDReg 
*this is adding and subtracting from a data register          
*Find Dn
*xxxx 777x xxxx xxxx
            CLR     D2
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            *Printing stuff
            MOVE.B  D7,D4
            
            JSR     DnOUTPUT
            
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15 
            
*Find the source mode
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE

            *check the modes it cant be
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     AddSubImmCheck
            
            JSR     ModeComp            *if here we possibly have a valid mode  
            
            RTS     *Go back to OP Code file
            
AddSubImmCheck
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp
AddaSubaEA
*Only An, M, Xn
*Registers D3, D4, D7
*M = 3, Xn = 4, An = 7
*Those are what we need to read to find effective address
            
            
*xxxx xxxx xx33 3xxx
            MOVE.B  D7,SIZE
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE
            
            *Now do compares here
            JSR     ModeComp    *print out message accordingly
           
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15         

*xxxx 777x xxxx xxxx
            CLR     D2
            CLR     D6
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store An into D7 DESTINATION
            
            MOVE.B  D7,D4
            
            *always an address register so we can go straight to printing An
            JSR     AnModeOUTPUT
            
            RTS     *Go back to opcode file
            
LeaEA
*Only An, M, Xn
*Registers D3, D4, D7
*M = 3, Xn = 4, An = 7
*Those are what we need to read to find effective address
            
            
*xxxx xxxx xx33 3xxx
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE
            
            *Checks for what LEA cant be
            CMP.B   DnModeBYTE,D3
            BEQ     LEAInvalid

            CMP.B   AnModeBYTE,D3
            BEQ     LEAInvalid
            
            CMP.B   APostBYTE,D3
            BEQ     LEAInvalid
            
            CMP.B   APreBYTE,D3
            BEQ     LEAInvalid
            
            CMP.B   OthersBYTE,D3
            BEQ     LEAImmCheck
            
LEAMode            

            JSR     ModeComp    *We have an okay EA if we hit here
            
LEASecondHalf
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15 
   
*xxxx 777x xxxx xxxx
            CLR     D2
            CLR     D6
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store An into D7 DESTINATION
            
            *Output stuff
            MOVE.B  D7,D4
            
            *always will be an address so we can go straight to An output
            JSR     AnModeOUTPUT
            
            RTS     *Go back to opcode file

            
            
LEAInvalid
            JSR     InvalidEA
            
            BRA     LEASecondHalf
            
LEAImmCheck
*Check that we're not deailing with an immediate value
            CMPI.B     #%0100,D4
            BEQ        LEAInvalid

            BRA        LEAMode  
    
AndOrEA
*Dn, M, Xn
            MOVE.B   D7,SIZE
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
*Check for Direction bit
*xxxx xxxy xxxx xxxx
            MOVE.W  D5,D2
            LSL.W   #7,D2
            MOVE.B  #15,D0
            LSR.W   D0,D2
            
            CMPI.B  #%0000,D2
            BEQ     AndOrToDReg

            CMPI.B  #%0001,D2
            BEQ     AndOrFromDReg

AndOrToDReg
*This is for and or to a data register
*Find the source mode
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE
            
            *Check that mode is not an address
            CMP.B   AnModeBYTE,D3
            BEQ     AndOrError

            JSR     ModeComp   *otherwise we are ok to print
           
AndOrToSecondHalf            

            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15  
            
*Find Dn
*xxxx 777x xxxx xxxx
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            *Printing stuff
            MOVE.B  D7,D4
            
            *always will be a data register
            JSR     DnOUTPUT
            
            RTS     *Go back to opcode file

AndOrFromDReg 
*This is for and or from a data register          
*Find Dn
*xxxx 777x xxxx xxxx
            CLR     D2
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            *Printing stuff
            MOVE.B  D7,D4
            
            *always will be a data register
            JSR     DnOUTPUT
            
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15 
            
*Find the source mode
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store M into D3 SOURCE
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Xn into D4 SOURCE

            *Check that we odn't have an immediate value or address
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     AndOrImmCheck
            
            JSR     ModeComp        *we can print if we hit here      
            
            RTS     *Go back to OP Code file

AndOrError
            JSR     InvalidEA
            *rts after printing to here
            BRA      AndOrToSecondHalf      
AndOrImmCheck
            *Check we're not dealing with immediate value
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp
NotEA
*Find destination mode and destination source
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store Destination mode into D3
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
            *check its not an address or immediate value
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     NotImmCheck
            
            JSR     ModeComp        *we're ok to print if we hit here
            RTS     *return to op code file
            
NotImmCheck
            *check we dont have immediate data
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp            
ShiftRotEA
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            
*Find Dn/Im
*xxxx 777x xxxx xxxx
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            
            MOVE.B  D7,D4 
            
*determine if it is immediate or a register
*xxxx xxxx xxyx xxxx     
       
            CLR     D2
            MOVE.W  D5,D2
            MOVE.W  #10,D0
            LSL.W   D0,D2   *yxxx xx00 0000 0000
            MOVE.W  #15,D0
            LSR.W   D0,D2   *0000 0000 0000 000y
            
            CMPI.B  #%0000,D2
            BEQ     ShiftRotImm
            
            CMPI.B  #%0001,D2
            BEQ     ShiftRotRegi
            
ShiftRotImm
*This is if we have immediate data 
            LEA     POUND,A1  *Prints Pound
            MOVE.B  #14,D0
            TRAP    #15
            
            JSR     PrintRegister
            BRA     ShiftRotSecondHalf
            
ShiftRotRegi
            JSR     DnOUTPUT
            BRA     ShiftRotSecondHalf
            
ShiftRotSecondHalf

            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Data register into D4
            
            *always a Dn so we go straight there
            JSR     DnOUTPUT
            RTS     *Go back to OP Code File
JsrEA
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
*xxxx xxxx xx33 3xxx
            CLR D2
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store Destination mode into D3
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
            *Check for all invalid EA of JSR
            CMP.B   DnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   APostBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   APreBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     JsrImmCheck
            
            JSR     ModeComp    *ok to print if we hit here
            RTS     *return to op code file
            
JsrImmCheck
            *Make sure we dont have immediate value
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp   
 
ShiftRotSpecialEA
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
*xxxx xxxx xx33 3xxx
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store Destination mode into D3
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
            *check for EA modes it cant be
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     ShiftRotSpecialImmCheck
            
            JSR     ModeComp    *ok to print if we hit here
            RTS     *Return to Opcode file
            
ShiftRotSpecialImmCheck
            *Check we dont have immediate data
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp

MoveqEA
*find data first
*xxxx xxxx yyyy yyyy 
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7

            MOVE.W  D5,D2
            
            MOVE.B  #8,D0
            LSL.W   D0,D2   *yyyy yyyy 0000 0000
            LSR.W   D0,D2   *0000 0000 yyyy yyyy
            MOVE.W  D2,D3
            
            LEA     POUND,A1  *Prints pound
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DOLLAR,A1  *Prints dollar
            MOVE.B  #14,D0
            TRAP    #15
            
                                *print value
            CLR.L   D1
            MOVE.B  #15,D0
            MOVE.W  D3,D1
            MOVE.B  #16,D2
            TRAP    #15
            
                        
            LEA     COMMA,A1  *Prints comma
            MOVE.B  #14,D0
            TRAP    #15
            
*xxxx yyyx xxxx xxxx            
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D7   *store Dn into D7 DESTINATION 
            
            MOVE.B  D7,D4 
            
            *always a Dn so we go to Dnoutput
            *RTS is handled within DnOUTPUT
            BRA     DnOUTPUT

            
AddqEA
*xxxx yyyx xxxx xxxx            
            MOVE.W  D5,D2

            LSL.W   #4,D2   *777x xxxx xxxx 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0777
            MOVE.B  D2,D3   *store immediate value in d3
            
            
            LEA     POUND,A1  *Prints pound
            MOVE.B  #14,D0
            TRAP    #15
            
            LEA     DOLLAR,A1  *Prints dollar
            MOVE.B  #14,D0
            TRAP    #15
                                *prints data
            CLR.L   D1
            MOVE.B  #15,D0
            MOVE.W  D3,D1
            MOVE.B  #16,D2
            TRAP    #15
            
                        
            LEA     COMMA,A1  *Prints comma
            MOVE.B  #14,D0
            TRAP    #15

            
*xxxx xxxx xx33 3xxx
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store Destination mode into D3
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
            *check that we dont have immedaite data
            CMP.B   OthersBYTE,D3
            BEQ     AddqImmCheck
            
            JSR     ModeComp        *print the EA
            RTS     *return to opcode file
            
AddqImmCheck
            *check that we dont have immediate data
            *RTS to OP code file is handled by the RTS
            *from these two subroutines
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            BRA        ModeComp            
BranchEA
*find out if we need to read another 16 bits
*by seeing if bits 8-16 are all 0s
*xxxx xxxx yyyy yyyy
            CLR.L     D2
            CLR.L     D3
            CLR.L     D4
            CLR.L     D6
            CLR.L     D7

            MOVE.W  D5,D2
            
            MOVE.B  #8,D0
            LSL.W   D0,D2   *yyyy yyyy 0000 0000
            LSR.W   D0,D2   *0000 0000 yyyy yyyy
            MOVE.W  D2,D3
            
            *determine if we have extra displacement
            CMPI.W  #$0000,D3
            BEQ     BranchExtraDisplacement
            
            CMPI.W  #$00FF,D3
            BEQ     READMORE
            
            EXT.W   D3
            EXT.L   D3
            ADD.L   A5,D3
            ADDI.B  #2,D3   *2 bytes for the instruction
            
            LEA     DOLLAR,A1  *Prints dollar sign
            MOVE.B  #14,D0
            TRAP    #15
            
            
            MOVEQ   #15,D0  *print displacement in hex
            MOVEQ   #16,D2
            MOVE.L  D3,D1
            TRAP    #15
            
            CLR.L   D3
            CLR.L   D1
            RTS     *return to opcode file
READMORE
            ADDA.L   #2,A2
            MOVE.L   (A2)+,D1    *read the next long
           
            ADD.L    A5,D1
            LEA     DOLLAR,A1  *Prints dollar sign
            
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEQ   #15,D0  *print displacement in hex
            MOVEQ   #16,D2
            TRAP    #15
            
            CLR.L   D3
            CLR.L   D1
            RTS     *return to opcode file             
BranchExtraDisplacement            
            
            *Now we need to read absolute address (Word)
            MOVE.W  (A2)+,D1     *STORE ABSOLUTE ADDRESS for printing
            
            EXT.L   D1
            ADD.L  A5,D1
            ADDI.B  #2,D1   *2 bytes for the instruction
            
            LEA     DOLLAR,A1  *Prints dollar sign
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVEQ   #15,D0  *print displacement in hex
            MOVEQ   #16,D2
            TRAP    #15
            
            CLR.L   D3
            CLR.L   D1
            RTS     *return to opcode file
            
MovemEA
            CLR     D2
            CLR     D3
            CLR     D4
            CLR     D6
            CLR     D7
            MOVE.B  #%0000,SlashFlag

*xxxx xxxx xx33 3xxx
            MOVE.W  D5,D2
            
            MOVE.B  #10,D0
            LSL.W   D0,D2   *333x xx00 0000 0000
            MOVE.B  #13,D0
            LSR.W   D0,D2   *0000 0000 0000 0333
            MOVE.B  D2,D3   *store Destination Mode into D3
            
*Find direction
*xxxx xyxx xxxx xxxx
            CLR     D2
            MOVE.W  D5,D2
            
            LSL.W   #5,D2   *yxxx xxxx xxx0 0000
            MOVE.B  #15,D0
            LSR.W   D0,D2   *0000 0000 0000 000y
            
*D3 = mode, D2 = direction            
            CMPI.B  #%0000,D2
            BEQ     MovemRegFirst
            *otherwise we print the registers second
            
*xxxx xxxx xxxx x444
            CLR     D2
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
*D3 = mode, D4 = source
            MOVE.W  (A2)+,RegMask     *STORE register list into variable
*Check what the sources can't be  
          
            CMP.B   DnModeBYTE,D3
            BEQ     MovemError
            
            CMP.B   AnModeBYTE,D3
            BEQ     MovemError
            
            CMP.B   APreBYTE,D3
            BEQ     MovemError
            
            CMP.B   OthersBYTE,D3
            BEQ     MovemCheckImmOne
            
            JSR     ModeComp        *Print the source ea
            
MovemRegSecondHalfTwo        
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15
            
           
            MOVE.B  #0,D7 *set up for looping
            MOVE.B  #7,D6 *keep track of An counter
            MOVE.B  #7,AddressNumber    *Address number starts at 7
MovemRegMaskLoop
*D7 = Counter
*we want to isolate 1 bit by itself everytime
            MOVE.W  RegMask,D2
            LSL.W   D7,D2
            MOVE.B  #15,D0
            LSR.W   D0,D2  *0000 0000 0000 000y   
            
            CMPI.B  #0000,D2
            BEQ     NextIteration
            
            CMPI.B  #7,D7   *check that we don't need to do data registers yet
            BGT     MovemDnOUTPUT
            
            *check that we have already printed data. if we havent then we branch to set flag to 0001
            CMPI.B  #%0001,SlashFlag
            BNE     AddressOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
AddressOUTPUTFlagReturn
            *Printing stuff as if its a address register            
            MOVE.B  AddressNumber,D4
            JSR     AnModeOUTPUT
            
NextIteration
            *increment D7 by 1
            ADDI.B  #1,D7
            
            *Decrement the address number we're at by 1
            SUBI.B  #1,AddressNumber
            
            CMPI.B  #15,D7
            BLE     MovemRegMaskLoop    *Go back to the start of the loop
            
            RTS     *Otherwise it is greater than so we're done printing registers
                    *go back to OP code file
                    
MovemDnOUTPUT
            *Check that we have already printed something before
            CMPI.B  #%0001,SlashFlag
            BNE     MovemDnOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
            
DnOUTPUTFlagReturn
            *print the address register
            MOVE.B  D6,D4
            JSR     DnOUTPUT
            
            *increment D6
            SUBI.B  #1,D6
            BRA     NextIteration        

            
MovemError
            JSR     InvalidEA

            BRA     MovemRegSecondHalfTwo   
            
MovemCheckImmOne
            *Check that we aren't dealing with immediate data
            *this will RTS if it is wrong
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            *Print mode
            JSR        ModeComp *we are ok to print if it isnt
            
            *go back to the second half of the movemEA checking
            BRA     MovemRegSecondHalfTwo 
            
MovemRegFirst
*This is when we have to print the registers first
            MOVE.W  (A2)+,RegMask     *STORE register list into variable
            
*First determine if it is pre decrement
            CMP.B   APreBYTE,D3
            BEQ     PreDecrementMoveM
            
*if not then it is a post increment
            BRA     PostIncrementMoveM
            
MovemRegFirstSecondHalf
            LEA     COMMA,A1  *Prints comma to seperate
            MOVE.B  #14,D0
            TRAP    #15
            
*xxxx xxxx xxxx x444
            CLR     D2
            CLR.L   D4
            MOVE.W  D5,D2
            
            MOVE.B  #13,D6
            LSL.W   D6,D2   *4440 0000 0000 0000
            LSR.W   D6,D2   *xxxx xxxx xxxx 0444
            MOVE.B  D2,D4   *store Destination source into D4
            
            *Print destination
            *InvalidEA takes care of the RTS
            CMP.B   DnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   AnModeBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   APostBYTE,D3
            BEQ     InvalidEA
            
            CMP.B   OthersBYTE,D3
            BEQ     MovemCheckImmTwo
            
            JSR     ModeComp    *Everything is ok go figure out what mode to print
            RTS                 *Return to OPCODE file
MovemCheckImmTwo
            *RTS is handled in both of htese cases
            CMPI.B     #%0100,D4
            BEQ        InvalidEA

            *Otherwise it is ok to print
            BRA        ModeComp 
            
PostIncrementMoveM            
            MOVE.B  #0,D7 *set up for looping
            MOVE.B  #7,D6 *keep track of An counter
            MOVE.B  #7,AddressNumber    *Address number starts at 7
            
PostMovemRegMaskLoop
*D7 = Counter
*we want to isolate 1 bit by itself everytime
            MOVE.W  RegMask,D2
            LSL.W   D7,D2
            MOVE.B  #15,D0
            LSR.W   D0,D2  *0000 0000 0000 000y   
            
            CMPI.B  #0000,D2
            BEQ     PostNextIteration
            
            CMPI.B  #7,D7   *check that we don't need to do data registers yet
            BGT     PostMovemDnOUTPUT
            
            *Check the slash flag
            CMPI.B  #%0001,SlashFlag
            BNE     PostMovemAnOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
            
PostAnOUTPUTFlagReturn
            *Printing stuff as if its a address register
            MOVE.B  AddressNumber,D4
            JSR     AnModeOUTPUT
            
PostNextIteration
            *increment D7 by 1
            ADDI.B  #1,D7
            
            *Decrement the address number we're at by 1
            SUBI.B  #1,AddressNumber
            
            CMPI.B  #15,D7
            BLE     PostMovemRegMaskLoop    *Go back to the start of the loop
            
            BRA     MovemRegFirstSecondHalf *Go and print the second half
                    
PostMovemDnOUTPUT
            *Check the slash flag
            CMPI.B  #%0001,SlashFlag
            BNE     PostMovemDnOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
            
PostDnOUTPUTFlagReturn
            *print the address register
            MOVE.B  D6,D4
            JSR     DnOUTPUT
            
            *increment D6
            SUBI.B  #1,D6
            BRA     PostNextIteration  
      
*this is the start of the predecrement  loop beneath here
PreDecrementMoveM    
            *This is the loop for a predecrement MOVEM        
            MOVE.B  #0,D7 *set up for looping
            MOVE.B  #0,D6 *keep track of An counter
            
PreMovemRegMaskLoop
*D7 = Counter
*we want to isolate 1 bit by itself everytime
            MOVE.W  RegMask,D2
            LSL.W   D7,D2
            MOVE.B  #15,D0
            LSR.W   D0,D2  *0000 0000 0000 000y   
            
            
            CMPI.B  #7,D7   *check that we don't need to do data registers yet
            BGT     PreMovemAnOUTPUT
            
            CMPI.B  #0000,D2
            BEQ     PreNextIteration
            
            *Check the slash flag
            CMPI.B  #%0001,SlashFlag
            BNE     PreMovemDnOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
            
PreDnOUTPUTFlagReturn
            *Printing stuff as if its a address register
            MOVE.B  D7,D4
            JSR     DnOUTPUT
            
PreNextIteration
            *increment D7 by 1
            ADDI.B  #1,D7
            
            CMPI.B  #15,D7
            BLE     PreMovemRegMaskLoop    *Go back to the start of the loop
            
            BRA     MovemRegFirstSecondHalf     *Once greater than we need to print the second half of the EA
                    
PreMovemAnOUTPUT
            *If we can't print anything we need to increment address register
            CMPI.B  #0000,D2
            BEQ     IncrementAddressRegister
            
             *Check the slash flag
            CMPI.B  #%0001,SlashFlag
            BNE     PreMovemAnOUTPUTFlagSet
            
            *Print the slash
            JSR     SLASH
            
PreAnOUTPUTFlagReturn
            *print the address register then increment
            MOVE.B  D6,D4
            JSR     AnModeOUTPUT
            
            *increment D6
            ADDI.B  #1,D6
            BRA     PreNextIteration        
IncrementAddressRegister
            *Increment address register value then get ready for next part of the loop
            ADDI.B  #1,D6
            BRA     PreNextIteration
ModeComp
            *Compare to all the EA modes we support
            *and branch to print the correct one
            CMP.B    AnModeBYTE,D3
            BEQ      AnModeOUTPUT  

            CMP.B    DnModeBYTE,D3
            BEQ      DnOUTPUT
         
            CMP.B    AindirectBYTE,D3
            BEQ      AinOUTPUT
           
            CMP.B    APostBYTE,D3
            BEQ      APostOUTPUT
           
            CMP.B    APreBYTE,D3
            BEQ      APreOUTPUT
           
            CMP.B    OthersBYTE,D3
            BEQ      OthersOUTPUT
           
            BRA      InvalidEA  *if we hit here then the EA is not supported
            
ModeCompEnd 
            RTS       *Returns to the EA subroutine for the opcode

AnModeOUTPUT
            LEA     Address_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15
            
            *Print Register
            JSR     PrintRegister
            
            BRA     ModeCompEnd
                    
DnOUTPUT
            LEA     Dn_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15
            
            *print registser
            JSR     PrintRegister
            
            BRA     ModeCompEnd
AinOUTPUT
            LEA     AddOpen_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15
            
            *print register
            JSR     PrintRegister
            
            LEA     AddClose_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15

            BRA     ModeCompEnd
APostOUTPUT
            LEA     AddOpen_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15
            
            *print register
            JSR     PrintRegister
            
            LEA     AddPostClose_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15

            BRA     ModeCompEnd
APreOUTPUT
            LEA     AddPre_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15
            
            *print register
            JSR     PrintRegister
            
            LEA     AddClose_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15

            BRA     ModeCompEnd
OthersOUTPUT
            *determine if we have absolute short
            CMP.B   AbsShortBYTE,D4
            BEQ     AbsShortOUTPUT
            
            *determine if we have absolute long
            CMP.B   AbsLongBYTE,D4
            BEQ     AbsLongOUTPUT
            
            *determine if we have immediate data
            CMP.B   ImmBYTE,D4
            BEQ     ImmOUTPUT
            
            *otherwise it is invalid
            BRA     InvalidEA
InvalidEA
            LEA     InvalidEA_MSG,A1  *Print mode
            MOVE.B  #14,D0
            TRAP    #15     
            
            BRA     ModeCompEnd
            
AbsShortOUTPUT

            LEA     DOLLAR,A1  *Prints dollar
            MOVE.B  #14,D0
            TRAP    #15
            

            *Now we need to read absolute address (Word)
            MOVE.W  (A2)+,D1     *STORE ABSOLUTE ADDRESS for printing
            
            *Print using trap statement 15 with base 16
            MOVEQ   #15,D0
            MOVEQ  #16,D2
            TRAP    #15
            
            CLR     D1

            BRA     ModeCompEnd
AbsLongOUTPUT

            LEA     DOLLAR,A1  *Prints dollar
            MOVE.B  #14,D0
            TRAP    #15
            
            *Now we need to read absolute address (Word)
            MOVE.L  (A2)+,D1     *STORE ABSOLUTE ADDRESS for printing
            
            *Print using trap statement 15 with base 16
            MOVEQ   #15,D0
            MOVEQ   #16,D2
            TRAP    #15
                 
            CLR.L    D1
            
            BRA     ModeCompEnd
ImmOUTPUT
            LEA     POUND,A1  *Prints pound
            MOVE.B  #14,D0
            TRAP    #15
            
            CMP.B   #%0001,SIZE
            BEQ     ImmLong
            
            BRA     ImmWord   *if size is not a long then it is a word
ImmWord

            MOVE.W  (A2)+,D1     *STORE next word for printing
            
            *Print using trap statement 15 with base 16
            MOVEQ   #15,D0
            MOVEQ  #10,D2
            TRAP    #15
            
            CLR.L   D1
            BRA     ModeCompEnd
            
ImmLong
            MOVE.L  (A2)+,D1     *STORE next long for printing
            
            *Print using trap statement 15 with base 16
            MOVEQ   #15,D0
            MOVEQ   #10,D2
            TRAP    #15
            
            CLR.L    D1
            BRA     ModeCompEnd            
PrintRegister
            *uses trap 15 with base 16 to print the register
            MOVE.B  #15,D0
            MOVE.B  D4,D1
            MOVE.B  #16,D2
            TRAP    #15
            
            RTS

SLASH
            LEA     SLASH_MSG,A1  *Print Slash
            MOVE.B  #14,D0
            TRAP    #15     
            
            RTS       
  
*Beneath are flag sets for SLASH
AddressOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     AddressOUTPUTFlagReturn
MovemDnOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     DnOUTPUTFlagReturn
PostMovemAnOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     PostAnOUTPUTFlagReturn            
PostMovemDnOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     PostDnOUTPUTFlagReturn    
PreMovemDnOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     PreDnOUTPUTFlagReturn 
PreMovemAnOUTPUTFlagSet
            MOVE.B  #%0001,SlashFlag
            BRA     PreAnOUTPUTFlagReturn   
                 
* Printing stuff
Dn_MSG          DC.B    'D',0
Address_MSG     DC.B    'A',0
AddOpen_MSG     DC.B    '(A',0
AddPostClose_MSG DC.B    ')+',0
AddPre_MSG      DC.B    '-(A',0
AddClose_MSG    DC.B    ')',0
InvalidEA_MSG   DC.B    'INVALID EA',0
COMMA           DC.B    ', ',0
POUND           DC.B    '#',0
DOLLAR          DC.B    '$',0
Slash_MSG       DC.B    '/',0

*M variables
DnModeBYTE      DC.B   %0000 
AnModeBYTE       DC.B   %0001 
AindirectBYTE   DC.B   %0010 
APostBYTE       DC.B   %0011 
APreBYTE        DC.B   %0100 
OthersBYTE      DC.B   %0111
*Xn variables
AbsShortBYTE    DC.B   %0000
AbsLongBYTE     DC.B   %0001
ImmBYTE         DC.B   %0100
SIZE            DC.B    %0000
RegMask         DS.W    1
AddressNumber   DS.W    1
SlashFlag       DS.B    1














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
