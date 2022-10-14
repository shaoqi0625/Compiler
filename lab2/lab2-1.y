%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex ();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%left add sub
%left mul DIV
%token NUMBER
%token left_parentheses
%token right_parentheses
%token id 
%token add 
%token sub 
%token mul 
%token DIV 
%right UMINUS

%%

lines   :   lines expr ';' {printf("%f\n", $2);}
        |   lines ';'
        |
        ;
    
expr    :   expr add expr   {$$ = $1 + $3;} 
        |   expr sub expr   {$$ = $1 - $3;} 
        |   expr mul expr   {$$ = $1 * $3;} 
        |   expr DIV expr   {$$ = $1 / $3;} 
        |   left_parentheses expr right_parentheses {$$ = $2;}
        |   sub expr %prec UMINUS {$$ = -$2;}
        |   NUMBER          {$$ = $1;}
        ;

%%

//programs section
int yylex()
{
    int t;
    while(1) {
        t = getchar();
        if(t == ' ' || t == '\t' || t == '\n'){
           
        } 
        else if(isdigit(t)) {
            yylval = 0;
            while(isdigit(t)) {
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t, stdin);
            return NUMBER;
        } else if(t == '+') {
            return add;
        } else if(t == '-') {
            return sub;
        } else if(t == '*') {
            return mul;
        } else if(t == '/') {
            return DIV;
        } else if(t == '(') {
            return left_parentheses;
        } else if(t == ')') {
            return right_parentheses;
        } else {
            return t;
        }
    }
}

int main(void)
{
    yyin = stdin;
    do {
        yyparse();
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Parse error : %s\n", s);
    exit(1);
}

