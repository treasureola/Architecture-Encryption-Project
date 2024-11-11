.ORIG x3000

START         LEA R0 startmsg;
              PUTS;
loopstart     LEA R0 query;
              PUTS;
              GETC;

              ;AND R1 R1 #0; MAKE SURE R1 IS CLEARED
              LD R1 E; ENCRYPT
              ADD R1 R0 R1;
              BRz ENCRYPT; IF NOT E GO TO DECRYPT
              BRnp DECRYPT;
              
ENCRYPT       LD R2 goKEYADDR;
              JSRR R2;
              ;KEYADDR; IF ENCRYPT, GO TO INOUT KEY
              
afterkey      LD R5 MESSAGE; STORE MSGCHARS INTO R5
              LEA R0 promptmsg; INPUT MESSAGE
              PUTS;
              LD R4 COUNTER2; COUNTER
Mloop         BRnz endMloop; IF ALL KEYS ARE ENETRED 
              GETC; GET MESSAGE
              STR R0 R5 #0; STORE THE USER INPUT INTO MSGCHARS
              ADD R5 R5 #1; INCREMENT THE ADDRESS IN KEY CHAR
              ADD R4 R4 #-1; DECREMENT THE COUNTER
              BRnzp Mloop;
endMloop      ;CHECK IF VALID INPUT,I.E IF THE INPUT IS ONLY ASCII PRINTABLE CHARATERS
              LD R5 goEVigenere; IF MESSAGE IS VALID
              JSRR R5;
DONES         BRnzp loopstart;

DECRYPT       LD R1 D; ENCRYPT
              ADD R1 R0 R1;
              BRz DECRYP; IF NOT E GO TO DECRYPT
              BRnp XS
              
DECRYP        LD R2 goKEYADDR;
              JSRR R2;
              
              LD R2 goDEC;
              JSRR R2;
              
              BRnzp loopstart

XS           LD R1 X;
             ADD R1 R0 R1;
             BRnp inval
             ;clear memory
                 LD R1 COUNTER;
                 LD R0 KEYCHARS;
        clearkey BRnz clearEmessage
                 LDR R2 R0 #0;
                 AND R2 R2 #0; clear message
                 STR R2 R0 #0
                 ADD R0 R0 #1; increment address
                 ADD R1 R1 #-1; decremenr counter
                 BRnzp clearkey
            
   clearEmessage LD R1 COUNTER2;
                 LD R0 MESSAGE;
            CE   BRnz clearDmessage
                 LDR R2 R0 #0;
                 AND R2 R2 #0; clear message
                 STR R2 R0 #0
                 ADD R0 R0 #1; increment address
                 ADD R1 R1 #-1; decremenr counter
                 BRnzp CE
                 
clearDmessage    LD R1 COUNTER2;
                 LD R0 DECMSG;
            CDM  BRnz FINAL;
                 LDR R2 R0 #0;
                 AND R2 R2 #0; clear message
                 STR R2 R0 #0
                 ADD R0 R0 #1; increment address
                 ADD R1 R1 #-1; decremenr counter
                 BRnzp CDM

              
inval         LEA R0 invalid;
              PUTS;
              BRnzp loopstart;

FINAL HALT

KEYADDR       LD R2 KEYCHARS; Load keychar address
KEY           LEA R0 keymsg; prompt enter key
              PUTS;
              LD R3 COUNTER; LD counter address
WHL           BRnz keyscomp; If all keys are entered
              GETC; enter key input(goes five times until no more space)
              STR R0 R2 #0; STORE THE USER INPUT INTO KEYCHARS
              ADD R2 R2 #1; INCREMENT THE ADDRESS IN KEYCHARS
              ADD R3 R3 #-1; DECREMENT THE COUNTER
              BRnzp WHL; Keep looping until all five characters are entered
keyscomp      ;BRnzp CHECK;
              LD R5 goCHECK;  Go to check if all keys are entered to check if it is valid
              ST R7 SaveR7;
              JSRR R5;
              LD R7 SaveR7;
DONE          RET;

