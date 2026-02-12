       IDENTIFICATION DIVISION.
           PROGRAM-ID. TESTE-INDEX.
       
       ENVIRONMENT DIVISION.
           CONFIGURATION SECTION.
               SPECIAL-NAMES.
                   DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
           FILE-CONTROL.
               SELECT ARQ-PRODUTOS ASSIGN TO "produtos.db"
                   ORGANIZATION IS INDEXED
                   ACCESS MODE IS DYNAMIC
                   RECORD KEY IS PROD-ID
                   FILE STATUS IS FS-CONTROLE.
           
       DATA DIVISION.
           FILE SECTION.
               FD ARQ-PRODUTOS.
                   01 REG-PRODUTO.
                       05 PROD-ID        PIC 9(03).
                       05 PROD-NOME      PIC X(20).
                       05 PROD-PRECO     PIC 9(05)V99.
               
           WORKING-STORAGE SECTION.
               01 FS-CONTROLE        PIC XX.
               01 WS-RESPOSTA        PIC X VALUE "S".
               01 WS-CONTADOR        PIC 9(02) VALUE 0.
               01 WS-PRECO-ED        PIC ZZZZ9,99.
               01 WS-LINHA           PIC X(51) VALUE ALL "-".
    
       PROCEDURE DIVISION.
           OPEN I-O ARQ-PRODUTOS
           IF FS-CONTROLE = "35"
               OPEN OUTPUT ARQ-PRODUTOS
               CLOSE ARQ-PRODUTOS
               OPEN I-O ARQ-PRODUTOS
           END-IF.

           *> Primeiro, listamos o que já existe
           PERFORM LISTAR-REGISTROS.

           *> Depois, entramos no loop de cadastro
           PERFORM UNTIL WS-RESPOSTA = "N" OR "n"
               DISPLAY "--- NOVO CADASTRO ---"
               DISPLAY "ID: " WITH NO ADVANCING
               ACCEPT PROD-ID
               DISPLAY "NOME: " WITH NO ADVANCING
               ACCEPT PROD-NOME
               DISPLAY "PRECO: " WITH NO ADVANCING
               ACCEPT PROD-PRECO
               
               PERFORM GRAVAR-REGISTRO
               
               DISPLAY "Deseja cadastrar outro? (S/N): " 
               ACCEPT WS-RESPOSTA
           END-PERFORM.

           CLOSE ARQ-PRODUTOS.
           STOP RUN.

       LISTAR-REGISTROS.
           DISPLAY "---- ULTIMOS 10 REGISTROS (ORDEM DECRESCENTE) -----"
           
           *> 1. Move o maior valor possível para a chave (High-Values)
           MOVE ALL X"FF" TO PROD-ID
           
           *> 2. Posiciona o ponteiro no último registro existente ou logo após
           START ARQ-PRODUTOS KEY IS LESS THAN PROD-ID
               INVALID KEY 
                   DISPLAY "ARQUIVO VAZIO!"
               NOT INVALID KEY
                   MOVE 0 TO WS-CONTADOR
                   
                   *> 3. Loop limitado a 10 iterações
                   PERFORM UNTIL WS-CONTADOR >= 10 OR FS-CONTROLE NOT = "00"
                       
                       *> O segredo: READ PREVIOUS
                       READ ARQ-PRODUTOS PREVIOUS
                           AT END 
                               CONTINUE
                           NOT AT END
                               ADD 1 TO WS-CONTADOR
                               MOVE PROD-PRECO TO WS-PRECO-ED
                               DISPLAY "ID: " PROD-ID 
                                       " | NOME: " PROD-NOME 
                                       " | R$: " WS-PRECO-ED
                       END-READ
                   END-PERFORM
           END-START
           
           MOVE "00" TO FS-CONTROLE
           DISPLAY WS-LINHA.
           DISPLAY " ".

       GRAVAR-REGISTRO.
           WRITE REG-PRODUTO
               INVALID KEY 
                   REWRITE REG-PRODUTO
               NOT INVALID KEY
                   DISPLAY "OK: GRAVADO."
           END-WRITE.
           
