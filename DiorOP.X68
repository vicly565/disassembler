*-----------------------------------------------------------
* Title      : CSS 422 Disassembler
* Written by : Victor Ly, Jay Brar, Ahmed Elwalid
* Date       : 5/22
* Description: This file is used for the op codes. Throughout this file we use a formaat of xxxx xxxx xxxx xxxx
* with "y" replacing some of the "x". The "y" is the bits that we want to check for to figure out the size or opcode.
* So we need to shift around the instruction to ensure that only the "y"s are left to compare to the size or opcode.
*-----------------------------------------------------------

MULSAND
*This subroutine will figure out if this instruction is a muls or an and
*xxxx xxxy yyxx xxxx                        
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyx xxxx x000 0000
                        MOVE.B  #13,D3
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                       
                        *If the 3 y bits are 111 we have figured out its a muls
                        CMPI.B  #%0111,D2
                        BEQ     MULS
                        
                        *check all possible cases that we branch to and
                        CMPI.B  #%0000,D2
                        BEQ     AND
                        
                        CMPI.B  #%0001,D2
                        BEQ     AND
                        
                        CMPI.B  #%0010,D2
                        BEQ     AND
                        
                        CMPI.B  #%0100,D2
                        BEQ     AND
                        
                        CMPI.B  #%0101,D2
                        BEQ     AND
                        
                        CMPI.B  #%0110,D2
                        BEQ     AND
                        
                        *Otherwise we know it is an error
                        BRA     ERROROP
MULSANDEND                        
                        RTS 
                        
DIVUOR
*This subroutine will figure out if this instruction is a DIVU or an OR
*xxxx xxxy yyxx xxxx                        
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyx xxxx x000 0000
                        MOVE.B  #13,D3
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                       
                        *if the three y bits are 011 we know its a divu
                        CMPI.B  #%0011,D2
                        BEQ     DIVU
                        
                        *Check the condition that it can't be an OR
                        CMPI.B  #%0111,D2
                        BEQ     ERROROP
                        
                        
                        *Otherwise we know it is an error
                        BRA     OR
DIVUOREND
                        RTS
SHIFTSANDROT
*This subroutine will figure out if we have a special case (shift by 1) shift/rotation
*or if we have a regular case.
*xxxx xxxx yyxx xxxx
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy 
                        
                        CMPI.B  #%0011,D2   *know its a special case if the 2 y bits are 11
                        BEQ     SHIFTSANDROTSPEC
                        
                        BRA     SHIFTSANDROTREG     *otherwise its a regular case
SHIFTSANDROTSPEC                        
*determine what kind of special shift/rotation by checking bits 5,6,7,8
*xxxx yyyy xxxx xxxx
                        MOVE.W  D5,D2
                        LSL.W   #4,D2   *yyyy xxxx xxxx 0000
                        MOVE.B  #12,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy 
                        
                        *Check to special cases
                        CMPI.B  #%0001,D2   *check if ASL SPECIAL
                        BEQ     ASLSPECIAL
                        
                        CMPI.B  #%0000,D2   *check if ASR SPECIAL
                        BEQ     ASRSPECIAL
                        
                        CMPI.B  #%0011,D2   *check if LSL SPECIAL
                        BEQ     LSLSPECIAL
                        
                        CMPI.B  #%0010,D2   *check if LSR SPECIAL
                        BEQ     LSRSPECIAL
                        
                        CMPI.B  #%0111,D2   *check if ROL SPECIAL
                        BEQ     ROLSPECIAL
                        
                        CMPI.B  #%0110,D2   *check if ROR SPECIAL
                        BEQ     RORSPECIAL
                        
                        CMPI.B  #%0100,D2   *This is an error
                        BEQ     ERROROP
                        
                        CMPI.B  #%0101,D2   *This is an error
                        BEQ     ERROROP
                        
                        BRA     ERROROP     *any other case is an error
                        