CHECK 
;CHECK FIRST DIDGIT
      LD R2 KEYCHARS; 
      LDR R1 R2 #0;
      LD R5 zero; if is less than the ascii of 0
      ;NOT R5 R5; NOT 0
      ;ADD R5 R5 #1; LOOK FOR THE 2'S COMP OF ZERO
      ADD R5 R1 R5; SUBTRACT THE USER INPUT FROM ZER0
      BRn inval;
      LDR R1 R2 #0;
      LD R6 eight; LOAD THE ASCII VALUE OF 0; If the input is greater than the ascii of seven
      NOT R6 R6; NOT 0
      ADD R6 R6 #1; LOOK FOR THE 2'S COMP OF ZERO
      ADD R6 R1 R6; SUBTRACT THE USER INPUT FROM ZER0
      BRzp inval;
      
;CHECK SECOND DIGIT
      LDR R1 R2 #1; GO TO NEXT INDEX
      LD R5 zero; userinput - 0; 
      ;NOT R5 R5; NOT 0
      ;ADD R5 R5 #1; LOOK FOR THE 2'S COMP OF ZERO
      ADD R5 R1 R5; SUBTRACT THE USER INPUT FROM ZER0
      BRnz skip;
      LDR R1 R2 #1;
      LD  R6 nine; LOAD THE ASCII VALUE OF 0; If the input is greater than the ascii of seven
      NOT R6 R6; NOT 0
      ADD R6 R6 #1; LOOK FOR THE 2'S COMP OF ZERO
      ADD R6 R1 R6; SUBTRACT THE USER INPUT FROM ZER0
      BRnz inval;
      skip  
      
;CHECK LAST THREE DIGIT
;THIRD
      LD R3 zero; GETTING ASCII 
      LDR R5 R2 #2;
      ;NOT R3 R3;
      ;ADD R3 R3 #1;
      ADD R5 R5 R3;
      STR R5 R2 #2;
      LD R3 hundred;
      AND R5 R5 #0; CLEAR R5 TO STORE INPUT 100
      ADD R5 R5 R3;
      ;mult R1 AND R5
      AND R1 R1 #0;
      LDR R3 R2 #2; LOAD THE THIRD DIGIT
      ADD R6 R5 #0; COPY 100 TO R6
LOOP  BRnz done2
      ADD R1 R1 R3; 
      ADD R6 R6 #-1;
      BRnzp LOOP;
done2 STR R1 R2 #2; STORE HUNDRETH IN THE 3RD DIGIT ADDRESS

;FOURTH
      LD R3 zero;
      LDR R5 R2 #3;
      ;NOT R3 R3;
      ;ADD R3 R3 #1;
      ADD R5 R5 R3;
      STR R5 R2 #3;
      AND R5 R5 #0; CLEAR R5
      ADD R5 R5 #10; LD 10
      ;mult R1 AND R5
      AND R1 R1 #0;
      LDR R3 R2 #3;
      ADD R6 R5 #0;
LOOP2 BRnz done3;
      ADD R1 R1 R3;
      ADD R6 R6 #-1;
      BRnzp LOOP2;
done3 STR R1 R2 #3;

;FIFTH      
      LD R3 zero;
      LDR R5 R2 #4;
      ;NOT R3 R3;
      ;ADD R3 R3 #1;
      ADD R5 R5 R3;
      STR R5 R2 #4;
;ADD
      LDR R4 R2 #2;
      LDR R5 R2 #3;
      ADD R6 R4 R5;
      
      LDR R3 R2 #4;
      ADD R1 R3 R6;
      STR R1 R2 #2;
      
      ;SUBTRACT TOTAL FORM 127 AND MAKE SURE IT IS NEGATIVE
      LD R3 onetwosev;
      NOT R3 R3;
      ADD R3 R3 #1;
      ADD R4 R1 R3;
      BRp Kinval;
      AND R1 R1 #1;
      BRn Kinval;
      ;ALSO MAKE SURE IT IS >= 0
      ;BRnzp DONE; IF VALID
      RET;
      
Kinval LEA R0 invalid;
       PUTS;
       BRnzp KEY; Go back to input key
      
E .FILL #-69
D .FILL #-68
X .FILL #-88
MESSAGE    .FILL x4000;
promptmsg   .STRINGZ "\nENTER MESSAGE\n"
invalid     .STRINGZ "\nINVALID INPUT\n"
query       .STRINGZ "\nENTER E OR D OR X\n"
startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
keymsg      .STRINGZ "\nENTER KEY\n"
goEVigenere .FILL EVigenere
goKEYADDR .FILL KEYADDR;
goDEC .FILL DEC;
;goDShiftBit .FILL DShiftBit
goCHECK .FILL CHECK;
COUNTER .FILL #5
KEYCHARS    .FILL x3500;
COUNTER2 .FILL #10
eight .FILL #56
zero .FILL #-48
nine .FILL #57
hundred .FILL #100
foureight .FILL #48
SaveR7 .BLKW #1;
onetwosev .FILL #127
onetwoeight .FILL #128
two .FILL #2
DECMSG .FILL x5000;
      
      
;ENCRYPT
EVigenere LD R4 MESSAGE;
         LD R5 COUNTER2;
         
