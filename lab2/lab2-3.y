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

struct symtab
{
    char name[20];
    double value;
}sym;
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
%token equal
%right equal
%right UMINUS

%%

lines   :   lines expr ';' {printf("%f\n", $2);}
        |   lines ';'
        |
        ;
    
expr    :   expr add expr   {$$ = $1 + $3;} 
        |   expr sub expr   {$$ = $1 - $3;} 
        |   expr mul expr   {$$ = $1 * $3;} 
        |   expr DIV expr   {
            if($3==0.0)
                yyerror("Error! Divided by zero!");
            else
                $$ = $1 / $3;
            }  
        |   left_parentheses expr right_parentheses {$$ = $2;}
        |   sub expr %prec UMINUS {$$ = -$2;}
        |   NUMBER          {$$ = $1;}
        |   id equal expr{
            $$=$3;
            sym.value=$3;
        }
        |   id  {$$=sym.value;}
        ;

%%

int yylex()
{
    char t;
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
        } else if (t=='='){
            return equal;
        }else if ((t >= 'a' && t <= 'z' ) || (t >= 'A' && t <= 'Z') || (t == '_')) {
            int ti=0;
            while(('a'<=t&&t<='z')||('A'<=t&&'Z'>=t)||(t=='_')||(t>='0'&&t<='9')){
                sym.name[ti] = t;
                ti++;
                t=getchar(); 
            }
            sym.name[ti] = '\0';
            ungetc(t,stdin);
            return id; 
        }
        else {
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