SHIFTSANDROTREG
*Determine if it's a arithmetic shift or logic shift first
*xxxx xxxx xxxy yxxx
                        CLR     D2
                        MOVE.W  D5,D2
                        MOVE.B  #11,D3
                        LSL.W   D3,D2   *yyxx x000 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy 
                        
                        CMPI.B  #%0000,D2   *check if ASd
                        BEQ     ASd
                        
                        CMPI.B  #%0001,D2   *check if LSd
                        BEQ     LSd
                        
                        
                        CMPI.B  #%0011,D2      *Check if ROd
                        BEQ     ROd
                        
                        CMPI.B  #%0010,D2   *This is an error (ROXd)
                        BEQ     ERROROP
                        
                        BRA     ERROROP     *cant find opcode
ASd
*Determine direction of Arithmetic shift
*xxxx xxxy xxxx xxxx

                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        CMPI.B  #%0000,D2   *check if ASR
                        BEQ     ASR
                        
                        CMPI.B  #%0001,D2   *check if ASL
                        BEQ     ASL
                        
                        BRA ERROROP *return if bad data

LSd
*Determine direction of Logic shift
*xxxx xxxy xxxx xxxx

                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        CMPI.B  #%0000,D2   *check if LSR
                        BEQ     LSR
                        
                        CMPI.B  #%0001,D2   *check if LSL
                        BEQ     LSL
                        
                        BRA ERROROP     *return if bad data
                        
ROd
*Determine direction of Rotation
*xxxx xxxy xxxx xxxx

                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        CMPI.B  #%0000,D2   *check if ROR
                        BEQ     ROR
                        
                        CMPI.B  #%0001,D2   *check if ROL
                        BEQ     ROL
                        
                        BRA ERROROP     *return if bad data
                                                
MOVEANDMOVEA
*this subroutine will figure out if instruction is a MOVE or MOVEA
*xxxx xxxy yyxx xxxx

                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyx xxxx x000 0000
                        MOVE.B  #13,D3
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                        
                        *if the 3 y bits are 001 then we have a MOVEA
                        CMPI.B  #%0001,D2
                        BEQ     MOVEA
                        
                        *Otherwise it is a move
                        BRA     MOVE
MOVEANDMOVEAEND
                        RTS
MULTOP
*splitting operations

*compare to NOP or RTS's hex value
                        
                        CMP.W  NOP_DATA,D0
                        BEQ     NOP
                        
                        CMP.W  RTS_DATA,D0
                        BEQ     RTS
                        
*shift for JSR comparison
*yyyy yyyy yyxx xxxx

                        MOVE.W  D5,D2
                        LSR.W   #6,D2   *0000 00yy yyyy yyyy
                        
                        CMP.W  JSR_DATA,D2  *Check if these 10 bits match JSR's first 10 bits
                        BEQ     JSR

*Reach here if it's no NOP, RTS or JSR

*Check if it's a NOT
*xxxx yyyy xxxx xxxx

                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #4,D2   *yyyy xxxx xxxx 0000
                        MOVE.B  #12,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        CMPI.B  #%0110,D2   *Compare these bits to check if it is NOT
                        BEQ     NOT

*otherwise check if it's an LEA
*xxxx xxxy yyxx xxxx
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyx xxxx x000 0000
                        MOVE.B  #13,D3
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                        
                        CMPI.B  #%0111,D2   *Check these 3 bits to see if it is an LEA
                        BEQ     LEA            

*otherwise check if it's a MOVEM 
*xxxx yyyy yxxx xxxx
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #4,D2   *yyyy yxxx xxxx 0000
                        MOVE.B  #11,D3
                        LSR.W   D3,D2   *0000 0000 000y yyyy
                        
                        CMPI.W  #$0011,D2
                        BEQ     MOVEM
                        
                        CMPI.W  #$0019,D2
                        BEQ     MOVEM

                        BRA     ERROROP *opcode not found. Print error                       
BRANCHING
*Determine if BRA, BEQ, BLE, or BGT
*xxxx yyyy xxxx xxxx
                        MOVE.W  D5,D2
                        LSL.W   #4,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #12,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        CMPI.B  #%0000,D2  *determine if BRA
                        BEQ     BRA
                        
                        CMPI.B  #%0111,D2  *Determine if BEQ
                        BEQ     BEQ
                        
                        CMPI.B  #%1110,D2  *Determine if BGT
                        BEQ     BGT
                        
                        CMPI.B  #%1111,D2  *Determine if BLE
                        BEQ     BLE
                        
                        BRA     ERROROP    *Not one of the 4 branch operations we are required to do

