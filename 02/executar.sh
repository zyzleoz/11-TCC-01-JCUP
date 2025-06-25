#!/bin/bash

# Define o nome do arquivo de entrada JSON
INPUT_FILE="entrada.json"

# Remover arquivos:
rm -f *.class *.java sym.java exemplo2.java exemplo.java
rm -f jcup.jar jflex.jar

# Baixa JFlex e CUP
wget -q https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar
wget -q https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar


# Gera o analisador léxico (lexer)
java -cp "jflex.jar:jcup.jar" jflex.Main exemplo.flex


# Gera o analisador sintático
java -cp jcup.jar java_cup.Main -parser exemplo2 exemplo2.cup


# Compila os arquivos Java gerados.
javac -cp ".:jflex.jar:jcup.jar" *.java


# Executa o analisador.
java -cp ".:jflex.jar:jcup.jar" exemplo2 "$INPUT_FILE"

# Verifica se a execução foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Análise de JSON concluída com sucesso."
else
    echo "Análise de JSON falhou."
fi