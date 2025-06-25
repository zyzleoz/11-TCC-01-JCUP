import java_cup.runtime.*;

%%
%class exemplo
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


espaco = [ \t\n\r]+
digito = [0-9]
numero = {digito}+
chave_char = [^\"\\\n\r]


escape_char = \\[\"\\/bfnrt] | \\u[0-9a-fA-F]{4}
chave = \"({chave_char}|{escape_char})*\"

%%

// Regras para reconhecimento dos tokens
"{"             { return symbol(sym.ABRECHAVES); }
"}"             { return symbol(sym.FECHACHAVES); }
"["             { return symbol(sym.ABRECOLCHETES); }
"]"             { return symbol(sym.FECHACOLCHETES); }
":"             { return symbol(sym.DOISPONTOS); }
","             { return symbol(sym.VIRGULA); }
"true"          { return symbol(sym.TRUE); }
"false"         { return symbol(sym.FALSE); }
"null"          { return symbol(sym.NULL); }
{numero}        { return symbol(sym.NUMERO, Integer.parseInt(yytext())); }
{chave}        { return symbol(sym.CHAVE, yytext().substring(1, yytext().length()-1)); }
{espaco}        { /* ignora espaços em branco */ }

<<EOF>>         { return symbol(sym.EOF); }

// Tratamento de erro para caracteres inválidos
.               { System.err.println("Erro Léxico: Caractere inválido: '" + yytext() + "' na linha " + (yyline+1) + ", coluna " + (yycolumn+1)); }