ADDANDADDA
*Determine if this operation is ADDA or ADD
*xxxx xxxx yyxx xxxx
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                       
                        *Check these 2 bits to see if it is an ADDA
                        CMPI.B  #%0011,D2
                        BEQ     ADDA
                        
                        *Otherwise it is always an ADD
                        BRA     ADD
ADDANDADDAEND
                        RTS

MOVEQ
*First four bits are 0111
*Always a long
                        LEA     MOVEQ_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15   
                        
                        JSR     MoveqEA       *Go to EA file
                        RTS                   *Go back to IO file


ADDQ
*check that its not a subq
*xxxx xxxy xxxx xxxx
                        MOVE.W  D5,D2   *copy data over to d2 for manipulation
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3  
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        CMPI.B  #%0001,D2   *Error checking
                        BEQ     ERROROP


*First four bits are 0101
*Comes in byte (000) word (001) or long (010)
*xxxx xxxy yyxx xxxx
                        CLR     D2
                        MOVE.W  D5,D2   *copy data over to d2 for manipulation
                        LSL.W   #7,D2   *yyyx xxxx x000 0000
                        MOVE.B  #13,D3  
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                        
                        CMPI.B  #%0011,D2   *Error checking
                        BEQ     ERROROP
                        
                        LEA     ADDQ_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Addqb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Addqw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Addql
                        
                        RTS     *if for some reason we don't get a proper size
                        
ADDQEND
                        JSR     AddqEA  *Go to EA file
                        RTS     *Go to IO file
Addqb
                        JSR     BYTE
                        BRA     ADDQEND
                        
Addqw
                        JSR     WORD
                        BRA     ADDQEND
Addql
                        JSR     LONG
                        BRA     ADDQEND
SUB
*First four bits are 1001
*Comes in byte (00) word (01) or long (10)
*xxxx xxxx yyxx xxxx

                        
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        
                        *if this is a 0011 then we know its a suba and need to branch there
                        CMPI.B  #%0011,D2
                        BEQ     SUBA                        
                        
                        LEA     SUB_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Subb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Subw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Subl
                        
SUBEND
                        JSR     AddSubEA      *Go to EA File
                        RTS                *return back to IO file       
Subb
                        JSR     BYTE
                        BRA     SUBEND
                        
Subw
                        JSR     WORD
                        BRA     SUBEND
Subl
                        JSR     LONG
                        BRA     SUBEND
SUBA
*checking for suba size
*xxxx xxxy xxxx xxxx
                        LEA     SUBA_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Subaw
                        
                        CMPI.B  #%0001,D2
                        BEQ     Subal
SUBAEND
                        JSR     AddaSubaEA      *Go to EA File
                        RTS                *return back to IO file       
                        
Subaw
                        JSR     WORD
                        BRA     SUBAEND
Subal
                        JSR     LONG
                        BRA     SUBAEND

MULS
*First four bits are 1100
*Always comes as a word
                        LEA     MULS_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        BRA     Mulsw
MULSEND
                        JSR     DivuMulsEA      *Go to EA File
                        RTS                *return back to IO file       

Mulsw
                        JSR     WORD
                        BRA     MULSEND
AND
*Check that AND is not ABCD
*xxxx xxxy yyyy xxxx 
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyy yxxx x000 0000
                        MOVE.B  #11,D3
                        LSR.W   D3,D2   *0000 0000 000y yyyy
                        
                        CMPI.W  #$0010,D2
                        BEQ     ERROROP     *if it is $0010 then we have a ABCD


*First four are 1100 (same as muls)
*Comes in byte (00) word (01) or long (10)
*xxxx xxxx yyxx xxxx
                        LEA     AND_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Andb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Andw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Andl


ANDEND
                        JSR     AndOrEA      *Go to EA File
                        RTS                *return back to IO file       

Andb
                        JSR     BYTE
                        BRA     ANDEND                        
