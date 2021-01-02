%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define false 0
#define true 1
typedef struct node
{
 char *token;
 struct node *left;
 struct node *right;
} node;
typedef struct Stack {
	int top;
	unsigned capacity;
	struct args* array;
}Stack;
typedef struct linkList {
struct args* argu;
struct linkList* next;
struct linkList* head;
}linkList;

typedef struct args{
	//struct args* next;
	char* data;
	char* type;
	int scope;
}args;

struct args* array[200];
int count4Arr=0;
int scope=1;

int isFull(struct Stack* stack);int isEmpty(struct Stack* stack);void push(struct Stack* stack, int item);int pop(struct Stack* stack);int peek(struct Stack* stack);
args* creatArgs(int s, char* d);//, char* t);
node *mknode(char *token, node *left, node *right);
void printtree(node *tree,int i);
void buildLinkList(args*);
void printArr(args* arr[],int x);
int checkMain(args* arr[], int size);
//int checkArgumentName(args* arr[], int size);
//#define YYSTYPE struct node*
#define YYSTYPE struct args*
#define YYSTYPE struct linkList*
//#define YYSTYPE struct Struct*




/*#define YYSTYPE struct linkList*
#define YYSTYPE struct Stack*
*/
%}
/*
%union {
int number;
char* string;
node* tree;
}
*/
//%token <string> ID
%token INT REAL NUM BOOL CHAR STRING INT_P REAL_P CHAR_P IF ELSE WHILE VAR FUNC PROC RETURN NULLL AND DIV ASSIGN EQUAL BIGGER BIGGEREQ SMALLER SMALLEREQ MINUS NOT NOTEQ OR PLUS MULTIPLY REFERENCE DEREFERENCE BOOLFALSE BOOLTRUE SEMICOLON COLON COMMA LEN LBRACE RBRACE LBRACKET RBRACKET LSQRBR RSQRBR ID STRING_LTL CHAR_LTL HEX_LTL REAL_LTL
//%type <tree> Program Proc_Func Funct s exp//Proce exp Param Param_list Var_id Type
%left PLUS MINUS RETURN
%left MULTIPLY DIV
%left EQUAL NOTEQ OR AND BIGGER BIGGEREQ SMALLER SMALLEREQ
%left SEMICOLON
%%
s: Program {//int i=checkArgumentName(array, count4Arr);
	//printf("SSSSSS->%d",i); 
	//printArr(array, count4Arr);};
	};
Program: Proc_Func {$$ = $1;};
Proc_Func: Proc_Func Funct {}
		  | Proc_Func Proce {}
		  | Funct {$$ =$1;}
		  | Statement {}
		  | Proce {}
		  |{};
Funct: FUNC id LBRACKET{scope++;} Param RBRACKET RETURN Type LBRACE Body RBRACE { 
array[count4Arr]=creatArgs(scope,"Func");
count4Arr++;
scope--;
//printf("$2->%s\n",$2);
//printf("$4->%s\n",$4);
//printf("$7->%s\n",$7);
//printf("$9->%s\n",$9);
//printf("\n");
//strcat($2,strcat($4,strcat($7,$9)));
//buildLinkList($2,$4,$7,$9);
//printf("$7===> %s\n",$7);
};
Proce: PROC id LBRACKET{scope++;} Param RBRACKET LBRACE Body RBRACE { 
		if (strcmp($2,"Main")==0){
			if ($4!=NULL){
				printf("Main cannot get arguments");
				exit(1);
			}
		}scope--;};
Param: Param_list {}
	|{};
	 
Param_list: Var_id COLON Type {}
		  | Param_list SEMICOLON Param_list { };
Var_id: id COMMA Var_id {$$=$1;}
	  | id {$$ = $1;};
