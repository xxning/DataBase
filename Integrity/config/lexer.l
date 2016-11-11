%{
#include <string>
#include "node.hh"
#include "tok.hh"
int yycolumn = 1;
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;
%}

letter			[A-Za-z_]
digit			[0-9]
delim			[ \t] 
ws				{delim}+
id				{letter}({letter}|{digit})*
number			{digit}+(\.{digit}+)?(E[+\-]?{digit}+)?

%option noyywrap
%option yylineno

%%

{ws}			{/*没有动作,也不返回*/}
insert			{return(INSERT);}
into			{return(INTO);}
create			{return(CREATE);}
int 			{yylval.var = new std::string (yytext);return(INT);}
varchar			{yylval.var = new std::string (yytext);return(VARCHAR);}
table			{return(TABLE);}
display			{return(DISPLAY);}
constrain		{return(CONSTRAIN);}
delete			{return(DELETE);}
from 			{return(FROM);}			
where			{return(WHERE);}
update			{return(UPDATE);}
primary			{return(PRIMARY);}
key				{return(KEY);}
foreign			{return(FOREIGN);}
reference		{return(REFERENCE);}
{number}        {yylval.num = atoi (yytext);return(NUMBER);}
{id}    		{yylval.var = new std::string (yytext);return(IDENTIFIER);}

"<"				{ yylval.var = new std::string (yytext);
			  	  return(LT);}
"<="			{ yylval.var = new std::string (yytext);
			   	  return(LE);}
"=="			{ yylval.var = new std::string (yytext);
			  	  return(EQ);}
">"				{ yylval.var = new std::string (yytext);
			  	  return(GT);}
">="			{ yylval.var = new std::string (yytext);
			  	  return(GE);}
"!="			{ yylval.var = new std::string (yytext);
			  	  return(UE);}  

","				{return ',';}
";"             { return ';';}
"("             { return '(';}
")"             { return ')';}
"{"				{ return '{';}
"}"				{ return '}';}

\n              { return eol_tok;}

%%
