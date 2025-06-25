/* Importa a classe Symbol que será usada para comunicar os tokens com o CUP */
import java_cup.runtime.Symbol;

%%

/* Definições e configurações do scanner */
%class MeuScanner
%cup
%unicode
%line
%column


%{
  private Symbol criarSimbolo(int tipo) {
    return new Symbol(tipo, yyline, yycolumn);
  }

  private Symbol criarSimbolo(int tipo, Object valor) {
    return new Symbol(tipo, yyline, yycolumn, valor);
  }
%}

/* Macros para facilitar as expressões */
DIGITO = [0-9]
NUMERO = {DIGITO}+("."{DIGITO}+)?
LETRA = [a-zA-Z]
ASPAS = \"
ESPACO = [ \t\r\n]+

%%

/* Regras léxicas com ações associadas */

{NUMERO}   { return criarSimbolo(sym.NUMERO, Double.valueOf(yytext())); }
\"[^"]*\" { 
  String texto = yytext().substring(1, yytext().length() - 1); 
  return criarSimbolo(sym.STRING, texto); 
}

"true"     { return criarSimbolo(sym.TRUE); }
"false"    { return criarSimbolo(sym.FALSE); }
"null"     { return criarSimbolo(sym.NULL); }
"{"        { return criarSimbolo(sym.LCHAVE); }
"}"        { return criarSimbolo(sym.RCHAVE); }
"["        { return criarSimbolo(sym.LCOLCH); }
"]"        { return criarSimbolo(sym.RCOLCH); }
":"        { return criarSimbolo(sym.DPONTO); }
","        { return criarSimbolo(sym.VIRGULA); }

// Ignorar espaços, tabulações e quebras de linha
{ESPACO}   { /* ignora */ }

// Qualquer outro caractere é inválido
. {
  System.err.println("Caractere inválido: " + yytext() +
                     " na linha " + (yyline + 1) +
                     ", coluna " + (yycolumn + 1));
  return null;
}
