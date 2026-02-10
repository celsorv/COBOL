      *> ***************************************************************
      *>
      *> Objetivo: Estudo de Tabuada em GnuCOBOL
      *> Compilar: cobc -x -free tabuada.cbl -o tabuada
      *> Executar: ./tabuada
      *>
      *> ***************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. tabuada.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 CONTADOR         PIC 9(02).
           01 RESULTADO        PIC ZZ9.

           01 NUMERO           PIC S9(02) VALUE 0.
           01 NUMERO-EDITADO   PIC Z9.

           *> Estrutura para Data
           01 DATA-SISTEMA.
               05 ANO-SYS      PIC 9(04).
               05 MES-SYS      PIC 9(02).
               05 DIA-SYS      PIC 9(02).
           01 DATA-FORMATADA.
               05 DIA-F        PIC 9(02).
               05 FILLER       PIC X VALUE "/".
               05 MES-F        PIC 9(02).
               05 FILLER       PIC X VALUE "/".
               05 ANO-F        PIC 9(04).

           *> Estrutura para Hora com REDEFINES
           01 HORA-SISTEMA     PIC 9(08).
           01 HORA-DETALHADA   REDEFINES HORA-SISTEMA.
               05 HH-SYS       PIC 9(02).
               05 MM-SYS       PIC 9(02).
               05 SS-SYS       PIC 9(02).
               05 CC-SYS       PIC 9(02).

           *> Constantes de Terminal (Beep e Cores ANSI)
           01 BEEP-SOM         PIC X VALUE X"07".
           01 COR-AZUL         PIC X(05) VALUE X"1B5B33346D".
           01 COR-VERMELHO     PIC X(05) VALUE X"1B5B33316D".
           01 COR-VERDE        PIC X(05) VALUE X"1B5B33326D".
           01 COR-RESET        PIC X(04) VALUE X"1B5B306D".
       
       PROCEDURE DIVISION.
           
           PERFORM UNTIL NUMERO = 99
               DISPLAY " "
               DISPLAY "--- MENU TABUADA (99 para SAIR) ---"
               DISPLAY "Digite um numero (01 a 98): " WITH NO ADVANCING
               ACCEPT NUMERO
               
               IF NUMERO = 99 EXIT PERFORM CYCLE END-IF

               IF NUMERO <= 0
                   DISPLAY BEEP-SOM COR-VERMELHO 
                           "Erro: Digite um valor acima de zero."
                           COR-RESET
                   EXIT PERFORM CYCLE
               END-IF
               
               MOVE NUMERO TO NUMERO-EDITADO

               DISPLAY " "
               DISPLAY COR-VERDE 
               DISPLAY "Tabuada do " FUNCTION TRIM(NUMERO-EDITADO) ":"
               DISPLAY "-------------------"
               
               PERFORM VARYING CONTADOR FROM 1 BY 1 UNTIL CONTADOR > 10
                   MULTIPLY NUMERO BY CONTADOR GIVING RESULTADO
                   DISPLAY NUMERO-EDITADO " x " CONTADOR " = " RESULTADO
               END-PERFORM
               
               DISPLAY "-------------------" 
               DISPLAY COR-RESET
           END-PERFORM.

           *> Captura e formata Data e Hora para o encerramento
           ACCEPT DATA-SISTEMA FROM DATE YYYYMMDD.
           MOVE DIA-SYS TO DIA-F.
           MOVE MES-SYS TO MES-F.
           MOVE ANO-SYS TO ANO-F.
           ACCEPT HORA-SISTEMA FROM TIME.

           DISPLAY " "
           DISPLAY COR-AZUL 
           DISPLAY DATA-FORMATADA " às " HH-SYS ":" MM-SYS ":" SS-SYS
                   " :: Sistema encerrado (99). Ate logo!"
           DISPLAY COR-RESET
           DISPLAY " "

           STOP RUN.
           
