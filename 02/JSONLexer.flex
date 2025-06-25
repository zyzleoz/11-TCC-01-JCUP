import java_cup.runtime.*;

%%
%class JSONLexer
%cup
%line
%column
%unicode

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

// Expressões regulares para os tokens JSON
espaco = [ \t\n\r]+
digito = [0-9]
numero = {digito}+
string_char = [^\"\\\n\r] // Qualquer caractere exceto aspas, barra invertida, quebra de linha ou retorno de carro

// Correção nesta linha: para ter '\' literal dentro de '[]', você precisa de '\\'
// Ou seja, `\` literal é `\\` na regex, e dentro de `[]` é `\\`
// Então, para ter `\` dentro dos caracteres escapáveis: `\\`
// Os escapes JSON são: \", \\, \/, \b, \f, \n, \r, \t, \uXXXX
escape_char = \\[\"\\/bfnrt] | \\u[0-9a-fA-F]{4} // Adicionado o escape unicode e corrigido a barra invertida e forward slash
string = \"({string_char}|{escape_char})*\"

%%

// Regras para reconhecimento dos tokens
"{"             { return symbol(sym.LCHAVE); }
"}"             { return symbol(sym.RCHAVE); }
"["             { return symbol(sym.LCOLCH); }
"]"             { return symbol(sym.RCOLCH); }
":"             { return symbol(sym.DPONTO); }
","             { return symbol(sym.VIRGULA); }
"true"          { return symbol(sym.TRUE); }
"false"         { return symbol(sym.FALSE); }
"null"          { return symbol(sym.NULL); }
{numero}        { return symbol(sym.NUMERO, Integer.parseInt(yytext())); }
{string}        { return symbol(sym.STRING, yytext().substring(1, yytext().length()-1)); }
{espaco}        { /* ignora espaços em branco */ }

<<EOF>>         { return symbol(sym.EOF); }

// Tratamento de erro para caracteres inválidos
.               { System.err.println("Erro Léxico: Caractere inválido: '" + yytext() + "' na linha " + (yyline+1) + ", coluna " + (yycolumn+1)); }