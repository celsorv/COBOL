# README.md - Instrucoes de Ambiente

## 1. Instalacao
No Ubuntu, abra o terminal e digite:
sudo apt update
sudo apt install gnucobol

## 2. Extensao VS Code
Instale a extensao: bitlang.gnucobol

## 3. Som (Beep)
Teste se o sistema apita com:
echo -e "\a"

## 4. Compilacao (Manual)
Comando:
cobc -x -free seu_arquivo.cbl -o seu_arquivo
