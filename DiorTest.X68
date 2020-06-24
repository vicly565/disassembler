*-----------------------------------------------------------
* Title      : CSS 422 Disassembler Demo Test
* Written by : Victor Ly, Jay Brar, Ahmed Elwalid
* Date       : 5/22
* Description: This file is the demo test Diorfanclub made for the disassembler
*-----------------------------------------------------------
    ORG    $7000
START:

    ORI.B   #%00000011,(A0)+   *UNSUPPORTED OPCODES
    ANDI.B  #$F0,(A2)+
    SUBI.B  #$F,D0
    BGE     BRANCH2
    ADDI.B  #$F,D4  
    EORI.W  #$F,D5
    CMPI.W   #1,D7
    BLT     BRANCH1
    BLS     BRANCH3

    MOVE.L  A3,(2,A3)   *UNSUPPORTED EAS
    AND.W   D3,(3,A4)
    ASL.W   (2,A2)
    ADD.L   (2,A3),A3
    LEA     (2,A6),A1
    MOVEA.L (1,A0),A1
    OR.W    (2,A3),D3
    OR.L    D3,(2,A3)
    SUB.W   (2,A3),D3
    SUB.L   D3,(2,A3)
    ADD.W   (2,A3),D3
    ADD.L   D3,(2,A3)


    NOP   *TESTING NOPS
    NOP
    NOP
    
