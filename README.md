# 07-jcup

1. Criar o arquivo `exemplo.flex`:
- `touch exemplo.flex`

2. Informar o conteúdo do arquivo `exemplo.flex`:
```java
/* Definição: seção para código do usuário. */

import java_cup.runtime.Symbol;

%%

/* Opções e Declarações: seção para diretivas e macros. */

// Diretivas:
%cup
%unicode
%line
%column
%class MeuScanner

// Macros:
digito = [0-9]
inteiro = {digito}+

%%

/* Regras e Ações Associadas: seção de instruções para o analisador léxico. */

{inteiro} {
            Integer numero = Integer.valueOf(yytext());
            return new Symbol(sym.INTEIRO, yyline, yycolumn, numero);
          }
"+"       { return new Symbol(sym.MAIS); }
"-"       { return new Symbol(sym.MENOS); }
"("       { return new Symbol(sym.PARENTESQ); }
")"       { return new Symbol(sym.PARENTDIR); }
";"       { return new Symbol(sym.PTVIRG); }
\n        { /* Ignora nova linha. */ }
[ \t\r]+  { /* Ignora espaços. */ }
.         { System.err.println("\n Caractere inválido: " + yytext() +
                               "\n Linha: " + yyline +
                               "\n Coluna: " + yycolumn + "\n"); 
            return null; 
          }
```

3. Criar o arquivo `exemplo.cup`:
- `touch exemplo.cup`

4. Informar o conteúdo do arquivo `exemplo.cup`:
```java
import java_cup.runtime.*;

/* 
=> parser code {: ... :}:
   Permite incluir um método main() diretamente dentro da 
   classe do analisador sintático, dispensando a criação de 
   uma classe principal (Main) com o método main().

   O próprio analisador sintático será responsável por iniciar 
   a execução.
*/
parser code {:
  public static void main(String[] args) throws Exception {
    Compilador compilador = new Compilador();
    compilador.compilar(args[0]);
  }
:}

terminal Integer INTEIRO;
terminal MAIS, MENOS, MENOSUNARIO, PTVIRG, PARENTESQ, PARENTDIR;

non terminal inicio;
non terminal Integer expr;

precedence left MAIS, MENOS;
precedence right MENOSUNARIO; // Menos unário com maior precedência, associatividade à direita.

start with inicio;

inicio ::= expr:e PTVIRG {: System.out.println(e); :}
         ;

expr ::= expr:a MAIS expr:b             {: RESULT = a.intValue() + b.intValue(); :}
       | expr:a MENOS expr:b            {: RESULT = a.intValue() - b.intValue(); :}
       | MENOS expr:a                   {: RESULT = -a; :} %prec MENOSUNARIO       
       | PARENTESQ expr:a PARENTDIR     {: RESULT = a.intValue(); :}
       | INTEIRO:a                      {: RESULT = a.intValue(); :}
       ;

/*
Usar %prec:
  É importante quando um mesmo token tem dois significados 
  diferentes (como o - unário e binário).
  Evita conflitos de precedência.
  Garante a construção correta da árvore sintática e a avaliação da expressão.

=> Usar %prec MENOSUNARIO para informar:
   "Essa regra tem a precedência do token MENOSUNARIO, 
    que foi declarado separadamente na seção de precedência".
*/
```

5. Criar o arquivo `Compilador.java`:
- `touch Compilador.java`

6. Informar o conteúdo do arquivo `Compilador.java`:
```java
import java.io.*;

public class Compilador {
    public void compilar(String caminhoDoArquivoDeEntrada) throws Exception {
        FileReader fileReader = null;
        BufferedReader bufferedReader = null;

        try {
            fileReader = new java.io.FileReader(caminhoDoArquivoDeEntrada);
            bufferedReader = new BufferedReader(fileReader);
            String linha;

            while ((linha = bufferedReader.readLine()) != null) {
                if (linha == null || linha.trim().isEmpty())
                    continue;
                System.out.println("> " + linha);
                processar(linha);
            }
        } catch (IOException e) {
            System.err.println("Erro ao ler arquivo de entrada: " + e.getMessage());
        } finally {
            if (bufferedReader != null)
                bufferedReader.close();
            if (fileReader != null)
                fileReader.close();
        }
    }

    public void processar(String linha) {
        // Adicionar um \n no final para garantir que o analisador leia a linha
        // completa:
        StringReader stringReader = new StringReader(linha + "\n");

        MeuParser meuParser = new MeuParser(new MeuScanner(stringReader));

        try {
            meuParser.parse();
        } catch (Exception e) {
            System.err.println("Erro na expressão: " + e.getMessage());
        } finally {
            stringReader.close();
        }
    }
}
```

7. Criar o arquivo `entrada.txt`:
- `touch entrada.txt`

8. Informar o conteúdo do arquivo `entrada.txt`:
```
(-10 + 5) - 2;  
(-10 + 5) - -2; 
-(-10 + 5) - -2;
10 - (5 + 2);   
10 - 5 + 2;     
-10 - -5 - -2;  
-10--5--2;      
10  - -(5 + 2); 
-10  - -(5 + 2);
---2--3;
```

9. Criar o arquivo `executar.sh`:
- `touch executar.sh`

10. Informar o conteúdo do arquivo `executar.sh`:
```bash
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
java -cp .:jcup.jar MeuParser ./entrada.txt
```

11. Dar permissão de execução para o arquivo de script `executar.sh` (torná-lo executável):
- `chmod +x executar.sh`

12. Executar o `executar.sh`:
- `./executar.sh`