Andw
                        JSR     WORD
                        BRA     ANDEND
Andl
                        JSR     LONG
                        BRA     ANDEND

DIVU
*First four are 1000
*Always comes as a word
                        LEA     DIVU_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        BRA     Divuw
DIVUEND
                        JSR     DivuMulsEA      *Go to EA File
                        RTS                *return back to IO file       

Divuw
                        JSR     WORD
                        BRA     DIVUEND
OR
*Check that OR is not SBCD
*xxxx xxxy yyyy xxxx 
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yyyy yxxx x000 0000
                        MOVE.B  #11,D3
                        LSR.W   D3,D2   *0000 0000 000y yyyy
                        
                        CMPI.W  #$0010,D2
                        BEQ     ERROROP *If we have $0010 then it is an SBCD
                        
*First four are 1000 (same as divu)
*Comes in byte (00) word (01) or long (10)
*xxxx xxxx yyxx xxxx
                        LEA     OR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Orb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Orw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Orl


OREND
                        JSR     AndOrEA      *Go to EA File
                        RTS                *return back to IO file       

Orb
                        JSR     BYTE
                        BRA     OREND                        
Orw
                        JSR     WORD
                        BRA     OREND
Orl
                        JSR     LONG
                        BRA     OREND

MOVE
*First two digits are 00
*Comes in byte (01) word (11) or long (10)
*xxyy xxxx xxxx xxxx
                        LEA     MOVE_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #2,D2   *yyxx xxxx xxxx xx00
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        *check what kind of data size
                        CMPI.B  #%0001,D2
                        BEQ     Moveb
                        
                        CMPI.B  #%0011,D2
                        BEQ     Movew
                        
                        CMPI.B  #%0010,D2
                        BEQ     Movel
                                               
MOVEEND
                        JSR     MoveEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
Moveb
                        JSR     BYTE
                        BRA     MOVEEND
Movew
                        JSR     WORD
                        BRA     MOVEEND
Movel
                        JSR     LONG
                        BRA     MOVEEND
MOVEA
*First two digits are 00
*Comes in word (11) or long (10)
                        LEA     MOVEA_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #2,D2   *yyxx xxxx xxxx xx00
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        *check what kind of data size
                        CMPI.B  #%0011,D2
                        BEQ     Moveaw
                        
                        CMPI.B  #%0010,D2
                        BEQ     moveal
                        
MOVEAEND
                        JSR     MoveaEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
Moveaw
                        JSR     WORD
                        BRA     MOVEAEND
Moveal
                        JSR     LONG
                        BRA     MOVEAEND
LEA
*First four digits are 0100
                        LEA     LEA_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     LeaEA   *go to EA file
                        RTS     *Go back to IO file
NOT
*First four digits are 0100 
*Comes in byte (00) word (01) or long (10)
*xxxx xxxx yyxx xxxx
                                               
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        CMPI.B  #%0011,D2   *Move to SR so we print error
                        BEQ     ERROROP
                        
                        LEA     NOT_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Notb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Notw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Notl

NOTEND
                        JSR     NotEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
Notb
                        JSR     BYTE
                        BRA     NOTEND
Notw
                        JSR     WORD
                        BRA     NOTEND
Notl
                        JSR     LONG
                        BRA     NOTEND
JSR
*First four digits are 0100
*Distinct signature
                        LEA     JSR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     JsrEA       *Jump to EA file
                        RTS                 *Return to IO file
RTS
*First four digits are 0100
*Distinct signature
                        LEA     RTS_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        RTS
NOP
*First four digits are 0100
*Distinct signature
                        LEA     NOP_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        RTS
MOVEM
*Check that MOVEM is not a EXT
*xxxx xxxx xxyy yxxx

                        CLR     D2
                        MOVE.W  D5,D2
                        MOVE.B  #10,D3
                        LSL.W   D3,D2   *yyyx xx00 0000 0000
                        MOVE.B  #13,D3
                        LSR.W   D3,D2   *0000 0000 0000 0yyy
                        
                        CMPI.B  #%0000,D2
                        BEQ     ERROROP     *if these 3 bits are 000 then it is a EXT