BRANCH1
    MOVE.B  D1,D3   *TESTING MOVES   
    MOVE.B  D5,(A4)
    MOVE.B  D6,-(A0)
    MOVE.B  D1,(A4)+
    MOVE.B  D2,$4567
    MOVE.B  D6,$1234567    
    MOVE.B  (A4),D3
    MOVE.B  (A5),(A6)
    MOVE.B  (A7),-(A0)
    MOVE.B  (A1),(A2)+
    MOVE.B  (A3),$4567
    MOVE.B  (A0),$1234567
    MOVE.B  -(A4),D3
    MOVE.B  -(A5),(A6)
    MOVE.B  -(A7),-(A0)
    MOVE.B  -(A1),(A2)+
    MOVE.B  -(A3),$4567
    MOVE.B  -(A0),$1234567
    MOVE.B  (A4)+,D3
    MOVE.B  (A5)+,(A6)
    MOVE.B  (A7)+,-(A0)
    MOVE.B  (A1)+,(A2)+
    MOVE.B  (A3)+,$4567
    MOVE.B  (A0)+,$1234567
    MOVE.B  $123,D3
    MOVE.B  $123,(A6)
    MOVE.B  $123,-(A0)
    MOVE.B  $123,(A2)+
    MOVE.B  $123,$4567
    MOVE.B  $123,$1234567
    MOVE.B  $1234567,D3
    MOVE.B  $1234567,(A6)
    MOVE.B  $1234567,-(A0)
    MOVE.B  $1234567,(A2)+
    MOVE.B  $1234567,$4567
    MOVE.B  $1234567,$1234567
    MOVE.B  #$1,D3
    MOVE.B  #$1,(A6)
    MOVE.B  #$1,-(A0)
    MOVE.B  #$1,(A2)+
    MOVE.B  #$1,$4567
    MOVE.B  #$1,$1234567

    MOVE.W  A4,D3
    MOVE.W  A5,(A6)
    MOVE.W  A7,-(A0)
    MOVE.W  A1,(A2)+
    MOVE.W  A3,$4567
    MOVE.W  A0,$1234567
    MOVE.W  D4,D3
    MOVE.W  D5,(A6)
    MOVE.W  D7,-(A0)
    MOVE.W  D1,(A2)+
    MOVE.W  D3,$4567
    MOVE.W  D0,$1234567    
    MOVE.W  (A4),D3
    MOVE.W  (A5),(A6)
    MOVE.W  (A7),-(A0)
    MOVE.W  (A1),(A2)+
    MOVE.W  (A3),$4567
    MOVE.W  (A0),$1234567
    MOVE.W  -(A4),D3
    MOVE.W  -(A5),(A6)
    MOVE.W  -(A7),-(A0)
    MOVE.W  -(A1),(A2)+
    MOVE.W  -(A3),$4567
    MOVE.W  -(A0),$1234567
    MOVE.W  (A4)+,D3
    MOVE.W  (A5)+,(A6)
    MOVE.W  (A7)+,-(A0)
    MOVE.W  (A1)+,(A2)+
    MOVE.W  (A3)+,$4567
    MOVE.W  (A0)+,$1234567
    MOVE.W  $123,D3
    MOVE.W  $123,(A6)
    MOVE.W  $123,-(A0)
    MOVE.W  $123,(A2)+
    MOVE.W  $123,$4567
    MOVE.W  $123,$1234567   
    MOVE.W  $1234567,D3
    MOVE.W  $1234567,(A6)
    MOVE.W  $1234567,-(A0)
    MOVE.W  $1234567,(A2)+
    MOVE.W  $1234567,$4567
    MOVE.W  $1234567,$1234567
    MOVE.W  #$123,D3
    MOVE.W  #$123,(A6)
    MOVE.W  #$123,-(A0)
    MOVE.W  #$123,(A2)+
    MOVE.W  #$123,$4567
    MOVE.W  #$123,$1234567

    MOVE.L  A4,D3
    MOVE.L  A5,(A6)
    MOVE.L  A7,-(A0)
    MOVE.L  A1,(A2)+
    MOVE.L  A3,$4567
    MOVE.L  A0,$1234567
    MOVE.L  D4,D3
    MOVE.L  D5,(A6)
    MOVE.L  D7,-(A0)
    MOVE.L  D1,(A2)+
    MOVE.L  D3,$4567
    MOVE.L  D0,$1234567  
    MOVE.L  (A4),D3
    MOVE.L  (A5),(A6)
    MOVE.L  (A7),-(A0)
    MOVE.L  (A1),(A2)+
    MOVE.L  (A3),$4567
    MOVE.L  (A0),$1234567
    MOVE.L  -(A4),D3
    MOVE.L  -(A5),(A6)
    MOVE.L  -(A7),-(A0)
    MOVE.L  -(A1),(A2)+
    MOVE.L  -(A3),$4567
    MOVE.L  -(A0),$1234567
    MOVE.L  (A4)+,D3
    MOVE.L  (A5)+,(A6)
    MOVE.L  (A7)+,-(A0)
    MOVE.L  (A1)+,(A2)+
    MOVE.L  (A3)+,$4567
    MOVE.L  (A0)+,$1234567
    MOVE.L  $123,D3
    MOVE.L  $123,(A6)
    MOVE.L  $123,-(A0)
    MOVE.L  $123,(A2)+
    MOVE.L  $123,$4567
    MOVE.L  $123,$1234567    
    MOVE.L  $1234567,D3
    MOVE.L  $1234567,(A6)
    MOVE.L  $1234567,-(A0)
    MOVE.L  $1234567,(A2)+
    MOVE.L  $1234567,$4567
    MOVE.L  $1234567,$1234567
    MOVE.L  #$1234567,D3
    MOVE.L  #$1234567,(A6)
    MOVE.L  #$1234567,-(A0)
    MOVE.L  #$1234567,(A2)+
    MOVE.L  #$1234567,$4567
    MOVE.L  #$1234567,$1234567


    MOVEQ   #0,D1   *TESTING MOVEQS
    MOVEQ   #$23,D4
    MOVEQ   #56,D7
    MOVEQ   #$FF,D0
    MOVEQ   #255,D1


    MOVEM.W (A1),D0-D7/A0-A7   *TESTING MOVEMS
    MOVEM.W (A1),D0-D7
    MOVEM.W (A1),A0-A7
    MOVEM.W (A1),D0/A0
    MOVEM.W (A1),D0
    MOVEM.W (A1),A0
    MOVEM.W (A1),D0/D2-D3/A0/A2-A3
    MOVEM.W (A1),D0-D1/D3-D4/D6-D7
    MOVEM.W (A1),A0-A1/A3-A4/A6-A7
    MOVEM.W (A1),D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.W (A1),D0/D2/D4/D6
    MOVEM.W (A1),A0/A2/A4/A6
    MOVEM.W (A1),D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.W (A1)+,D0-D7/A0-A7
    MOVEM.W (A1)+,D0-D7
    MOVEM.W (A1)+,A0-A7
    MOVEM.W (A1)+,D0/A0
    MOVEM.W (A1)+,D0
    MOVEM.W (A1)+,A0
    MOVEM.W (A1)+,D0/D2-D3/A0/A2-A3
    MOVEM.W (A1)+,D0-D1/D3-D4/D6-D7
    MOVEM.W (A1)+,A0-A1/A3-A4/A6-A7
    MOVEM.W (A1)+,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.W (A1)+,D0/D2/D4/D6
    MOVEM.W (A1)+,A0/A2/A4/A6
    MOVEM.W (A1)+,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.W $2000,D0-D7/A0-A7
    MOVEM.W $2000,D0-D7
    MOVEM.W $2000,A0-A7
    MOVEM.W $2000,D0/A0
    MOVEM.W $2000,D0
    MOVEM.W $2000,A0
    MOVEM.W $2000,D0/D2-D3/A0/A2-A3
    MOVEM.W $2000,D0-D1/D3-D4/D6-D7
    MOVEM.W $2000,A0-A1/A3-A4/A6-A7
    MOVEM.W $2000,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.W $2000,D0/D2/D4/D6
    MOVEM.W $2000,A0/A2/A4/A6
    MOVEM.W $2000,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.W $20000000,D0-D7/A0-A7
    MOVEM.W $20000000,D0-D7
    MOVEM.W $20000000,A0-A7
    MOVEM.W $20000000,D0/A0
    MOVEM.W $20000000,D0
    MOVEM.W $20000000,A0
    MOVEM.W $20000000,D0/D2-D3/A0/A2-A3
    MOVEM.W $20000000,D0-D1/D3-D4/D6-D7
    MOVEM.W $20000000,A0-A1/A3-A4/A6-A7
    MOVEM.W $20000000,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.W $20000000,D0/D2/D4/D6
    MOVEM.W $20000000,A0/A2/A4/A6
    MOVEM.W $20000000,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.W D0-D7/A0-A7,(A1)
    MOVEM.W D0-D7,(A1)
    MOVEM.W A0-A7,(A1)
    MOVEM.W D0/A0,(A1)
    MOVEM.W D0,(A1)
    MOVEM.W A0,(A1)
    MOVEM.W D0/D2-D3/A0/A2-A3,(A1)
    MOVEM.W D0-D1/D3-D4/D6-D7,(A1)
    MOVEM.W A0-A1/A3-A4/A6-A7,(A1)
    MOVEM.W D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,(A1)
    MOVEM.W D0/D2/D4/D6,(A1)
    MOVEM.W A0/A2/A4/A6,(A1)
    MOVEM.W D0/D2/D4/D6/A0/A2/A4/A6,(A1)
    MOVEM.W D0-D7/A0-A7,-(A1)
    MOVEM.W D0-D7,-(A1)
    MOVEM.W A0-A7,-(A1)
    MOVEM.W D0/A0,-(A1)
    MOVEM.W D0,-(A1)
    MOVEM.W A0,-(A1)
    MOVEM.W D0/D2-D3/A0/A2-A3,-(A1)
    MOVEM.W D0-D1/D3-D4/D6-D7,-(A1)
    MOVEM.W A0-A1/A3-A4/A6-A7,-(A1)
    MOVEM.W D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,-(A1)
    MOVEM.W D0/D2/D4/D6,-(A1)
    MOVEM.W A0/A2/A4/A6,-(A1)
    MOVEM.W D0/D2/D4/D6/A0/A2/A4/A6,-(A1)
    MOVEM.W D0-D7/A0-A7,$2000
    MOVEM.W D0-D7,$2000
    MOVEM.W A0-A7,$2000
    MOVEM.W D0/A0,$2000
    MOVEM.W D0,$2000
    MOVEM.W A0,$2000
    MOVEM.W D0/D2-D3/A0/A2-A3,$2000
    MOVEM.W D0-D1/D3-D4/D6-D7,$2000
    MOVEM.W A0-A1/A3-A4/A6-A7,$2000
    MOVEM.W D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,$2000
    MOVEM.W D0/D2/D4/D6,$2000
    MOVEM.W A0/A2/A4/A6,$2000
    MOVEM.W D0/D2/D4/D6/A0/A2/A4/A6,$2000
    MOVEM.W D0-D7/A0-A7,$20000000
    MOVEM.W D0-D7,$20000000
    MOVEM.W A0-A7,$20000000
    MOVEM.W D0/A0,$20000000
    MOVEM.W D0,$20000000
    MOVEM.W A0,$20000000
    MOVEM.W D0/D2-D3/A0/A2-A3,$20000000
    MOVEM.W D0-D1/D3-D4/D6-D7,$20000000
    MOVEM.W A0-A1/A3-A4/A6-A7,$20000000
    MOVEM.W D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,$20000000
    MOVEM.W D0/D2/D4/D6,$20000000
    MOVEM.W A0/A2/A4/A6,$20000000
    MOVEM.W D0/D2/D4/D6/A0/A2/A4/A6,$20000000

    MOVEM.L (A1),D0-D7/A0-A7
    MOVEM.L (A1),D0-D7
    MOVEM.L (A1),A0-A7
    MOVEM.L (A1),D0/A0
    MOVEM.L (A1),D0
    MOVEM.L (A1),A0
    MOVEM.L (A1),D0/D2-D3/A0/A2-A3
    MOVEM.L (A1),D0-D1/D3-D4/D6-D7
    MOVEM.L (A1),A0-A1/A3-A4/A6-A7
    MOVEM.L (A1),D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.L (A1),D0/D2/D4/D6
    MOVEM.L (A1),A0/A2/A4/A6
    MOVEM.L (A1),D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.L (A1)+,D0-D7/A0-A7
    MOVEM.L (A1)+,D0-D7
    MOVEM.L (A1)+,A0-A7
    MOVEM.L (A1)+,D0/A0
    MOVEM.L (A1)+,D0
    MOVEM.L (A1)+,A0
    MOVEM.L (A1)+,D0/D2-D3/A0/A2-A3
    MOVEM.L (A1)+,D0-D1/D3-D4/D6-D7
    MOVEM.L (A1)+,A0-A1/A3-A4/A6-A7
    MOVEM.L (A1)+,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.L (A1)+,D0/D2/D4/D6
    MOVEM.L (A1)+,A0/A2/A4/A6
    MOVEM.L (A1)+,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.L $2000,D0-D7/A0-A7
    MOVEM.L $2000,D0-D7
    MOVEM.L $2000,A0-A7
    MOVEM.L $2000,D0/A0
    MOVEM.L $2000,D0
    MOVEM.L $2000,A0
    MOVEM.L $2000,D0/D2-D3/A0/A2-A3
    MOVEM.L $2000,D0-D1/D3-D4/D6-D7
    MOVEM.L $2000,A0-A1/A3-A4/A6-A7
    MOVEM.L $2000,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.L $2000,D0/D2/D4/D6
    MOVEM.L $2000,A0/A2/A4/A6
    MOVEM.L $2000,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.L $20000000,D0-D7/A0-A7
    MOVEM.L $20000000,D0-D7
    MOVEM.L $20000000,A0-A7
    MOVEM.L $20000000,D0/A0
    MOVEM.L $20000000,D0
    MOVEM.L $20000000,A0
    MOVEM.L $20000000,D0/D2-D3/A0/A2-A3
    MOVEM.L $20000000,D0-D1/D3-D4/D6-D7
    MOVEM.L $20000000,A0-A1/A3-A4/A6-A7
    MOVEM.L $20000000,D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7
    MOVEM.L $20000000,D0/D2/D4/D6
    MOVEM.L $20000000,A0/A2/A4/A6
    MOVEM.L $20000000,D0/D2/D4/D6/A0/A2/A4/A6
    MOVEM.L D0-D7/A0-A7,(A1)
    MOVEM.L D0-D7,(A1)
    MOVEM.L A0-A7,(A1)
    MOVEM.L D0/A0,(A1)
    MOVEM.L D0,(A1)
    MOVEM.L A0,(A1)
    MOVEM.L D0/D2-D3/A0/A2-A3,(A1)
    MOVEM.L D0-D1/D3-D4/D6-D7,(A1)
    MOVEM.L A0-A1/A3-A4/A6-A7,(A1)
    MOVEM.L D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,(A1)
    MOVEM.L D0/D2/D4/D6,(A1)
    MOVEM.L A0/A2/A4/A6,(A1)
    MOVEM.L D0/D2/D4/D6/A0/A2/A4/A6,(A1)
    MOVEM.L D0-D7/A0-A7,-(A1)
    MOVEM.L D0-D7,-(A1)
    MOVEM.L A0-A7,-(A1)
    MOVEM.L D0/A0,-(A1)
    MOVEM.L D0,-(A1)
    MOVEM.L A0,-(A1)
    MOVEM.L D0/D2-D3/A0/A2-A3,-(A1)
    MOVEM.L D0-D1/D3-D4/D6-D7,-(A1)
    MOVEM.L A0-A1/A3-A4/A6-A7,-(A1)
    MOVEM.L D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,-(A1)
    MOVEM.L D0/D2/D4/D6,-(A1)
    MOVEM.L A0/A2/A4/A6,-(A1)
    MOVEM.L D0/D2/D4/D6/A0/A2/A4/A6,-(A1)
    MOVEM.L D0-D7/A0-A7,$2000
    MOVEM.L D0-D7,$2000
    MOVEM.L A0-A7,$2000
    MOVEM.L D0/A0,$2000
    MOVEM.L D0,$2000
    MOVEM.L A0,$2000
    MOVEM.L D0/D2-D3/A0/A2-A3,$2000
    MOVEM.L D0-D1/D3-D4/D6-D7,$2000
    MOVEM.L A0-A1/A3-A4/A6-A7,$2000
    MOVEM.L D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,$2000
    MOVEM.L D0/D2/D4/D6,$2000
    MOVEM.L A0/A2/A4/A6,$2000
    MOVEM.L D0/D2/D4/D6/A0/A2/A4/A6,$2000
    MOVEM.L D0-D7/A0-A7,$20000000
    MOVEM.L D0-D7,$20000000
    MOVEM.L A0-A7,$20000000
    MOVEM.L D0/A0,$20000000
    MOVEM.L D0,$20000000
    MOVEM.L A0,$20000000
    MOVEM.L D0/D2-D3/A0/A2-A3,$20000000
    MOVEM.L D0-D1/D3-D4/D6-D7,$20000000
    MOVEM.L A0-A1/A3-A4/A6-A7,$20000000
    MOVEM.L D0-D1/D3-D4/D6-D7/A0-A1/A3-A4/A6-A7,$20000000
    MOVEM.L D0/D2/D4/D6,$20000000
    MOVEM.L A0/A2/A4/A6,$20000000
    MOVEM.L D0/D2/D4/D6/A0/A2/A4/A6,$20000000


    MOVEA.W A1,A2   *TESTING MOVEAS
    MOVEA.W D3,A4
    MOVEA.W (A5),A6
    MOVEA.W -(A7),A0
    MOVEA.W (A1)+,A2
    MOVEA.W $3456,A7
    MOVEA.W $01234567,A0

    MOVEA.L A1,A2   
    MOVEA.L D3,A4
    MOVEA.L (A5),A6
    MOVEA.L -(A7),A0
    MOVEA.L (A1)+,A2
    MOVEA.L $3456,A7
    MOVEA.L $01234567,A0


    ADD.B    D2,D1   *TESTING ADDS
    ADD.B    D3,D4
    ADD.B    (A5),D6
    ADD.B    -(A7),D0
    ADD.B    (A1)+,D2
    ADD.B    $3456,D7
    ADD.B    $1234567,D0

    ADD.W    D2,D1
    ADD.W    D3,D4
    ADD.W    (A5),D6
    ADD.W    -(A7),D0
    ADD.W    (A1)+,D2
    ADD.W    $3456,D7
    ADD.W    $1234567,D0
    
    ADD.L    D2,D1
    ADD.L    D3,D4
    ADD.L    (A5),D6
    ADD.L    -(A7),D0
    ADD.L    (A1)+,D2
    ADD.L    $3456,D7
    ADD.L    $1234567,D0


    ADDA.W  #$2000,A2   *TESTING ADDAS
    ADDA.W  #$20,A2
    ADDA.W  $2000,A2
    ADDA.W  $20000000,A2
    ADDA.W  #2000,A2
    ADDA.W  D0,A2
    ADDA.W  (A0),A2
    ADDA.W  -(A0),A2
    ADDA.W  (A0)+,A2

    ADDA.L  #$2000,A2
    ADDA.L  #$20,A2
    ADDA.L  $2000,A2
    ADDA.L  $20000000,A2
    ADDA.L  #2000,A2
    ADDA.L  D0,A2
    ADDA.L  (A0),A2
    ADDA.L  -(A0),A2
    ADDA.L  (A0)+,A2


    ADDQ.B  #2,D3   *TESTING ADDQs
    ADDQ.B  #4,(A5)
    ADDQ.B  #6,-(A7)
    ADDQ.B  #1,(A1)+
    ADDQ.B  #2,$3456
    ADDQ.B  #7,$1234567
 
    ADDQ.W  #1,A1
    ADDQ.W  #2,D3
    ADDQ.W  #4,(A5)
    ADDQ.W  #6,-(A7)
    ADDQ.W  #1,(A1)+
    ADDQ.W  #2,$3456
    ADDQ.W  #7,$1234567

    ADDQ.L  #1,A1   
    ADDQ.L  #2,D3
    ADDQ.L  #4,(A5)
    ADDQ.L  #6,-(A7)
    ADDQ.L  #1,(A1)+
    ADDQ.L  #2,$3456
    ADDQ.L  #7,$1234567


    SUB.B   D2,D1
    SUB.B   D3,D4
    SUB.B   (A5),D6
    SUB.B   -(A7),D0
    SUB.B   (A1)+,D2
    SUB.B   $3456,D7
    SUB.B   $1234567,D0

    SUB.W   D2,D1
    SUB.W   D3,D4
    SUB.W   (A5),D6
    SUB.W   -(A7),D0
    SUB.W   (A1)+,D2
    SUB.W   $3456,D7
    SUB.W   $1234567,D0

    SUB.L   D2,D1
    SUB.L   D3,D4
    SUB.L   (A5),D6
    SUB.L   -(A7),D0
    SUB.L   (A1)+,D2
    SUB.L   $3456,D7
    SUB.L   $1234567,D0


    LEA     (A4),A0   *TESTING LEAS
    LEA     $2468,A4
    LEA     $1234567,A3


    AND.B    D2,D1   *TESTING ANDS
    AND.B    D3,D4
    AND.B    (A5),D6
    AND.B    -(A7),D0
    AND.B    (A1)+,D2
    AND.B    $3456,D7
    AND.B    $01234567,D0
    AND.B    #123,D4
    AND.B    #$12,D4
    AND.B    #123,D0
    AND.B    #$87,D0

    AND.W    D2,D1
    AND.W    D3,D4
    AND.W    (A5),D6
    AND.W    -(A7),D0
    AND.W    (A1)+,D2
    AND.W    $3456,D7
    AND.W    $01234567,D0
    AND.W    #123,D4
    AND.W    #$123,D4
    AND.W    #12345,D0
    AND.W    #$4567,D0

    AND.L    D2,D1
    AND.L    D3,D4
    AND.L    (A5),D6
    AND.L    -(A7),D0
    AND.L    (A1)+,D2
    AND.L    $3456,D7
    AND.L    $01234567,D0
    AND.L    #123,D4
    AND.L    #$123,D4
    AND.L    #12345,D0
    AND.L    #$4567,D0


    OR.B    D2,D1   *TESTING ORS
    OR.B    D3,D4
    OR.B    (A5),D6
    OR.B    -(A7),D0
    OR.B    (A1)+,D2
    OR.B    $3456,D7
    OR.B    $01234567,D0
    OR.B    #123,D4
    OR.B    #$12,D4
    OR.B    #123,D0
    OR.B    #$87,D0    

    OR.W    D2,D1
    OR.W    D3,D4
    OR.W    (A5),D6
    OR.W    -(A7),D0
    OR.W    (A1)+,D2
    OR.W    $3456,D7
    OR.W    $01234567,D0
    OR.W    #123,D4
    OR.W    #$123,D4
    OR.W    #12345,D0
    OR.W    #$4567,D0  

    OR.L    D2,D1
    OR.L    D3,D4
    OR.L    (A5),D6
    OR.L    -(A7),D0
    OR.L    (A1)+,D2
    OR.L    $3456,D7
    OR.L    $01234567,D0
    OR.L    #123,D4
    OR.L    #$123,D4
    OR.L    #12345,D0
    OR.L    #$4567,D0   

   
    NOT.W   D1  *TESTING NOTS
    NOT.W   (A2)
    NOT.W   -(A3)
    NOT.W   (A4)+
    NOT.W   $4567
    NOT.W   $1234567

    NOT.L   D1
    NOT.L   (A2)
    NOT.L   -(A3)
    NOT.L   (A4)+
    NOT.L   $4567
    NOT.L   $01234567


    LSL     $00002000   *TESTING LSLS
    LSL     $2000
    LSL     (A2)
    LSL     (A2)+
    LSL     -(A2)
  
    LSL.B   #1,D0
    LSL.B   D0,D1
    LSL.B   #1,D0
    LSL.B   D0,D1

    LSL.W   #1,D0
    LSL.W   D0,D1
    LSL.W   #1,D0
    LSL.W   D0,D1

    LSL.L   #1,D0
    LSL.L   D0,D1
    LSL.L   #1,D0
    LSL.L   D0,D1           


    LSR     $00002000   *TESTING LSRS
    LSR     $2000
    LSR     (A2)
    LSR     (A2)+
    LSR     -(A2)
  
    LSR.B   #1,D0
    LSR.B   D0,D1
    LSR.B   #1,D0
    LSR.B   D0,D1

    LSR.W   #1,D0
    LSR.W   D0,D1
    LSR.W   #1,D0
    LSR.W   D0,D1

    LSR.L   #1,D0
    LSR.L   D0,D1
    LSR.L   #1,D0
    LSR.L   D0,D1
 

    ASL     $00002000   *TESTING ASLS
    ASL     $2000
    ASL     (A2)
    ASL     (A2)+
    ASL     -(A2)    
    
    ASL.B   #1,D0
    ASL.B   D0,D1
    ASL.B   #1,D0
    ASL.B   D0,D1

    ASL.W   #1,D0
    ASL.W   D0,D1
    ASL.W   #1,D0
    ASL.W   D0,D1

    ASL.L   #1,D0
    ASL.L   D0,D1
    ASL.L   #1,D0
    ASL.L   D0,D1


    ASR     $00002000   *TESTING ASRS
    ASR     $2000
    ASR     (A2)
    ASR     (A2)+
    ASR     -(A2)    
    
    ASR.B   #1,D0
    ASR.B   D0,D1
    ASR.B   #1,D0
    ASR.B   D0,D1

    ASR.W   #1,D0
    ASR.W   D0,D1
    ASR.W   #1,D0
    ASR.W   D0,D1

    ASR.L   #1,D0
    ASR.L   D0,D1
    ASR.L   #1,D0
    ASR.L   D0,D1
  
