%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stdbool.h>
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
	int type;
	int scope;
}args;

struct args* array[100];
char* scopeList[10];
int count4Arr=0;
int scope=1;

int isFull(struct Stack* stack);int isEmpty(struct Stack* stack);void push(struct Stack* stack, int item);int pop(struct Stack* stack);int peek(struct Stack* stack);
args* creatArgs(int s, char* d);//, char* t);
node *mknode(char *token, node *left, node *right);
void printtree(node *tree,int i);
void buildLinkList(args*);
void printArr(args* arr[],int x);
bool mainCheck();
void addScope(char* name);
bool ifApear(char* name);
int getType(char *token);
args* initArgs();
char* numToType(int type);
//#define YYSTYPE struct node*
#define YYSTYPE struct args*
//#define YYSTYPE struct linkList*
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
%token INT REAL NUM BOOL CHAR STRING INT_P REAL_P CHAR_P IF ELSE WHILE VAR FUNC PROC RETURN NULLL AND DIV ASSIGN EQUAL BIGGER BIGGEREQ SMALLER SMALLEREQ MINUS NOT NOTEQ OR PLUS MULTIPLY REFERENCE POWER BOOLFALSE BOOLTRUE SEMICOLON COLON COMMA PIPE LBRACE RBRACE LBRACKET RBRACKET LSQRBR RSQRBR ID STRING_LTL CHAR_LTL HEX_LTL REAL_LTL
//%type <tree> Program Proc_Func Funct s exp//Proce exp Param Param_list Var_id Type
%left PLUS MINUS RETURN
%left MULTIPLY DIV
%left EQUAL NOTEQ OR AND BIGGER BIGGEREQ SMALLER SMALLEREQ
%left SEMICOLON
%%
s: Program {printf("start\n");printArr(array, count4Arr); };
Program: Proc_Func {$$ =printf("Program\n");$$ = $1;};//mknode("CODE",$1,NULL); };
Proc_Func: Proc_Func Funct {printf("Proc_Funct Funct\n");}//{$$ = mknode("",$1,$2); }
		  | Proc_Func Proce {$$ = mknode("",$1,$2); }
		  | Funct {printf("Funct\n");$$ =$1;}// mknode("",$1,NULL); }
		  | Statement {printf("proc_func statement\n");}//$1;}// mknode("",$1,NULL); }
		  | Proce {$$ = mknode("",$1,NULL); }
		  |{printf("procfuncnull\n");$$="NULL";};
Funct: FUNC id LBRACKET Param RBRACKET RETURN Type LBRACE Body RBRACE {$$ = addScope($2);array[count4Arr]=creatArgs(scope,"Func");count4Arr++;scope++;printf("func\n");printf("\n");};
//addScope($2);//mknode("FUNC",mknode("",mknode("",$2,NULL),mknode("ARGS",$4,mknode("RETURN",$7,NULL))),mknode("",$9,NULL)); 

//strcat($2,strcat($4,strcat($7,$9)));
//buildLinkList($2,$4,$7,$9);
//printf("$7===> %s\n",$7);};
Proce: PROC id LBRACKET Param RBRACKET LBRACE Body RBRACE {$$ = mknode("PROC",mknode("",mknode("",$2,NULL),mknode("ARGS",$4,mknode("",$7,NULL))),NULL);}; 
Param: Param_list {$$ =$1;mknode("",$1,NULL); }
	|{$$ ="NULL";};
	 
Param_list: Var_id COLON Type 
		{ printf("paramlist\n");
			array[count4Arr]=creatArgs(scope,$3);
			count4Arr++;}
		  | Param_list SEMICOLON Param_list {$$ = mknode("",$1,mknode("",$3,NULL)); };
Var_id: id COMMA Var_id { printf("varid\n");}//strcat(strcat($1,","),$3);}//mknode("",mknode("",$1,NULL),$3); }
	  | id {$$ = $1;};//$1;mknode(yytext,NULL,NULL);};
Type: BOOL {$$ ="BOOL"; mknode("BOOLEAN",NULL,NULL); }
	| CHAR {$$ ="char"; mknode("CHAR",NULL,NULL); }
	| INT {$$ ="int"; mknode("INT",NULL,NULL);printf("int\n"); }
	| REAL {$$ ="real"; mknode("REAL",NULL,NULL); }
	| INT_P {$$ = "int_P"; mknode("INT_P",NULL,NULL); }
	| REAL_P {$$ = "real_P"; mknode("REAL_P",NULL,NULL); }
	| CHAR_P {$$ = "char_P"; mknode("CHAR_P",NULL,NULL); };

