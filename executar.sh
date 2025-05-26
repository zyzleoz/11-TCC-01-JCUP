#!/bin/bash

# Remover arquivos:
rm -rf *.class *.java~
rm -rf jcup.jar MeuParser.java sym.java 
rm -rf jflex.jar MeuScanner.java   

# Baixar JFlex e JCup:
wget https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar
wget https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar

# Gerar o Analisador Léxico:
java -cp jflex.jar:jcup.jar jflex.Main exemplo.flex

# Gerar o Analisador Sintático:
java -cp jcup.jar java_cup.Main -parser MeuParser exemplo.cup

# Compilar as classes .java:
javac -cp jcup.jar *.java

# Executar a classe principal:
echo "Digite uma expressão:"
echo "Exemplos:"
echo "(-10 + 5) - 2;   -> -7"
echo "(-10 + 5) - -2;  -> -3"
echo "-(-10 + 5) - -2; ->  7"
echo "10 - (5 + 2);    ->  3"
echo "10 - 5 + 2;      ->  7"
echo "-10 - -5 - -2;   -> -3"
echo "-10--5--2;       -> -3"
echo "10  - -(5 + 2);  -> 17"
echo "-10  - -(5 + 2); -> -3"
echo "---2--3;        ->  1"
java -cp .:jcup.jar MeuParser