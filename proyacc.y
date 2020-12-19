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
typedef struct Stack {
	int top;
	unsigned capacity;
	int* array;
}Stack;
struct linkList { 
    char id[]; // name of var 
    struct linkList* next;
	struct linkList* head; //almog dont lose our head!
	int type; 
}; 
struct Stack* createStack(unsigned capacity)
{
	struct Stack* stack = (struct Stack*)malloc(sizeof(struct Stack));
	stack->capacity = capacity;
	stack->top = -1;
	stack->array = (int*)malloc(stack->capacity * sizeof(int));
	return stack;
}
node *mknode(char *token, node *left, node *right);
void printtree(node *tree,int i);
void printtree(node *tree, int i);
int isFull(struct Stack* stack);
int isEmpty(struct Stack* stack);
void push(struct Stack* stack, int item);
int pop(struct Stack* stack);
int peek(struct Stack* stack);
void buildLink (node* tree);
linkList makeList(char* id,linkList , prev);
int getType(char *token);
#define YYSTYPE struct node*
%}
/*
%union {
int number;
char* string;
node* tree;
}
*/
//%token <string> ID
%token INT REAL NUM BOOL CHAR STRING INT_P REAL_P CHAR_P IF ELSE WHILE VAR FUNC PROC RETURN NULLL AND DIV ASSIGN EQUAL BIGGER BIGGEREQ SMALLER SMALLEREQ MINUS NOT NOTEQ OR PLUS MULTIPLY REFERENCE POWER BOOLFALSE BOOLTRUE SEMICOLON COLON COMMA PIPE LBRACE RBRACE LBRACKET RBRACKET LSQRBR RSQRBR ID STRING_LTL CHAR_LTL HEX_LTL REAL_LTL
//%type <tree> Program Proc_Func Funct s exp//Proce exp Param Param_list Var_id Type
%left PLUS MINUS RETURN
%left MULTIPLY DIV
%left EQUAL NOTEQ OR AND BIGGER BIGGEREQ SMALLER SMALLEREQ
%left SEMICOLON
%%
s: Program { printf("OK\n"); printtree($1,1); };
Program: Proc_Func {$$ = mknode("CODE",$1,NULL); };
Proc_Func: Proc_Func Funct {$$ = mknode("S",$1,$2); }
		  | Proc_Func Proce {$$ = mknode("S",$1,$2); }
		  | Funct {$$ =$1;}// mknode("",$1,NULL); }
		  | Statement {$$ = mknode("S",$1,NULL); }
		  | Proce {$$ = mknode("S",$1,NULL); }
		  |{$$=NULL;};
//placement: id ASSIGN placement
Funct: FUNC id LBRACKET Param RBRACKET RETURN Type LBRACE Body RBRACE {$$ = mknode("FUNC",$2,mknode("ARGS",mknode("S",$4,$7),mknode("S",$9,NULL))); };
Proce: PROC id LBRACKET Param RBRACKET LBRACE Body RBRACE {$$ = mknode("PROC",$2,mknode("ARGS",$4,$7));};
Param: Param_list {$$ = $1;}//mknode("S",$1,NULL); }
	|{$$ =NULL;};
	 
Param_list: Var_id COLON Type {$$ = mknode("S",$3,mknode("S",$1,mknode("S",NULL,NULL))); }
		  | Param_list SEMICOLON Param_list {$$ = mknode("S",$1,mknode("S",$3,NULL)); };
Var_id: id COMMA Var_id {$$ = mknode("S",mknode("S",$1,NULL),$3); }
	  | id ;//{$$ = mknode(yytext,NULL,NULL); };
Type: BOOL {$$ = mknode("BOOLEAN",NULL,NULL); }
	| CHAR {$$ = mknode("CHAR",NULL,NULL); }
	| INT {$$ = mknode("INT",NULL,NULL); }
	| REAL {$$ = mknode("REAL",NULL,NULL); }
	| INT_P {$$ = mknode("INT_P",NULL,NULL); }
	| REAL_P {$$ = mknode("REAL_P",NULL,NULL); }
	| CHAR_P {$$ = mknode("CHAR_P",NULL,NULL); }
	| STRING LSQRBR NUM RSQRBR {$$ = mknode("STRING",NULL,NULL); };

Body: Proc_Func Declares Statements {$$= mknode ("BODY",mknode("S",$1,NULL),mknode("S",$2,mknode("S",$3,mknode("S",NULL,NULL))));};


Declares: Declares Declare {$$= mknode ("S",$1,$2);}
		|{$$=NULL;};
Declare: VAR Var_id COLON Type SEMICOLON {$$= mknode ("VAR",$2,$4);};
Statements: Statements Statement {$$= mknode ("S",$1,$2);}
			|{$$=NULL;};
