%{
#include<stdio.h>
#include<string.h>
#include "y.tab.h"
%}
%x COMMENT
%%
"bool" {return BOOL;}
"char" {return CHAR;}
"int" {return INT;}
"real" {return REAL;}
"string" {return STRING;}
"int*" {return INT_P;}
"char*" {return CHAR_P;}
"real*" {return REAL_P;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"var" {return VAR;}
"func" {return FUNC;}
"proc" {return PROC;}
"return" {return RETURN;}
"null" {return NULLL;}
"&&" {return AND;}
"/" {return DIV;}
"=" {return ASSIGN;}
"==" {return EQUAL;}
">" {return BIGGER;}
">=" {return BIGGEREQ;}
"<" {return SMALLER;}
"<=" {return SMALLEREQ;}
"-" {return MINUS;}
"!" {return NOT;}
"!=" {return NOTEQ;}
"||" {return OR;}
"+" {return PLUS;}
"*" {return MULTIPLY;}
"&" {return REFERENCE;}
"^" {return DEREFERENCE;}
"false" {return BOOLFALSE;}
"true" {return BOOLTRUE;}

";" {return SEMICOLON;}
":" {return COLON;}
"," {return COMMA;}
"|" {return LEN;}
"{" {return LBRACE;}
"}" {return RBRACE;}
"(" {return LBRACKET;}
")" {return RBRACKET;}
"[" {return LSQRBR;}
"]" {return RSQRBR;}

	

			
					

"/%" { BEGIN COMMENT; }
<COMMENT>[^%/]+ { }
<COMMENT>("%"+)"/" { BEGIN INITIAL; }
<COMMENT>[*/] { } 

[1-9][0-9]*|0 {yylval=atoi(yytext); return NUM;}
[a-zA-Z][_a-zA-Z0-9]* { yylval = strdup(yytext); return ID;}
"\""[^"]*"\"" {yylval= strdup(yytext);return STRING_LTL;}
\'.\' {yylval= strdup(yytext);return CHAR_LTL;}
0(x|X)[0-9A-F]+ {yylval= strdup(yytext);return HEX_LTL;}
[-+]?[0-9]*[\.]?[0-9]*[eE]?[-+]?[0-9]+ {yylval= strdup(yytext);return REAL_LTL;}
[ ]
\n {yylineno++;}
[ /t]+ ; 
. return yytext[0];

%%
