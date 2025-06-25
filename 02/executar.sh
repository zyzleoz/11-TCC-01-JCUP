#!/bin/bash

# Define o nome do arquivo de entrada JSON
INPUT_FILE="entrada.json"

# Limpa arquivos gerados anteriormente
echo "Limpando arquivos gerados..."
rm -f *.class *.java sym.java JSONParser.java JSONLexer.java
rm -f jcup.jar jflex.jar

# Baixa as ferramentas JFlex e CUP
echo "Baixando JFlex e CUP JARs..."
wget -q https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar
wget -q https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar

echo "Gerando JSONLexer.java com JFlex..."
# Gerar o analisador léxico (lexer)
# É crucial adicionar jcup.jar ao classpath para que JFlex encontre java_cup.runtime.Scanner
java -cp "jflex.jar:jcup.jar" jflex.Main JSONLexer.flex

echo "Gerando JSONParser.java e sym.java com CUP..."
# Gerar o analisador sintático (parser) e a classe de símbolos
# Use -cp para CUP também, especificando a classe principal java_cup.Main
java -cp jcup.jar java_cup.Main -parser JSONParser JSONParser.cup

echo "Compilando arquivos Java gerados..."
# Compilar todos os arquivos Java gerados.
# O classpath deve incluir o diretório atual (.) e os JARs do JFlex e CUP.
javac -cp ".:jflex.jar:jcup.jar" *.java

echo -e "\n--- Executando analisador JSON ---"
# Executar o analisador.
# O classpath deve incluir o diretório atual (.) e os JARs do JFlex e CUP.
# Passe o nome do arquivo JSON de entrada como argumento.
java -cp ".:jflex.jar:jcup.jar" JSONParser "$INPUT_FILE"

# Verifica se a execução foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Análise de JSON concluída com sucesso."
else
    echo "Análise de JSON falhou."
fi