BRANCH2
    ROL     $00002000   *TESTING ROLS
    ROL     $2000
    ROL     (A2)
    ROL     (A2)+
    ROL     -(A2)
  
    ROL.B   #1,D0
    ROL.B   D0,D1
    ROL.B   #1,D0
    ROL.B   D0,D1

    ROL.W   #1,D0
    ROL.W   D0,D1
    ROL.W   #1,D0
    ROL.W   D0,D1

    ROL.L   #1,D0
    ROL.L   D0,D1
    ROL.L   #1,D0
    ROL.L   D0,D1


    ROR     $00002000   *TESTING RORS
    ROR     $2000
    ROR     (A2)
    ROR     (A2)+
    ROR     -(A2)
  
    ROR.B   #1,D0
    ROR.B   D0,D1
    ROR.B   #1,D0
    ROR.B   D0,D1

    ROR.W   #1,D0
    ROR.W   D0,D1
    ROR.W   #1,D0
    ROR.W   D0,D1

    ROR.L   #1,D0
    ROR.L   D0,D1
    ROR.L   #1,D0
    ROR.L   D0,D1
    

    BRA   BRANCH1   *TESTING BRANCHES AND Bccs
    BRA   BRANCH2
    BRA   BRANCH3

    BGT   BRANCH1
    BGT   BRANCH2
    BGT   BRANCH3
     
    BLE   BRANCH1
    BLE   BRANCH2
    BLE   BRANCH3

    BEQ   BRANCH1
    BEQ   BRANCH2
    BEQ   BRANCH3


    JSR   BRANCH1   *TESTING JSRS
    JSR   BRANCH2
    JSR   BRANCH3


    RTS   *TESTING RTSS
    RTS
    RTS


    DIVU    D2,D1   *TESTING DIVUS
    DIVU    D3,D4
    DIVU    (A5),D6
    DIVU    -(A7),D0
    DIVU    (A1)+,D2
    DIVU    $3456,D7
    DIVU    $01234567,D0
    DIVU    #123,D4
    DIVU    #$123,D4
    DIVU    #12345,D0
    DIVU    #$4567,D0
    
BRANCH3
    MULS    D2,D1   *TESTING MULS
    MULS    D3,D4
    MULS    (A5),D6
    MULS    -(A7),D0
    MULS    (A1)+,D2
    MULS    $3456,D7
    MULS    $01234567,D0
    MULS    #123,D4
    MULS    #$123,D4
    MULS    #12345,D0
    MULS    #$4567,D0

    
    SUBA.W D4,A0   *TESTING SUBAS   
    SUBA.W A4,A1
    SUBA.W (A5),A2
    SUBA.W (A6)+,A3 

    SUBA.L -(A0),A4
    SUBA.L $1234,A5
    SUBA.L $12345678,A6	
    SUBA.L #$2468,A7
 

    SIMHALT


    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