Statement: IF LBRACKET exp RBRACKET ST_Block {$$ = mknode("IF",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | IF LBRACKET exp RBRACKET ST_Block ELSE ST_Block {$$=mknode("IF ELSE", mknode("S",$3,mknode("S",NULL,NULL)),mknode("S",$5,mknode("S",$7,NULL)));}
		 | WHILE LBRACKET exp RBRACKET ST_Block {$$=mknode("WHILE",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | ST_Assign SEMICOLON {$$=mknode("S",$1,NULL);}
		 | exp SEMICOLON {$$=$1;}
		 | RETURN exp SEMICOLON {$$=mknode("RETURN",$2,NULL);}
		 | NEW_Block {$$=$1;};


ST_Block: Statement {$$=$1;}
		| Declare {$$=$1;}
		| Proce {$$=$1;}
		| Funct {$$=$1;}
		| SEMICOLON {$$=mknode("S",NULL,NULL);};
		

NEW_Block: LBRACE Proc_Func Declares Statements RBRACE {$$= mknode ("{",$2,mknode("S",$3,mknode("S",$4,("}",NULL,NULL))));};
	
ST_Assign: Ll ASSIGN exp {$$= mknode("=",$1,$3);};

Ll: id LSQRBR exp RSQRBR {$$=mknode($1,mknode("[",$3,mknode("]",NULL,NULL)),NULL);}
  | id {$$ = mknode("S",$1,NULL); }
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
   | LBRACKET exp RBRACKET {$$= mknode ("(",$2,mknode(")",NULL,NULL));}
   | BOOLTRUE {$$= mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   | BOOLFALSE {$$= mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   |id {$$ = mknode("",$1,NULL); }
   |STRING_LTL {$$= mknode ($1,mknode("STRING",NULL,NULL),NULL);}
   |CHAR_LTL {$$= mknode ($1,mknode("CHAR",NULL,NULL),NULL);}
   |HEX_LTL {$$= mknode ($1,mknode("HEX",NULL,NULL),NULL);}
   |REAL_LTL {$$= mknode ($1,mknode("REAL",NULL,NULL),NULL);}
   | NUM {$$ = mknode(yytext,NULL,NULL); }
   | call_function {$$=$1;};
 
id: ID {$$ = mknode(yytext,NULL,NULL); };
   //| NULLL;

 
exp_list: exp COMMA exp_list {$$=mknode("S",$1,mknode(",",$3,NULL));}
	| exp {$$=mknode("S",$1,NULL);}
	| {$$=NULL;};
par_exp: LBRACKET exp_list RBRACKET {$$=$2;};
call_function: id par_exp {$$=mknode("FUNCTION CALL", mknode($1,NULL,NULL),mknode("ARGS",$2,NULL));};



%%
#include "lex.yy.c"
main()
{
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
/*
void printtree (node *tree, int tab){
	if (tree->token==NULL){
		return;
	}
	else{ 
		if (tree->token[0]=='S'){
			printf("\n");
			tab++;
			}
		else {
			//tab++;
			//printTabs(tab);
			printf(tree->token);
			//tab--;
			}
		if(tree->left){
			if (tree->token[0]=='S'){
				tab++;
			}
			printTabs(tab);
			printtree(tree->left,tab);
		}
		if(tree->right){
			if (tree->token[0]=='S'){
				tab++;
			}
			printTabs(tab);
			printtree(tree->right,tab);
		}
	}
}
	*/	
		
//BEST PRINTER:
void printtree (node *tree, int tab){
    int nextTab = tab;
    if (strlen(tree->token) > 0) {
	if(tree->token[0]!='S'){
        	printTabs(tab);
        	printf ("%s", tree->token);
	}
	else { 
		printf("\033[F");
		nextTab--;
		}
        if (tree->left != NULL) {
            printf("\n");
        }
    }
    if (tree->left) {
        if (strlen(tree->token) == 2) {
            nextTab--;
        }
        printtree(tree->left, nextTab + 1);
        if (strlen(tree->token) > 2) {
            printTabs(nextTab-1);
        }
    }
    if (strlen(tree->token) > 2) {
        printf (")\n");
    }
    if (tree->right) {
        printtree (tree->right, tab);
    }
}

void printTabs(int numOfTabs) {
    int i;
    for (i = 0; i < numOfTabs; i++) {
        printf ("\t");
    }
}
/*
void printtree(node *tree, int i)
{
 int j;
 for(j=1;j<i;j++)
     printf("   ");
 if (tree->token[0]!='S'){
 	printf("%s/n", tree->token);
	}
 else { printf("\n");}
 if (tree->token[0]!='A'){
	printf("(")
	}
 if(tree->left)
	printtree(tree->left, i+1);
	//printf("\n");
 if(tree->right)
  printtree(tree->right, i-1);
}
*/
//FUNCTION FOR STACK:
int isFull(struct Stack* stack)
{
	return stack->top == stack->capacity - 1;
}

int isEmpty(struct Stack* stack)
{
	return stack->top == -1;
}
void push(struct Stack* stack, int item)
{
	if (isFull(stack))
		return;
	stack->array[++stack->top] = item;
	printf("%d pushed to stack\n", item);
}

int pop(struct Stack* stack)
{
	if (isEmpty(stack))
		return NULL;
	return stack->array[stack->top--];
}

// Function to return the top from stack without removing it
int peek(struct Stack* stack)
{
	if (isEmpty(stack))
		return NULL;
	return stack->array[stack->top];
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
linkList makeList(char* id,linkList , prev){
	struct *linkList newList = (linkList*)malloc(sizeof(linkList));
	char *newstr = (char*)malloc(sizeof(id) + 1);
	strcpy(newstr,id);
	newList->id = newstr;
	newList->next = NULL;
	if (prev == NULL){
		newList->head = newList;
	}
	else{
		prev->next = newList;
		newList->head = prev->head;
	}
	return newList;
}

int getType(char *token){
	// cant do switch case because c not support str .
	if (strcmp(token,"INT")==0)
		return 0;
	else if (strcmp(token,"REAL")==0)
		return 1;
	else if (strcmp(token,"CHAR")==0)
		return 2;
	else if (strcmp(token,"BOOL")==0)
		return 3;
	else if (strcmp(token,"INT_P")==0)
		return 4;
	else if (strcmp(token,"REAL_P")==0)
		return 5;
	else if (strcmp(token,"CHAR_P")==0)
		return 6;
	else if (strcmp(token,"STRING")==0)
		return 7;
}