VLOOP    BRnz ECaeser;
         LD R2 KEYCHARS;
          
         LDR R1 R2 #1;
         LD R3 zero;
         ADD R1 R1 R3;
         BRz ECaeser; if zero skip
         
         LDR R1 R2 #1; LD KEY
         NOT R2 R1; not key
         LDR R3 R4 #0; LD MESSAGE
         AND R2 R2 R3; and key' and message 
         NOT R6 R3; not message
         AND R6 R6 R1; and not message' and key
         NOT R2 R2; not r2
         NOT R6 R6; not r6
         AND R1 R2 R6; and r2 and r6
         NOT R1 R1; not r1
         STR R1 R4 #0; Should this be stored in the for loop or outside
      
         ADD R4 R4 #1; increment address
         ADD R5 R5 #-1; decrement counter
         BRnzp VLOOP;

ECaeser 
      
      LD R5 MESSAGE;
      LD R6 KEYCHARS;
      LD R1 COUNTER2;
H     BRnz EN;
      LDR R0 R6 #2;
      LDR R3 R5 #0; 
      ADD R4 R3 R0; INPUT + KEY
      LD R2 onetwoeight;
      ;MODULO - (INPUT + K) MODULO 128
      NOT R3 R2; NOT 128
      ADD R0 R3 #1; 2'S COMP OF 128
      ADD R3 R4 #0; TEMP = (INPUT + Key)
CWHL  BRn CD;
      ADD R3 R3 R0; temp -k
      BRnzp CWHL
CD    ADD R0 R3 R2; temp + k
      STR R0 R5 #0;
      ADD R5 R5 #1; INCREMENT ADRRESS
      ADD R1 R1 #-1; DECREMENT COUNTER
      BRnzp H;
EN RET     
     
 
  
DEC  

DCaeser   
      LD R5 MESSAGE;
      LD R0  DECMSG
      LD R6 KEYCHARS;
      LDR R6 R6 #2;
        NOT R6 R6
        ADD R6 R6 #1
       LD R1 COUNTER2;
H2     BRnz DVigenere;
      LDR R3 R5 #0; 
      ADD R4 R3 R6; INPUT - KEY
      LD R2 onetwoeight;
      ;MODULO - (INPUT + K) MODULO 128
      NOT R3 R2; NOT 128
      ADD R3 R3 #1; 2'S COMP OF 128
      ADD R4 R4 #0; TEMP = (INPUT + Key)
CWHL2  BRn CD2;
      ADD R4 R4 R3; temp -k
      BRnzp CWHL2
CD2    ADD R4 R4 R2; temp + k
      STR R4 R0 #0;
      ADD R0 R0 #1; INCREMNT STORING ADDRESS
      ADD R5 R5 #1; INCREMENT ADRRESS
      ADD R1 R1 #-1; DECREMENT COUNTER
      BRnzp H2;
      

DVigenere 
          LD R4 DECMSG;
          LD R5 COUNTER2;
         
VLOOP2    BRnz DONE4;
          LD R2 KEYCHARS;
          
          LDR R1 R2 #1;
          LD R3 zero;
          ADD R1 R1 R3;
          BRz DONE4; if zero skip
         
          LDR R1 R2 #1; LD KEY
          NOT R2 R1; not key
          LDR R3 R4 #0; LD MESSAGE
          AND R2 R2 R3; and key' and message 
          NOT R6 R3; not message
          AND R6 R6 R1; and not message' and key
          NOT R2 R2; not r2
          NOT R6 R6; not r6
          AND R1 R2 R6; and r2 and r6
          NOT R1 R1; not r1
          STR R1 R4 #0; Should this be stored in the for loop or outside
      
          ADD R4 R4 #1; increment address
          ADD R5 R5 #-1; decrement counter
          BRnzp VLOOP2;
 DONE4         RET;

 .END