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
struct args* IDArr[100];
struct args* funcArr[50];
struct args* array[200];
struct args* arrayEx[200];
int countIDArr=0;
int countFuncArr=0;
int count4Arr=0;
int count4ArrEx=0;
int scope=1;
int argCount=0;
char str1[50], str2[50];
int isFull(struct Stack* stack);int isEmpty(struct Stack* stack);void push(struct Stack* stack, int item);int pop(struct Stack* stack);int peek(struct Stack* stack);
args* creatArgs(int s, char* d);//, char* t);
node *mknode(char *token, node *left, node *right);
void printtree(node *tree,int i);
void buildLinkList(args*);
void printArr(args* arr[],int x);
int checkMain(args* arr[], int size);
char* checkTheType(char* token);
void createRow (char* str1, char* str2);
void createArgsRow(char* x, char* y,int* argCount);
void splitArr2scope(args* arr[], int size , int scope);
void createfuncRow (char* x, char* y);
void createprocRow (char* x, char* y);
char* number10(args* arr[], int x, char* y);
char* number10b(args* arr[], int x, char* y);
int checkArgumentName(args* arr[], int size,int scope);
void checkVarExist(char* var, args* arr[], int size);
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
	//splitArr2scope(arrayEx, count4ArrEx,scope);
	//checkFuncWithSameName(funcArr,countFuncArr);};
	//printArr(array,count4Arr);
	};
Program: Proc_Func {$$ = $1;};
Proc_Func: Proc_Func Funct {}
		  | Proc_Func Proce {}
		  | Funct {$$ =$1;}
		  | Statement {}
		  | Proce {}
		  |{};
Funct: FUNC ID LBRACKET Param RBRACKET RETURN Type LBRACE{scope++;} Body RBRACE { 
//printf("pParammm-> %s\n",$4);
createfuncRow($2,$7);
funcArr[countFuncArr]=creatArgs(scope,$2);
countFuncArr++;
arrayEx[count4ArrEx]=creatArgs(scope,"Func");
count4ArrEx++;
IDArr[countIDArr]=creatArgs(scope,$2);
countIDArr++;
scope--;

};
Proce: PROC ID LBRACKET Param RBRACKET LBRACE{scope++;} Body RBRACE { 
IDArr[countIDArr]=creatArgs(scope,$2);
			countIDArr++;
		if (strcmp($2,"Main")==0){
			if ($4!=NULL){
				printf("Main cannot get arguments");
				exit(1);
			}
		}
		createprocRow("proc",$2);
		//arrayEx[count4ArrEx]=creatArgs(scope,"Proc");
		//count4ArrEx++;
		scope--;};
Param: Param_list {}
	|{};
	 
Param_list: Var_id COLON Type {createArgsRow($1,$3,&argCount); printf ("paramlist->%s\n",$1);}
		  | Param_list SEMICOLON Param_list { };
Var_id: ID COMMA Var_id {$$=strcat(strcat($1,","),$3);
			IDArr[countIDArr]=creatArgs(scope,$1);
			countIDArr++;}
	  | ID {IDArr[countIDArr]=creatArgs(scope,$1);
		countIDArr++;
		$$=$1;};
Type: BOOL {arrayEx[count4ArrEx]=creatArgs(scope,"bool");count4ArrEx++;
$$="bool";}
	| CHAR { arrayEx[count4ArrEx]=creatArgs(scope,"char");count4ArrEx++;$$="char";}
	| INT { arrayEx[count4ArrEx]=creatArgs(scope,"int");count4ArrEx++;$$="int";}
	| REAL {arrayEx[count4ArrEx]= creatArgs(scope,"real");count4ArrEx++;$$=$1;$$="real";}
	| INT_P {arrayEx[count4ArrEx]=creatArgs(scope,"int_p");count4ArrEx++;$$=$1;$$="int_p";}
	| REAL_P { arrayEx[count4ArrEx]=creatArgs(scope,"real_p");count4ArrEx++;$$=$1;$$="real_p";}
	| CHAR_P {arrayEx[count4ArrEx]=creatArgs(scope,"char_p");count4ArrEx++; $$=$1;$$="char_p";}
	| add_exps {}
	| LEN id LEN {}
	| STRING LSQRBR NUM RSQRBR {arrayEx[count4ArrEx]=creatArgs(scope,"string")
					;count4ArrEx++;$$="string";};

Body:Proc_Func Declares Statements {};