Body: Proc_Func Declares Statements {sprintf($$,"%s%s%s",$1,$2,$3);};// $$=strcat("body","dasd");//strcat($1,strcat($2,$3))); //mknode ("BODY",mknode("",$1,NULL),mknode("",$2,mknode("",$3,mknode("",NULL,NULL))));


Declares: Declares Declare { printf("Declares\n");}//strcat($1,$2);}//mknode ("",$1,$2);}
		|{printf("Declares null\n");};//"NULL";};
Declare: VAR Var_id COLON Type SEMICOLON {$$= strcat($1,$3);};// mknode ("VAR",$2,$4);};
Statements: Statements Statement { printf("statments\n");}//strcat($1,$2);}//mknode ("",$1,$2);}
			|{printf(" statemtnsNULL\n");};
Statement: IF LBRACKET exp RBRACKET ST_Block {
printf("if\n"); }//strcat("IF",strcat($3,$5));}
//mknode("IF",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | IF LBRACKET exp RBRACKET ST_Block ELSE ST_Block {$$=mknode("IF ELSE", mknode("",$3,mknode("",NULL,NULL)),mknode("",$5,mknode("",$7,NULL)));}
		 | WHILE LBRACKET exp RBRACKET ST_Block {$$=mknode("WHILE",mknode("(",$3,mknode(")",NULL,NULL)),$5);}
		 | ST_Assign SEMICOLON {$$=$1;printf("ST_ASSIGN\n");}//mknode("",$1,NULL);}
		 | exp SEMICOLON {$$=$1;printf("exp semiclon\n");}
		 | RETURN exp SEMICOLON {$$=mknode("RETURN",$2,NULL);}
		 | NEW_Block {$$=$1;printf("NEW BLK\n");};


ST_Block: Statement {$$=$1;}
		| Declare {$$=$1;}
		| Proce {$$=$1;}
		| Funct {$$=$1;}
		| SEMICOLON {printf(";");};//mknode("",NULL,NULL);};
		

NEW_Block: LBRACE Proc_Func Declares Statements RBRACE { 
printf("newblk\n");}//strcat("newBlock",strcat($2,strcat($3,$4)));};
// mknode ("{",$2,mknode("",$3,mknode("",$4,("}",NULL,NULL))));};
	
ST_Assign: Ll ASSIGN exp {$$=printf("stassign\n");array[count4Arr]=creatArgs(scope,"=");count4Arr++;}//strcat($1,strcat("=",$3));};// mknode("=",$1,$3);};

Ll: id LSQRBR exp RSQRBR{}
  | id {$$ =$1;}// mknode("",$1,NULL); }
  | ;

exp: exp EQUAL exp {$$= array[count4Arr]=creatArgs(scope,"==");
	count4Arr++; mknode ("==",$1,$3);}
   | exp NOTEQ exp {$$= array[count4Arr]=creatArgs(scope,"!=");
	count4Arr++; mknode ("!=",$1,$3);}
   | exp BIGGER exp {$$=array[count4Arr]=creatArgs(scope,">");
	count4Arr++; printf("expbig\n");}//strcat($1,strcat(">",$3));}// mknode (">",$1,$3);}
   | exp BIGGEREQ exp {$$= array[count4Arr]=creatArgs(scope,">=");
	count4Arr++; mknode (">=",$1,$3);}
   | exp SMALLER exp {$$= array[count4Arr]=creatArgs(scope,"<");
	count4Arr++; mknode ("<",$1,$3);}
   | exp SMALLEREQ exp {$$= array[count4Arr]=creatArgs(scope,"<=");
	count4Arr++; mknode ("<=",$1,$3);}
   | exp AND exp {$$= array[count4Arr]=creatArgs(scope,"&&");
	count4Arr++; mknode ("&&",$1,$3);}
   | exp OR exp {$$= array[count4Arr]=creatArgs(scope,"||");
	count4Arr++; mknode ("||",$1,$3);}
   | exp PLUS exp {$$= array[count4Arr]=creatArgs(scope,"+");
	count4Arr++; mknode ("+",$1,$3);}
   | exp MINUS exp {$$= array[count4Arr]=creatArgs(scope,"-");
	count4Arr++; mknode ("-",$1,$3);}
   | exp MULTIPLY exp {$$= array[count4Arr]=creatArgs(scope,"*");
	count4Arr++; mknode ("*",$1,$3);}
   | exp DIV exp {$$= array[count4Arr]=creatArgs(scope,"/");
	count4Arr++; mknode ("/",$1,$3);}
   | NOT exp {$$= array[count4Arr]=creatArgs(scope,"!");
	count4Arr++; mknode ("!",$2,NULL);}
   | BOOLTRUE {$$= array[count4Arr]=creatArgs(scope,"TRUE");
	count4Arr++; mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   | BOOLFALSE {$$= array[count4Arr]=creatArgs(scope,"FALSE");
	count4Arr++; mknode ("",mknode("BOOLEAN",$1,NULL),NULL);}
   |id {$$ = $1;}//mknode("",$1,NULL); }
   |CHAR_LTL {$$= mknode ($1,mknode("CHAR",NULL,NULL),NULL);}
   | NUM {$$ = mknode(yytext,NULL,NULL); };
id: ID {$$ = array[count4Arr]=creatArgs(scope,$1);count4Arr++; };//mknode(yytext,NULL,NULL); };
   //| NULLL;


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
		printf("%s-" , arr[i]->data);
		printf("%d",arr[i]->scope);
		printf("%s",numToType(arr[i]->type));
		printf("\n");
	}
}
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


