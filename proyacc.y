%union {
int number;
char* string;
node* tree;
}
%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
typedef struct node
{
 char *token;
 struct node *left;
 struct node *right;
} node;
node *mknode(char *token, node *left, node *right);
void printtree(node *tree,int i);
void printtree(node *tree, int i);

char id_arr[10][10],id[10];
int type_arr[10],i = 0, j = 0, k = 0;
int flag = 0, first_type = 0;

%}
%token <string> ID
%token INT REAL NUM BOOL CHAR STRING INT_P REAL_P CHAR_P IF ELSE WHILE VAR FUNC PROC RETURN NULLL AND DIV ASSIGN EQUAL BIGGER BIGGEREQ SMALLER SMALLEREQ MINUS NOT NOTEQ OR PLUS MULTIPLY REFERENCE POWER BOOLFALSE BOOLTRUE SEMICOLON COLON COMMA PIPE LBRACE RBRACE LBRACKET RBRACKET LSQRBR RSQRBR ID STRING_LTL CHAR_LTL HEX_LTL REAL_LTL
%type <tree> Program Proc_Func Funct s exp//Proce exp Param Param_list Var_id Type
%left PLUS MINUS RETURN
%left MULTIPLY DIV
%left EQUAL NOTEQ OR AND BIGGER BIGGEREQ SMALLER SMALLEREQ
%left SEMICOLON
%%
s: Program { printf("OK\n"); print(); test(); };
Program: Proc_Func {$$ = mknode("CODE",$1,NULL); };
Proc_Func: Proc_Func Funct {$$ = mknode("",$1,$2); }
		  | Proc_Func Proce {$$ = mknode("",$1,$2); }
		  | Funct {$$ =$1;}// mknode("",$1,NULL); }
		  | Statement {$$ = mknode("",$1,NULL); }
		  | Proce {$$ = mknode("",$1,NULL); }
		  |{$$=NULL;};
Funct: FUNC id LBRACKET Param RBRACKET RETURN Type LBRACE Body RBRACE {$$ = mknode("FUNC",mknode("",mknode("",$2,NULL),mknode("ARGS",$4,mknode("RETURN",$7,NULL))),mknode("",$9,NULL)); };
Proce: PROC id LBRACKET Param RBRACKET LBRACE Body RBRACE {$$ = mknode("PROC",mknode("",mknode("",$2,NULL),mknode("ARGS",$4,mknode("",$7,NULL))),NULL); };
Param: Param_list {$$ = mknode("",$1,NULL); }
	|{$$ =NULL;};
	 
Param_list: Var_id COLON Type {$$ = mknode("",$3,mknode("",$1,mknode(")",NULL,NULL))); }
		  | Param_list SEMICOLON Param_list {$$ = mknode("",$1,mknode("",$3,NULL)); };
Var_id: id COMMA Var_id {$$ = mknode("",mknode("",$1,NULL),$3); }
	  | id {$$ = mknode(yytext,NULL,NULL); };
Type: BOOL {$$ = mknode("BOOLEAN",NULL,NULL); }
	| CHAR {$$ = mknode("CHAR",NULL,NULL); }
	| INT {$$ = mknode("INT",NULL,NULL); }
	| REAL {$$ = mknode("REAL",NULL,NULL); }
	| INT_P {$$ = mknode("INT_P",NULL,NULL); }
	| REAL_P {$$ = mknode("REAL_P",NULL,NULL); }
	| CHAR_P {$$ = mknode("CHAR_P",NULL,NULL); };

Body: Proc_Func Declares Statements {$$= mknode ("BODY",mknode("",$1,NULL),mknode("",$2,mknode("",$3,mknode("",NULL,NULL))));};


Declares: Declares Declare {$$= mknode ("",$1,$2);}
		|{$$=NULL;};
Declare: VAR Var_id COLON Type SEMICOLON {$$= mknode ("VAR",$2,$4);};
Statements: Statements Statement {$$= mknode ("",$1,$2);}
			|{$$=NULL;};