Type: BOOL {array[count4Arr]=creatArgs(scope,"bool");count4Arr++;}
	| CHAR { array[count4Arr]=creatArgs(scope,"char");count4Arr++;}
	| INT { array[count4Arr]=creatArgs(scope,"int");count4Arr++;$$=$1;}
	| REAL {array[count4Arr]= creatArgs(scope,"real");count4Arr++;$$=$1;}
	| INT_P {array[count4Arr]=creatArgs(scope,"int_p");count4Arr++;$$=$1;}
	| REAL_P { array[count4Arr]=creatArgs(scope,"real_p");count4Arr++;$$=$1;}
	| CHAR_P {array[count4Arr]=creatArgs(scope,"char_p");count4Arr++; $$=$1;}
	| add_exps {}
	| LEN id LEN {}
	| STRING LSQRBR NUM RSQRBR {array[count4Arr]=creatArgs(scope,"string")
					;count4Arr++;};

Body:Proc_Func Declares Statements {};


Declares: Declares Declare {}
		|{};
Declare: VAR Var_id COLON Type SEMICOLON{};//printf("type--->%s\n",$4);};
Statements: Statements Statement {}
			|{};
Statement: IF LBRACKET exp RBRACKET ST_Block {if (strcmp($3,"bool")!=0){
								printf("statement IF need contain boolian");
								}}

		 | IF LBRACKET exp RBRACKET ST_Block ELSE ST_Block {if (strcmp($3,"bool")!=0){
								printf("statement IF need contain boolian");
								}}
		 | WHILE LBRACKET exp RBRACKET ST_Block {if (strcmp($3,"bool")!=0){
								printf("statement WHILE need contain boolian");
								}}
		 | ST_Assign SEMICOLON {$$=$1;}
		 | exp SEMICOLON {$$=$1;}
		 | RETURN exp SEMICOLON {}
		 | NEW_Block {$$=$1;};


ST_Block: Statement {$$=$1;}
		| Declare {$$=$1;}
		| Proce {$$=$1;}
		| Funct {$$=$1;}
		| SEMICOLON {};
		

NEW_Block: LBRACE{scope++;} Proc_Func Declares Statements RBRACE {scope--;};
	
ST_Assign: Lh ASSIGN exp {array[count4Arr]=creatArgs(scope,"=");count4Arr++;};

Lh: id LSQRBR exp RSQRBR{}
  | id {$$ =$1;}
  | d_exp {} ;
  | ;
exp: LBRACKET exp RBRACKET {}
   |exp EQUAL exp {array[count4Arr]=creatArgs(scope,"=="); count4Arr++; $$= "bool";}
   | exp NOTEQ exp {array[count4Arr]=creatArgs(scope,"!="); count4Arr++;$$= "bool";}
   | exp BIGGER exp {array[count4Arr]=creatArgs(scope,">"); count4Arr++;$$= "bool";}
   | exp BIGGEREQ exp {array[count4Arr]=creatArgs(scope,">="); count4Arr++;$$= "bool";}
   | exp SMALLER exp {array[count4Arr]=creatArgs(scope,"<"); count4Arr++;$$= "bool";}
   | exp SMALLEREQ exp {array[count4Arr]=creatArgs(scope,"<="); count4Arr++;$$= "bool";}
   | exp AND exp {array[count4Arr]=creatArgs(scope,"&&"); count4Arr++;}
   | exp OR exp {array[count4Arr]=creatArgs(scope,"||"); count4Arr++;}
   | exp PLUS exp {array[count4Arr]=creatArgs(scope,"+"); count4Arr++;}
   | exp MINUS exp {array[count4Arr]=creatArgs(scope,"-"); count4Arr++;}
   | exp MULTIPLY exp {array[count4Arr]=creatArgs(scope,"*"); count4Arr++;}
   | exp DIV exp {array[count4Arr]=creatArgs(scope,"/"); count4Arr++;}
   | NOT exp {}
   | add_exps {}
   | d_exp {}
   | call_function {}
   | NUM { }
   | PLUS NUM {}
   | MINUS NUM {}
   | HEX_LTL {}
   | CHAR_LTL {}  
   | REAL_LTL {}
   | PLUS REAL_LTL {}
   | MINUS REAL_LTL {}
   | STRING_LTL {}
   | BOOLTRUE {}
   | BOOLFALSE {}
   | LEN id LEN {}
   | ID LSQRBR exp RSQRBR {}
   |id {$$ = $1;}
   | NULLL {};
