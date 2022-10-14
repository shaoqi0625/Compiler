%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idStr[50];
char numStr[50];
int yylex();
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
lines   :   lines expr ';' {printf("%s\n", $2);}
        |   lines ';'
	    |
        ;

expr    :   expr add expr {
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, $3);
    strcat($$, "+ ");
}
|   
expr sub expr {
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, $3);
    strcat($$, "- ");
}
|   
expr mul expr{
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, $3);
    strcat($$, "* ");
}
|   
expr DIV expr{
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, $3);
    strcat($$, "/ ");
}
|   
left_parentheses expr right_parentheses{
    $$ = $2;
}
|   
sub expr %prec UMINUS{
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $2);
    strcat($$, "- ");
}
|   
NUMBER {
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, " ");
}
|   
id {
    $$ = (char*)malloc(50 * sizeof(char));
    strcpy($$, $1);
    strcat($$, " ");
}
;
%%

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t == ' '|| t == '\t' || t == '\n'){

        }
        else if((t >= '0' && t <= '9')){
            int ti = 0;
            while((t >= '0' && t <= '9')){
                numStr[ti]= t;
                t = getchar();
                ti++;
            }
            numStr[ti] = '\0';
            yylval = numStr;
            ungetc(t, stdin);
            return NUMBER;
        }
        else if (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_')){
            int ti = 0;
            while (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_')
            || (t >= '0' && t <='9'))
             {
                 idStr[ti] = t;
                 ti++;
                 t = getchar();
             }
             idStr[ti] = '\0';
             yylval = idStr;
             ungetc(t, stdin);
             return id;
        }
        else if(t == '+'){
			return add;
		}
		else if(t == '-'){
			return sub;
		}
		else if(t == '*'){
			return mul;
		}
		else if(t == '/'){
			return DIV;
		}
		else if(t == '('){
			return left_parentheses;
		}
		else if(t == ')'){
			return right_parentheses;
		}
		else{
			return t;
		}
    }
}
int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s)
{
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}
