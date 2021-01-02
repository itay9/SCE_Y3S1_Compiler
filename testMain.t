/% comment long
comment %/
func foo/%1%/ (a,b,c: int; c1:char) return bool
{
var res:bool;
{
var x:char;
var k:int;
b='&';
/% a=x; %/
/% b=8; %/
a=(y*7)/a-y;
/% a=(y*7)/b-y; %/
/% a=(y*7)/a-c; %/
res=(b==c) && (y>a);
/% res=(b==c) && (y+a); %/
/% 3+6=9; %/
/%%x=6;%/ 
}
return res;
}
proc Main()
{
var a:int;
if (a){
a=foo2();
}
}