Statement: IF LBRACKET exp RBRACKET ST_Block {$$ = mknode("IF",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | IF LBRACKET exp RBRACKET ST_Block ELSE ST_Block {$$=mknode("IF ELSE", mknode("",$3,mknode("",NULL,NULL)),mknode("",$5,mknode("",$7,NULL)));}
		 | WHILE LBRACKET exp RBRACKET ST_Block {$$=mknode("WHILE",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | ST_Assign SEMICOLON {$$=mknode("",$1,NULL);}
		 | exp SEMICOLON {$$=$1;}
		 | RETURN exp SEMICOLON {$$=mknode("RETURN",$2,NULL);}
		 | NEW_Block {$$=$1;};


ST_Block: Statement {$$=$1;}
		| Declare {$$=$1;}
		| Proce {$$=$1;}
		| Funct {$$=$1;}
		| SEMICOLON {$$=mknode("",NULL,NULL);};
		

NEW_Block: LBRACE Proc_Func Declares Statements RBRACE {$$= mknode ("{",$2,mknode("",$3,mknode("",$4,("}",NULL,NULL))));};
	
ST_Assign: Ll ASSIGN exp {$$= mknode("=",$1,$3);};

Ll: id LSQRBR exp RSQRBR
  | id {$$ = mknode("",$1,NULL); }
  | ;

exp: exp EQUAL exp {$$= mknode ("==",$1,$3);}
   | exp NOTEQ exp {$$= mknode ("!=",$1,$3);}
   | exp BIGGER exp {$$= mknode (">",$1,$3);}
   | exp BIGGEREQ exp {$$= mknode (">=",$1,$3);}
   | exp SMALLER exp {$$= mknode ("<",$1,$3);}
   | exp SMALLEREQ exp {$$= mknode ("<=",$1,$3);}
   | exp AND exp {$$= mknode ("&&",$1,$3);}
   | exp OR exp {$$= mknode ("||",$1,$3);}
   | exp PLUS exp {$$= mknode ("+",$1,$3);}
   | exp MINUS exp {$$= mknode ("-",$1,$3);}
   | exp MULTIPLY exp {$$= mknode ("*",$1,$3);}
   | exp DIV exp {$$= mknode ("/",$1,$3);}
   | NOT exp {$$= mknode ("!",$2,NULL);}
   | BOOLTRUE {$$= mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   | BOOLFALSE {$$= mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   | exp DEF | DEF;
   |id {$$ = mknode("",$1,NULL); }
   |CHAR_LTL {$$= mknode ($1,mknode("CHAR",NULL,NULL),NULL);}
   | NUM {$$ = mknode(yytext,NULL,NULL); };
id: ID {$$ = mknode(yytext,NULL,NULL); };
   //| NULLL;
   
DEF: INT ID ';' { strcpy(id_arr[i],$2); i++; type_arr[j]=0; j++; };
 | DOUBLE ID ';' { strcpy(id_arr[i],$2); i++; type_arr[j]=1; j++; };
 | CHAR ID ';‘ ; { strcpy(id_arr[i],$2); i++; type_arr[j]=2; j++; };
 


%%
#include "lex.yy.c"
main()
{
	printf("ENTER ID NAME :\n ");
	scanf("%s\n ",id);
	return yyparse();
}

node *mknode(char *token,node *left,node *right)
{
 node *newnode = (node*)malloc(sizeof(node));
 char *newstr = (char*)malloc(sizeof(token) + 1);
 strcpy(newstr,token);
 newnode->left = left;
 newnode->right = right;
 newnode->token = newstr;
 return newnode;
}

void printtree(node *tree, int i){
/*
	char temp[5] = {'s','k','i','p','\0'};
	if (strcmp(tree->token,temp)){
		skip(); 
	}
*/	 int j=0;
 	for(j=0;j<i;j++)
     	printf("   ");
	printf("%s\n", tree->token);
 	if(tree->left)
  		printtree(tree->left, i+1);
 	if(tree->right)
  	printtree(tree->right, i-1);
}
void skip(){
     printf("   ");
}
int yyerror(char *err) {
    int yydebug = 1;
    fflush(stdout);
    fprintf(stderr, "Error: %s at line %d\n", err, yylineno);
    fprintf(stderr, "does not accept '%s'\n", yytext);
    return 0;

}

void print()
{
 for(k=0;k<i;k++)
 {
 printf("%d ",type_arr[k]);
 printf("%s\n",id_arr[k]);
 }
}

void test()
{
for(k=0;k<i;k++)
{
 if(strcmp(id_arr[k],id)==0)
 {
 if(flag==0)
 {
 flag=1;
 first_type=type_arr[k];
 }
 else
 {
 if(first_type==type_arr[k])
 printf("DECLARATION ERROR %s\n",id);
 else
 printf("REDECLARATION %s\n",id);
 }
 }
 }
}


