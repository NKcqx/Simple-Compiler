%{
#include <fstream>
#include "mylexer.h"
#include "driver.h"
#include "myparser.h"
extern int yylex();
extern int yylineno;
   
extern char* yytext;
extern int yyleng;
using namespace std;
class A{};
Node* node;
%}
%union {
    class Node *nodes;
    class IntNode *int_n;
    class DoubleNode *double_n;
    class CharNode *char_n;
    class StringNode *str;
    class IDNode *id_n;
    char* name;
    int token;
}

%name myparser
/*
%include {
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
}
*/
%token<int_n>            INTEGER TRUE FALSE NUL
%token<double_n>         DBL
%token<char_n>           CHR
%token<str>              STR
%token<str>              ID
%token<token>            INT DOUBLE CHAR FLOAT BOOL VOID STRUCT
%token<token>            IF ELSE THEN WHILE DO FOR GOTO SWITCH CASE DEFAULT
%token<token>            PROC_CONTROL  ACCESS_CONTROL ERR_CONTROL USING NAMESPACE DEFINE
%token<token>            READ WRITE 
%token<token>            CLASS RETURN NEW DEL THIS
%token<token>            ';'
%token<token>            '#'

%token<token>             FUNC_PRE
%token<token>            '{' '}'
%left <token>           '(' ')'
%left<token>            ','
%right<token>           '=' AA MNA MA DA MOA ORA XORA PA
%right<token>           '?' ':'
%left<token>            OR
%left<token>            AND
%left<token>            '|'
%left<token>            '^'
%left<token>            '&'
%left<token>            EQ NEQ
%left<token>            CMP
%left<token>            '+' '-'
%left<token>            '*' '/' '%'
%left<token>            '!' PP MM '~' LL RR
%left<token>            RA NSP '[' ']'

%type <nodes> vals
%type <nodes> stmts block
//%type <nodes> func_def_args
%type <nodes> stmt def_stmt if_stmt while_stmt for_stmt return_stmt

%type <nodes> expr expritem
%type <nodes> types
%type <nodes> initlist
%type <nodes> var varexpr
%type <nodes> ids exprlist
//%type <nodes> func_def_stmt

%start program
%%
program : //types ID '(' def_stmt ')' stmts {}
         stmts {}
        ;
types: INT  {printf("types INT\n"); }
     | DOUBLE   {}
     | FLOAT    {}
     | CHAR {}
     | VOID {}
     | BOOL {}
    // | types '*' { }
    ;/*
func_def_args:    {}
    | def_stmt    {printf("func_def_args types ID%s\n", $1);}
    | func_def_args ',' def_stmt   {printf("func_def_args lists\n");}
    ;*/
/*mainarg :  {}
        | VOID {}
        | INT ID COMMA CHAR MUL ID LBRACK RBRACK {}
        | INT ID COMMA CHAR MUL MUL ID {}
        ;*/
block : '{' stmts '}' {}
      ;
stmts   : /* empty */ {}
        | stmt {}
        | stmts stmt {}
        ;
stmt    : def_stmt ';'{printf("stmt def_stmt ;\n");}
        | if_stmt {printf("stmt if_stmt ;\n");}
        | while_stmt {printf("stmt while_stmt ;\n");}
        | for_stmt {printf("stmt for_stmt ;\n");}
        | return_stmt ';'{printf("stmt return_stmt ;\n");}
        //| error SEMICOLON { $$ = new GeneralNode(INVALID); yyerrok(); }
        | exprlist ';' {printf("stmt exprlist ;\n");  }
        | block {printf("stmt block \n"); }
        | ';' {printf("stmt just a ;\n"); }
        ;
initlist: '{' exprlist '}' {printf("initlist {list}\n"); }
        | '{' exprlist ',' '}' {printf("initlist {list ,}\n");}
        ;
exprlist: exprlist ',' expritem {printf("exprlist , item\n"); }
        | expritem {printf("exprlist item\n");}
        ;
expritem: expr {printf("expritem : expr\n");  }
        | initlist {  }
        ;
vals:     INTEGER   {printf("vals INTEGER %d\n", $1->value);}
        | DBL   {printf("vals DBL %f\n", $1->value);}
        | CHR   {printf("vals CHR %c\n", $1->value);}
        | STR   {}
        | TRUE  {}
        | FALSE {}
        | NUL   {}
        ;
/*func_def_stmt: types ID '(' def_stmt ')' block   {printf("func_def\n");}
        ;*/
expr    : '(' expr ')' { printf("(expr)\n");}
        | expr PA  expr {}
        | expr MNA expr {}
        | expr MA  expr {}
        | expr DA  expr {}
        | expr MOA expr {}
        | expr ORA expr {}
        | expr XORA expr {}
        | expr AA  expr {}
        | expr '+' expr {  }
        | expr '-' expr { }
        | expr '*' expr {  }
        | expr '/' expr {  }
        | expr '%' expr {  }
        | expr LL expr {  }
        | expr RR expr { }
        | expr '|' expr {}
        | expr '^' expr { }
        | expr '&' expr {  }
        | expr EQ expr {  }
        | expr NEQ expr {  }
        | expr CMP expr {  }
        | expr OR expr {  }
        | expr AND expr {  }
        | expr '=' expr {printf("expr = expr\n");  }
        | PP expr  %prec '!' {printf("PP expr\n");}
        | MM expr  %prec '!' {}
        | '-' expr %prec '!' {  }
        | expr PP  %prec '*' {printf("expr PP\n");}
        | expr MM  %prec '*' {}
        | '!' expr {}
        | '~' expr {}
        | vals  {printf("expr vals\n");}
        | var {printf("expr ID \n");}
        //| {}
        //| MUL expr %prec UDEREF { }
        //| BITAND expr %prec UREF { }
        //| expr LBRACK expr RBRACK %prec SUB {}
        ;
ids     : varexpr {printf("ids varexpr\n");}
        | ids ',' varexpr {printf("ids , varexpr\n");}
        ;
varexpr : var {printf("varexpr var\n");}
        | var '=' expr {printf("varexpr: var = expr\n");}
        | var '=' initlist {}
        ;
var     : ID { printf("var ID %s\n", $1->name); }
        //| '*' var %prec '!' {}
        | var '[' INTEGER ']' { }
        | var '[' ']' {}
        | '(' var ')' {  }
        ;
def_stmt: types ids  { printf("def_stmt types ids\n");}
        //| def_stmt ',' def_stmt    {printf("def_stmt second\n");}
        ;
if_stmt      : IF '(' expr ')' stmt {}
        | IF '(' expr ')' stmt ELSE stmt {  }
        //| expr '?' stmt ':' stmt {} put it in expr
        ;
while_stmt   : WHILE '(' expr ')' stmt  {}
        | DO stmt WHILE '(' expr ')'    {}
        ;
for_stmt: FOR '(' for_init_args ';' expr ';' for_action_args ')' stmt {}
        ;
for_init_args: def_stmt {}
        | ids   {}
        ;
for_action_args:    {}
        | expr      {}
        ;
return_stmt  : RETURN expr {}
        ; 

%%

/////////////////////////////////////////////////////////////////////////////
// programs section

int main(void)
{
    int n = 1;
    mylexer lexer;
    myparser parser;
    if (parser.yycreate(&lexer)) {
        if (lexer.yycreate(&parser)) {
            n = parser.yyparse();
        }
    }
    return n;
}