*First four digits are 0100
*Takes in word (0) or long (1)
*xxxx xxxx xyxx xxxx
                        LEA     MOVEM_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        MOVE.B  #9,D3
                        LSL.W   D3,D2   *yxxx xxx0 0000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Movemw
                        
                        CMPI.B  #%0001,D2
                        BEQ     Moveml
                        
MOVEMEND
                        JSR     MovemEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
Movemw
                        JSR     WORD
                        BRA     MOVEMEND
                        
Moveml
                        JSR     LONG
                        BRA     MOVEMEND
BRA
*First four digits are 0110
                        LEA     BRA_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     BranchEA    *Jump to EA File
                        RTS                 *Return to IO file
BGT
*First four digits are 0110
                        LEA     BGT_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     BranchEA    *Jump to EA File
                        RTS                 *Return to IO file
BLE
*First four digits are 0110
                        LEA     BLE_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     BranchEA    *Jump to EA File
                        RTS                 *Return to IO file
BEQ
*First four digits are 0110
                        LEA     BEQ_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        JSR     BranchEA    *Jump to EA File
                        RTS                 *Return to IO File
LSL
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     LSL_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS         *returns here if data is bad. RTS is handled within the data size
LSR
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     LSR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS         *returns here if data is bad. RTS is handled within the data size
ASL
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     ASL_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS         *returns here if data is bad. RTS is handled within the data size
ASR
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     ASR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS         *returns here if data is bad. RTS is handled within the data size
ROR
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     ROR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS         *returns here if data is bad. RTS is handled within the data size
ROL
*Takes in a byte (00) a word (01) or a long (10)
*xxxx xxxx yyxx xxxx
                        LEA     ROR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyyy xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 yyyy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     ShiftRotb
                        
                        CMPI.B  #%0001,D2
                        BEQ     ShiftRotw
                        
                        CMPI.B  #%0010,D2
                        BEQ     ShiftRotl
                        
                        RTS     *in case error happens with size
                        
SHIFTROTREGEND
                        JSR     ShiftRotEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
ShiftRotb
                        JSR     BYTE
                        BRA     SHIFTROTREGEND
                        
ShiftRotw
                        JSR     WORD
                        BRA     SHIFTROTREGEND
                        
ShiftRotl
                        JSR     LONG
                        BRA     SHIFTROTREGEND
                        
ASLSPECIAL
                        LEA     ASL_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
ASRSPECIAL
                        LEA     ASR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
LSLSPECIAL
                        LEA     LSL_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
LSRSPECIAL
                        LEA     LSR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
ROLSPECIAL
                        LEA     ROL_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
RORSPECIAL
                        LEA     ROR_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        BRA     ShiftRotSpecialw    *Size is always a word
SHIFTROTSPECEND
                        JSR     ShiftRotSpecialEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
                        
ShiftRotSpecialw
                        JSR     WORD
                        BRA     SHIFTROTSPECEND
                        
ADD
*First four digits are 1101
*Takes in byte (00) word (01) or long (10)
*xxxx xxxx yyxx xxxx

                        LEA     ADD_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #8,D2   *yyxx xxxx 0000 0000
                        MOVE.B  #14,D3
                        LSR.W   D3,D2   *0000 0000 0000 00yy
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Addb
                        
                        CMPI.B  #%0001,D2
                        BEQ     Addw
                        
                        CMPI.B  #%0010,D2
                        BEQ     Addl
 
ADDEND
                        JSR     AddSubEA      *Go to EA File
                        RTS                *return back to IO file       
Addb
                        JSR     BYTE
                        BRA     ADDEND
                        
Addw
                        JSR     WORD
                        BRA     ADDEND
Addl
                        JSR     LONG
                        BRA     ADDEND
                        
ADDA  
*First four digits are 1101
*Takes in) word (0) or long (1)
*xxxx xxxy xxxx xxxx
                        LEA     ADDA_MSG,A1  *Print op code
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        CLR     D2
                        MOVE.W  D5,D2
                        LSL.W   #7,D2   *yxxx xxxx x000 0000
                        MOVE.B  #15,D3
                        LSR.W   D3,D2   *0000 0000 0000 000y
                        
                        *check what kind of data size
                        CMPI.B  #%0000,D2
                        BEQ     Addaw
                        
                        CMPI.B  #%0001,D2
                        BEQ     Addal
                        