bool mainCheck(){
	bool mainFlagApear = 0;
	bool moreThanOneMain = 0;
	for(int i=0;i<scope;i++){
		if (strcmp("Main",scopeList[i])==0){
			if(mainFlagApear ==1){
				moreThanOneMain=1;
			mainFlagApear=1;
			}
		}// strcmp
	
	}//for
	if(mainFlagApear == 0){
		printf("No main in the program\n");
		return false;
		}
	else if (moreThanOneMain ==1){
		printf("more than one main\n");
		return false;
		}
	else if (mainFlagApear ==1 && moreThanOneMain ==0){
		printf("OK \n");
		return true;
		}
			
}

void addScope(char* name){
	if (ifApear(name)== 0){
		strcpy(scopeList[scope-1],name);
		printf("OK scope\n");
	}
	else
		printf("%s has already declared!!\n",name);

}//func

bool ifApear(char* name){
	for(int i=0;i<scope;i++){
		if (strcmp(name,scopeList[i])==0)
			return true;
	}
	return false;
}//func

void testVar(char* name){
	int firstType;
	bool apear = false;
	for (int i=0;i<count4Arr;i++){
		if (strcmp(name,array[i]->data)==0){
			if( apear == false){
				apear=true;
				firstType = array[i]->type; //no type
			}//if not apear
			else{
				if (firstType != array[i]->type){
					printf("type error!\n");
				}//if not type
			}//else
		}//if strcmp
	}//for
}//func

int getType(char *token){
	// cant do switch case because c not support str .
	if (strcmp(token,"INT")==0)
		return 1;
	else if (strcmp(token,"REAL")==0)
		return 2;
	else if (strcmp(token,"CHAR")==0)
		return 3;
	else if (strcmp(token,"BOOL")==0)
		return 4;
	else if (strcmp(token,"INT_P")==0)
		return 5;
	else if (strcmp(token,"REAL_P")==0)
		return 6;
	else if (strcmp(token,"CHAR_P")==0)
		return 7;
	else if (strcmp(token,"STRING")==0)
		return 8;
}// get type

void splitDataType(args* arg){
	char* typeStr;
	char* data;
	int MAXSIZE = 10; //max size to check
	int i=0;
	while(arg->data[i] != '=' || arg->data[i] != '\0'){
		if (i>MAXSIZE)
			break;
		if (strlen(arg->data)>i+1){
			if (data[i] == '=' && data[i+1]!= '='){
				typeStr = (char*)malloc(sizeof(char)*i);
				strncpy(typeStr,arg->data,i-1);
				arg->type=getType(typeStr);
				data = (char*)malloc(sizeof(char)*strlen(arg->data)-i+1);
				int j=0;
				while(arg->data[i] !='\0')
					data[j] = arg->data[i];
				arg->data=data;
			}//if its type
		i++;
		}
	}//while
}//func
			
		

struct args* initArgs(){
	args* newArg = (args*)malloc(sizeof(args));
	newArg->data = NULL;
	newArg->type = 0;
	newArg->scope=0;
	return newArg;
}

char* numToType(int type){
	if (type==1)
		return "INT";
	else if (type==2)
		return "REAL";
	else if (type==3)
		return "CHAR";
	else if (type==4)
		return "BOOL";
	else if (type==5)
		return "INT_P";
	else if (type==6)
		return "REAL_P";
	else if (type==7)
		return "CHAR_P";
	else if (type==8)
		return "STRING";
	else
		return "";
}