Declares: Declares Declare {}
		|{};
Declare: VAR Var_id COLON Type SEMICOLON{createRow($2,$4); 
arrayEx[count4ArrEx]=creatArgs(scope,"var");count4ArrEx++;
 };//printf("type--->%s\n",$4);};
Statements: Statements Statement {}
			|{};
Statement: IF LBRACKET exp RBRACKET ST_Block {if (strcmp($3,"bool")!=0){
								printf("$3-> %s \n",$3);
								printf("statement IF need contain boolian");
								}}

		 | IF LBRACKET exp RBRACKET ST_Block ELSE ST_Block {if (strcmp($3,"bool")!=0){
								printf("ssstatement IF need contain boolian");
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
	
ST_Assign: Lh ASSIGN exp {arrayEx[count4ArrEx]=creatArgs(scope,"=");count4ArrEx++;
/*
				char* z,w;
				if (strcmp($1,$3) !=0){
					//z=strdup();
					//w=strdup();	
					//printf("THIS IS $1-> %s    ,   THIS IS $3-> %s  \n",$1,$3); 
					//printf("THIS RETURNS FROM NUMBER10B FUNCTION-> %s\n",number10b(array,count4Arr,$1));
					//printf("THIS RETURNS FROM NUMBER10 FUNCTION-> %s\n",number10(array,count4Arr,$3));
					if (strcmp(number10b(array,count4Arr,$1),number10(array,count4Arr,$3)) !=0)
						printf("HAHAHAHAHAHA\n");
				}
		 
						//printf("Error! return type from %s is not compatible to type of %s\n",w,z);
*/
};

Lh: id LSQRBR exp RSQRBR{$$="bool";}
  | id {$$ =$1;}
  | d_exp {} ;
  | ;
exp: LBRACKET exp RBRACKET {if (strcmp($2,"bool")==0){$$="bool";}}
   |exp EQUAL exp {array[count4Arr]=creatArgs(scope,"=="); count4Arr++;
arrayEx[count4ArrEx]=creatArgs(scope,"=="); count4ArrEx++; $$= strdup("bool");}
   | exp NOTEQ exp {array[count4Arr]=creatArgs(scope,"!="); count4Arr++;
arrayEx[count4ArrEx]=creatArgs(scope,"!="); count4ArrEx++;$$= "bool";}
   | exp BIGGER exp {array[count4Arr]=creatArgs(scope,">"); count4Arr++;$$= "bool";}
   | exp BIGGEREQ exp {array[count4Arr]=creatArgs(scope,">="); count4Arr++; arrayEx[count4ArrEx]=creatArgs(scope,">="); count4ArrEx++; $$= "bool";}
   | exp SMALLER exp {array[count4Arr]=creatArgs(scope,"<"); count4Arr++;
arrayEx[count4ArrEx]=creatArgs(scope,"<"); count4ArrEx++;$$= "bool";}
   | exp SMALLEREQ exp {array[count4Arr]=creatArgs(scope,"<="); count4Arr++;arrayEx[count4ArrEx]=creatArgs(scope,"<="); count4ArrEx++;$$= "bool";}
   | exp AND exp {array[count4Arr]=creatArgs(scope,"&&"); count4Arr++;}
   | exp OR exp {array[count4Arr]=creatArgs(scope,"||"); count4Arr++;}
   | exp PLUS exp {array[count4Arr]=creatArgs(scope,"+"); count4Arr++;}
   | exp MINUS exp {array[count4Arr]=creatArgs(scope,"-"); count4Arr++;}
   | exp MULTIPLY exp {array[count4Arr]=creatArgs(scope,"*"); count4Arr++;}
   | exp DIV exp {array[count4Arr]=creatArgs(scope,"/"); count4Arr++;
	arrayEx[count4ArrEx]=creatArgs(scope,"/"); count4ArrEx++;}
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
   | BOOLTRUE {$$="bool";}
   | BOOLFALSE {$$="bool";}
   | LEN id LEN {}
   | ID LSQRBR exp RSQRBR {}
   |id {$$ = $1;}
   | NULLL {};
id: ID {$$ = $1;array[count4Arr]=creatArgs(scope,$1);count4Arr++;
arrayEx[count4ArrEx]=creatArgs(scope,$1);count4ArrEx++; checkVarExist($1, IDArr, countIDArr);};
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
void checkVarExist(char* var, args* arr[], int size){
	int flag = false;
	for (int i=0;i<size;i++){
		if (strcmp(arr[i]->data,var)==0){
			flag=true;
		}
	}
	if (flag==false){
		printf("this-> %s not disclaimer!\n",var);
	}
}
void checkFuncWithSameName(args* arr[], int size){
	printf("checking function\n");
	 for (int i=0; i<size; i++){
		for (int j=i+1; j<size; j++){
			if (arr[i]->scope == arr[j]->scope){ 
				if(strcmp(arr[i]->data,arr[j]->data)==0){
					printf ("have 2 function with same name in scope - %d",arr[i]->scope);
				}
			}
		}
	}
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
	newArg->data = d;
	//newArg->type = strdup(t);
	newArg->scope=s;
	//printf("data----%s\n",newArg->data);
	return newArg;
	}
void createArgsRow(char* x, char* y,int* argCount){
if (strchr(x,',') == NULL){
int k=0,l=0;
					strcpy(str1,"arg "); strcpy(str2,x);
					//strcpy(str3,$3)
					while (str1[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						str1[k]=str2[l];
						k++; l++;
					}
					str1[k]='\0';
					char *temp =(char*) malloc(strlen(str1) + 3);
					strcpy(temp,strcat(str1," "));
					k=0,l=0;
					strcpy(str2,y);
					//strcpy(str3,$3)
					while (temp[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						temp[k]=str2[l];
						k++; l++;
					}
					temp[k]='\0';
//printf("NUMBER ARGS\n");
(*argCount)++;
//printf(" THIS IS TEMP: %s \n" , temp);
array[count4Arr]=creatArgs(scope,temp); count4Arr++;
	}
else {
	(*argCount)++;
	//printf("NUMBER ARGS\n");
	char* token=strtok(x,",");
	while (token!=NULL){
		createArgsRow(token,y,&argCount);
		token=strtok(NULL,",");
	}
}
}
void createfuncRow (char* x, char* y){
//if (strchr(x,',') == NULL){
int k=0,l=0;
					strcpy(str1,"func "); strcpy(str2,x);
					//strcpy(str3,$3)
					while (str1[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						str1[k]=str2[l];
						k++; l++;
					}
					str1[k]='\0';
					char *temp =(char*) malloc(strlen(str1) + 3);
					strcpy(temp,strcat(str1," "));
					k=0,l=0;
					strcpy(str2,y);
					//strcpy(str3,$3)
					while (temp[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						temp[k]=str2[l];
						k++; l++;
					}
					temp[k]='\0';
//printf(" THIS IS TEMP: %s \n" , temp);
array[count4Arr]=creatArgs(scope,temp); count4Arr++;
//	}
//else {
//	char* token=strtok(x,",");
//	while (token!=NULL){
//		createRow(token,y);
//		token=strtok(NULL,",");
//	}
//}

}

void createprocRow (char* x, char* y){
//if (strchr(x,',') == NULL){
int k=0,l=0;
					strcpy(str1,x); strcpy(str2,y);
					//strcpy(str3,$3)
					/*while (str1[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						str1[k]=str2[l];
						k++; l++;
					}
					str1[k]='\0';*/
					char *temp =(char*) malloc(strlen(str1) + 3);
					strcpy(temp,strcat(str1," "));
					k=0,l=0;
					//strcpy(str2,y);
					//strcpy(str3,$3)
					while (temp[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						temp[k]=str2[l];
						k++; l++;
					}
					temp[k]='\0';
//printf(" THIS IS TEMP: %s \n" , temp);
array[count4Arr]=creatArgs(scope,temp); count4Arr++;
	}
void createRow (char* x, char* y){
if (strchr(x,',') == NULL){
int k=0,l=0;
					strcpy(str1,"var "); strcpy(str2,x);
					//strcpy(str3,$3)
					while (str1[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						str1[k]=str2[l];
						k++; l++;
					}
					str1[k]='\0';
					char *temp =(char*) malloc(strlen(str1) + 3);
					strcpy(temp,strcat(str1," "));
//printf("THE LEN OF TEMP IS: %d\n",strlen(temp));
					k=0,l=0;
					strcpy(str2,y);
					//strcpy(str3,$3)
					while (temp[k]!='\0')
					k++;
					while (str2[l]!='\0')
					{
						temp[k]=str2[l];
						k++; l++;
					}
					temp[k]='\0';
//printf(" THIS IS TEMP: %s \n" , temp);
array[count4Arr]=creatArgs(scope,temp); count4Arr++;
	}
else {
	char* token=strtok(x,",");
	while (token!=NULL){
		createRow(token,y);
		token=strtok(NULL,",");
	}
}

}
char* number10(args* arr[], int x, char* y){
	int k=0,l=0;
	strcpy(str1,"func"); strcpy(str2,y);
	char *temp =(char*) malloc(strlen(str1) + 3);
	strcpy(temp,strcat(str1," "));
	k=0,l=0;
	while (temp[k]!='\0')
	k++;
	while (str2[l]!='\0')
	{
		temp[k]=str2[l];
		k++; l++;
	}
	temp[k]='\0';
	//printf("THIS IS TEMP %s\n",temp);
	
	char* res;
	for (int i=0;i<x;i++)
	{
		if (strstr(arr[i]->data,temp) != NULL)
		{
			//printf("this is num of struct in array that contains $3: %d\n",i);
			char* token=strtok(arr[i]->data," ");
			while (token!=NULL)
			{
				res=strdup(checkTheType(token));
				token=strtok(NULL," ");			
			}	
			//printf("RES---->: %s\n",res);
			return res;
		}

	}
	//printf("TEMP DIDNT FOUND IN ORIGINAL ARRAY \n");
	//res=strdup("no");
	return "no";
}
char* number10b(args* arr[], int x, char* y){
	int k=0,l=0;
	strcpy(str1,"var"); strcpy(str2,y);
	char *temp1 =(char*) malloc(strlen(str1) + 3);
	strcpy(temp1,strcat(str1," "));
	k=0,l=0;
	while (temp1[k]!='\0')
	k++;
	while (str2[l]!='\0')
	{
		temp1[k]=str2[l];
		k++; l++;
	}
	temp1[k]='\0';
	//printf("THIS IS TEMP1 %s\n",temp1);
	
	char* res1;
	for (int i=0;i<x;i++)
	{
		if (strstr(arr[i]->data,temp1) != NULL)
		{
			//printf("this is num of struct in array that contains $3: %d\n",i);
			char* token1=strtok(arr[i]->data," ");
			while (token1!=NULL)
			{
				res1=strdup(checkTheType(token1));
				token1=strtok(NULL," ");			
			}	
			//printf("RES1---->: %s\n",res1);
			return res1;
		}

	}
	//printf("TEMP1 DIDNT FOUND IN ORIGINAL ARRAY \n");
	//res1="no";
	return "no";

}
char* checkTheType(char* token){
if (strcmp(token,"bool") ==0)
	return "bool";
if (strcmp(token,"int") ==0)
	return "int";
if (strcmp(token,"real")==0)
	return "real";
if (strcmp(token,"string")==0)
	return "string";
if (strcmp(token,"char")==0)
	return "char";
return "null"; 
}
void printArr(args* arr[], int x){
	//printf("COS AIM AIM MA SHEL CENTOS\n");
	for (int i=0;i<x;i++){
		printf("Num of Struct in Array: %d \n", i);
		printf("Contains the following data: \n");
		printf("The data is: %s\n" , arr[i]->data);
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
void splitArr2scope(args* arr[], int size , int scope){
	scope = arr[size-1]->scope;
	//printf("scope->>>>>%d",scope);	
	int stepW=0,stepA,i;
	for (i=1;i<=scope;i++){
		stepA=0;
	//	printf("i ----> %d\n",i);
		args* newArg[100] ; 
		for (int j = 0 ; j<100;j++)
			newArg[j]=NULL;
		while (arr[stepW]->scope==i && stepW<size){
	//		printf("ASD");
			 newArg[stepA]=arr[stepW];
			 stepA++;
			 stepW++;
		}
		//stepW++;
		
	//	printf("step A -> %d\n",stepA);
		printArr(newArg, stepA);
		checkArgumentName(newArg,stepA,scope);
	}
}
int checkArgumentName(args* arr[], int size, int scope){
	
	for (int i=0;i<size;i++){
		for (int j=i+1;j<size;j++){
				if ((strcmp(arr[i]->data,"var")==0)&&(strcmp(arr[j]->data,"var")==0)){
					printf("VARIOSSSS\n");
					if (strcmp(arr[j-2]->data,arr[i-2]->data)==0){
						printf("j = %d, i=%d in scope-> %d , 2 vars with same name!\n",j,i,scope);
					 	return false;
					}
				}
			}
		}
	
	return true;
}
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