ADDAEND
                        JSR     AddaSubaEA      *Go to EA File
                        RTS                 *return back to IO file       
                        
Addaw
                        JSR     WORD
                        BRA     ADDAEND
Addal
                        JSR     LONG
                        BRA     ADDAEND
BYTE
                        LEA     BYTE_MSG,A1  *Print data type
                        MOVE.B  #14,D0
                        TRAP    #15
                        MOVE.B  #%0000,D7   *ensure we get zeros passed in for size for immediate value tracker.
                        
                        RTS
WORD
                        LEA     WORD_MSG,A1  *Print data type
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.B  #%0010,D7 *Manipulate our size tracker for immediate value
                        RTS
LONG
                        LEA     LONG_MSG,A1  *Print data type
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.B  #%0001,D7 *Manipulate our size tracker for immediate value
                        RTS
ERROROP
                        LEA     ERROR_MSG,A1
                        MOVE.W  #14,D0
                        TRAP    #15
                        
                        *print data for invalid op code
                        LEA     USER_INPT,A1
                        MOVE.B  #15,D0
                        MOVE.W  D5,D1
                        MOVE.B  #16,D2
                        TRAP    #15 
                        CLR.L   D5
                        
                        RTS
SIZEMESS
                        LEA     SIZE_ERR,A1  *Print out that there is an invalid size
                        MOVE.B  #14,D0
                        TRAP    #15
                        RTS
WAITFORINPUT
                        LEA     ENTER_MSG,A1  *Print out that there is an invalid size
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        LEA     USER_INPT,A1    *so we don't replace enter message
                        MOVE.B  #2,D0        *Use trap task 2 to read in a string from keyboard
                        TRAP    #15
                        
                        RTS 

* Put variables and constants here
SIZE_ERR  DC.B    'Invalid input. Address must be an even address. Try again',0
ENTER_MSG  DC.B    'Press "enter" to see the next 24 lines',0
ERROR_MSG DC.B    ' DATA $',0
MOVEQ_MSG DC.B    ' MOVEQ ',0
ADDQ_MSG  DC.B    ' ADDQ',0
SUB_MSG   DC.B    ' SUB',0
SUBA_MSG   DC.B   ' SUBA',0
MULS_MSG  DC.B    ' MULS',0
AND_MSG   DC.B    ' AND',0
DIVU_MSG  DC.B    ' DIVU',0
OR_MSG    DC.B    ' OR',0
MOVE_MSG  DC.B    ' MOVE',0
MOVEA_MSG DC.B    ' MOVEA',0
LEA_MSG   DC.B    ' LEA ',0
NOT_MSG   DC.B    ' NOT',0
JSR_MSG   DC.B    ' JSR ',0
RTS_MSG   DC.B    ' RTS',0
NOP_MSG   DC.B    ' NOP',0
MOVEM_MSG DC.B    ' MOVEM',0
BRA_MSG   DC.B    ' BRA ',0
LSL_MSG   DC.B    ' LSL',0
LSR_MSG   DC.B    ' LSR',0
ASL_MSG   DC.B    ' ASL',0
ASR_MSG   DC.B    ' ASR',0
ROL_MSG   DC.B    ' ROR',0
ROR_MSG   DC.B    ' ROL',0
ADD_MSG   DC.B    ' ADD',0
ADDA_MSG  DC.B    ' ADDA',0
BGT_MSG   DC.B    ' BGT ',0
BLE_MSG   DC.B    ' BLE ',0
BEQ_MSG   DC.B    ' BEQ ',0
BYTE_MSG  DC.B    '.B ',0
LONG_MSG  DC.B    '.L ',0
WORD_MSG  DC.B    '.W ',0
NOP_DATA  DC.W    $4E71
RTS_DATA  DC.W    $4E75
JSR_DATA  DC.W    $013A
USER_INPT DS.L    1





























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
