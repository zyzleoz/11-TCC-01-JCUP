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

letra = [a-zA-Z]
palavra = {letra}+
id = {letra}({letra}|{digito})*
espaco = [ \t\n\r]+
digito = [0-9]
numero = {digito}+
espacobranco = [ \r\n\t]+


%%

// Regras para reconhecimento dos tokens
"WHERE"             { return symbol(sym.WHERE); }
"FROM"             { return symbol(sym.FROM); }
"SELECT"             { return symbol(sym.SELECT); }
"AND"             { return symbol(sym.AND); }
{palavra} {return symbol(sym.PALAVRA, yytext());}
","             { return symbol(sym.VIRGULA); }
";"             { return symbol(sym.PONTOVIRG); }
">"             { return symbol(sym.MAIORQ); }
"<"             { return symbol(sym.MENORQ); }
"="             { return symbol(sym.ATRIBUIÇÃO); }
">="             { return symbol(sym.MAIORIGUAL); }
"<="             { return symbol(sym.MENORIGUAL); }
"!="             { return symbol(sym.DIFERENTE); }
"*" {return symbol(sym.TODOS);}
{id} {return symbol(sym.ID, yytext());}
{numero}        { return symbol(sym.NUMERO, Integer.parseInt(yytext())); }
{espaco}        { /* ignora espaços em branco */ }
\'([^\\']|\\.)*\' {return symbol(sym.STRING,
                            yytext().substring(1,
                                    yytext().length() - 1));}

<<EOF>>         { return symbol(sym.EOF); }

// Tratamento de erro para caracteres inválidos
.               { System.err.println("Erro Léxico: Caractere inválido: '" + yytext() + "' na linha " + (yyline+1) + ", coluna " + (yycolumn+1)); }