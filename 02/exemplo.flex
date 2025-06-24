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
inteiro = -?{digito}+
numero = {inteiro}("."{digito}+)?

palavra = \"([^\"\\]|\\.)*\" 

%%

/* Regras e Ações Associadas: seção de instruções para o analisador léxico. */

{numero} {
            Double numero = Double.valueOf(yytext());
            return new Symbol(sym.NUMERO, yyline, yycolumn, numero);
          }
{palavra} {
            String lexema = yytext().substring(1, yytext().length() - 1);
            return new Symbol(sym.STRING, yyline, yycolumn, lexema);
          }
"{"       { return new Symbol(sym.ABRECHAVE); }
"}"       { return new Symbol(sym.FECHACHAVE); }
"["       { return new Symbol(sym.ABRECOLCHETE); }
"]"       { return new Symbol(sym.FECHACOLCHETE); }
","       { return new Symbol(sym.VIRGULA); }
":"       { return new Symbol(sym.DOISPONTOS); }
\n        { /* Ignora nova linha. */ }
[ \t\r]+  { /* Ignora espaços. */ }
.         { System.err.println("\n Caractere inválido: " + yytext() +
                               "\n Linha: " + yyline +
                               "\n Coluna: " + yycolumn + "\n"); 
            return null; 
          }