id: ID {$$ = $1;array[count4Arr]=creatArgs(scope,$1);count4Arr++; };
   //| NULLL;
exp_list: exp COMMA exp_list {}
	| exp {}
	| ;
add_exps: REFERENCE add_exps{}
	 | add_exp {};
add_exp: REFERENCE id {}
	| REFERENCE LBRACKET id RBRACKET {}
	| REFERENCE id LSQRBR exp RSQRBR {}
	| REFERENCE LBRACKET id LSQRBR exp RSQRBR RBRACKET {};
d_exp:    DEREFERENCE id {}
	| DEREFERENCE LBRACKET exp RBRACKET {}
	| DEREFERENCE id LSQRBR exp RSQRBR {};
par_exp: LBRACKET exp_list RBRACKET {};
call_function: id par_exp {};


%%
#include "lex.yy.c"
main()
{
	//scanf("%s\n ",id);
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
 void createStack(int size)
{
    Stack* stack = (Stack*)malloc(sizeof(Stack)*size);
	stack->capacity=size;
    stack->top = -1;
    stack->array = (args*)malloc(stack->capacity * sizeof(args));
}
args* creatArgs(int s, char* d)//, char* t)
	{
	args* newArg= (args*)malloc(sizeof(args));
	newArg->data = strdup(d);
	//newArg->type = strdup(t);
	newArg->scope=s;
	//printf("----%s",newArg->data);
	return newArg;
	}
void printArr(args* arr[], int x){
	//printf("COS AIM AIM MA SHEL CENTOS\n");
	for (int i=0;i<x;i++){
		printf("Num of Struct in Array: %d \n", i);
		printf("Contains the following data: \n");
		printf("The data is: %s-\n" , arr[i]->data);
		printf("The number of scope is: %d\n",arr[i]->scope);
		printf("\n");
	}
}
int checkMain(args* arr[], int size){
	int count=0;
	for (int i=0;i<size;i++){
		if (strcmp(arr[i]->data,"Main")==0){	
			count++;
		}
	}
	printf("COUNT->%d\n",count);
	if (count>1){
		return 0;
	}
	else{
		return 1;
	}
}
int splitArr2scope(args* arr[], int size , int scope){
	int stepW=0,stepA=0;
	for (int i=0;i<scope;i++){
		args* newArg[100] ; 
		while (arr[stepW]->scope==i && stepW<size){
			 newArg[stepA]=arr[stepW];
			 stepA++;
			 stepW++;
		}
	//NewArgs is the scope array - Here can check the specific scope ! //
	}
}
/*
int checkArgumentName(args* arr[], int size){
	
	for (int i=0;i<size;i++){
		for (int j=0;j<size;j++){
			if (arr[i]->scope == arr[j]->scope){
				if (strcmp(arr[i]->data,"var")==0){
					while (strcmp(arr[j]->data,"char")!=0)||(strcmp(arr[j]->data,"int")!=0)||(strcmp(arr[j]->data,"real")!=0)||
						(strcmp(arr[j]->data,"char_p")!=0)||(strcmp(arr[j]->data,"int_p")!=0)||(strcmp(arr[j]->data,"real_p")!=0)||(strcmp(arr[j]->data,"string")!=0)){
					if (strcmp(arr[j]->data,arr[j]->data)==0){
					 	return false;
					}
					j++;
				}
			}
		}
	}
	return true;
}
*/
/*
int checkSameName(args* arr[], int size){
	for (int i=0;i<size;i++){
		}
	return 0;
}
*/
/*
linkList* buildLinkList(args* newArg)
{
	linkList *newLink = (linkList*)malloc(sizeof(linkList));
	newLink->argu = newArg;
	newLink->next =NULL;
	newLink->head =newLink;
	return newLink;
	
}
*/
/*
void add2Link(args* newArg){
	if
*/
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

