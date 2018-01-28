//CS 411 Project1
//Lexical Analyzer

import java.util.ArrayList;

%%

%public
%class LexicalAnalyzer
%intwrap
%unicode
%line
%column
%eofclose

%{

  public enum tokens {
    t_boolean, t_break, t_class, t_double,
    t_else, t_extends, t_for, t_if,
    t_implements, t_int, t_interface, t_newarray,
    t_println, t_readln, t_return, t_string,
    t_void, t_while, t_plus, t_minus,
    t_multiplication, t_division, t_mod, t_less,
    t_lessequal, t_greater, t_greaterequal, t_equal,
    t_notequal, t_and, t_or, t_not,
    t_assignop, t_semicolon, t_comma, t_period,
    t_leftparen, t_rightparen, t_leftbracket, t_rightbracket,
    t_leftbrace, t_rightbrace, t_intconstant, t_doubleconstant,
    t_stringconstant, t_booleanconstant, t_id
  }

  public class symbol_table {
    public int [] control = new int[52];
    public ArrayList<Integer> next = new ArrayList<Integer>();
    public ArrayList<Character> symbol = new ArrayList<Character>();
    
    public symbol_table() {
        for (int i = 0; i < this.control.length; ++i) {
            this.control[i] = -1; 
        }
    }
  }

  public symbol_table s = new symbol_table();

  public int alphaIndex(char c) {
    int v = c;
    if (v >= 97) {
        return v - 97 + 26;
    }
    return v - 65; 
  }

  public void trie(String str) {
    int value = alphaIndex(str.charAt(0));
    int ptr = s.control[value];

    if (ptr == -1) {
        s.control[value] = s.symbol.size();
        for (int i = 1; i < str.length(); ++i) {
            s.symbol.add(str.charAt(i));
        }
        s.symbol.add('@'); 
    }
    else {        
        int i = 1;
        boolean exit = false;

        if(str.length() == 1) {
            return;
        }

        while(!exit) {
            if (s.symbol.get(ptr) == str.charAt(i)) {
                if(str.length() -1 <= i) {
                    exit = true;
                    break; 
                }
                i++; 
                ptr++;
            }
            else if((s.next.size() > ptr) && (s.next.get(ptr) != -1)) {
                ptr = s.next.get(ptr);
            }
            else {

                while(s.next.size() <= ptr) {
                    s.next.add(-1);
                }

                s.next.set(ptr,s.symbol.size()); 

                while(i < str.length()) {
                    s.symbol.add(str.charAt(i++));
                }
                s.symbol.add('@');

                exit = true;
                break;
            }
        }

    }

  }

    public void printControl(int head, int tail) {
        System.out.printf("%-10s", "switch:");
        int v = 0;
        for (; head < tail; ++head) {
            v = s.control[head];
            if (v == -1) {
                System.out.print("$   ");
            }
            else {
                System.out.printf("%-3d ", v);
            }
        }
        System.out.println("\n");
    }

    public void printSymbol(int head, int tail) {
        System.out.printf("%-10s", "symbol:");
        for(int i = head; i < tail; ++i) {
            System.out.printf("%c   ", s.symbol.get(i));
        }
        System.out.println();
    }

    public void printNext(int head, int tail) {
        System.out.printf("%-10s", "next:");
        int v = 0;
        for (int i = head; i < tail; ++i) {
            v = s.next.get(i);
            if (v == -1) {
                System.out.print("$   ");
            }
            else {
                System.out.printf("%-3d ", v);
            }
        }
        System.out.println("\n");       

    }

    private void equalizeNext() {
        if (s.symbol.size() > s.next.size()) {
            while (s.next.size() != s.symbol.size()) {
                s.next.add(-1);
            }
        }
    }

    public void printTable() {
        String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        System.out.printf("%-10s","");
        int head = 0;
        int i = 0;
        for (; i < 52; ++i) {
            if ((i+1)%20 == 0) {
                System.out.println();
                printControl(head,i);
                System.out.printf("%-10s","");
                head = i;
            }
            System.out.printf("%c   ", alpha.charAt(i));
        }
        System.out.println();
        printControl(head,i);

        equalizeNext();

        i = 0;
        head  = 0;
        System.out.printf("%-10s",""); 
        for (; i < s.symbol.size(); ++i) {
            if ((i+1)%20 == 0) {
                System.out.println();
                printSymbol(head,i);
                printNext(head,i);
                System.out.printf("%-10s","");
                head = i;
            }
            System.out.printf("%-3d ", i);
        }
        System.out.println();
        printSymbol(head,i);
        printNext(head,i);
    }

%}

letter = [a-zA-Z]
digit = [0-9]
hex = (0x|0X)[a-fA-F0-9]+
integer = ({digit}+|{hex})
exponent = ((E|e)("+"|"-")?({digit})+)
double = (({digit}+"."{digit}*{exponent}?)|({digit}+{exponent}))
identifier = {letter}({letter}|{digit}|"_")*
string = \"([^\"\n])*\"
newline = \n
whitespace = [ \t]+
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}
Comment = ({TraditionalComment}|{EndOfLineComment})

%%


{Comment} { }

{string} {System.out.print("stringconstant "); return tokens.t_stringconstant.ordinal();}

/*Keywords*/

boolean {System.out.printf("%s ",yytext()); return tokens.t_boolean.ordinal();}
break {System.out.printf("%s ",yytext()); return tokens.t_break.ordinal();}
class {System.out.printf("%s ",yytext()); return tokens.t_class.ordinal();}
double {System.out.printf("%s ",yytext()); return tokens.t_double.ordinal();}
else {System.out.printf("%s ",yytext()); return tokens.t_else.ordinal();}
extends {System.out.printf("%s ",yytext()); return tokens.t_extends.ordinal();}
for {System.out.printf("%s ",yytext()); return tokens.t_for.ordinal();}
if {System.out.printf("%s ",yytext()); return tokens.t_if.ordinal();}
implements {System.out.printf("%s ",yytext()); return tokens.t_implements.ordinal();}
int {System.out.printf("%s ",yytext()); return tokens.t_int.ordinal();}
interface {System.out.printf("%s ",yytext()); return tokens.t_interface.ordinal();}
newarray {System.out.printf("%s ",yytext()); return tokens.t_newarray.ordinal();}
println {System.out.printf("%s ",yytext()); return tokens.t_println.ordinal();}
readln {System.out.printf("%s ",yytext()); return tokens.t_readln.ordinal();}
return {System.out.printf("%s ",yytext()); return tokens.t_return.ordinal();}
string {System.out.printf("%s ",yytext()); return tokens.t_string.ordinal();}
void {System.out.printf("%s ",yytext()); return tokens.t_void.ordinal();}
while {System.out.printf("%s ",yytext()); return tokens.t_while.ordinal();}

true|false {System.out.print("booleanconstant "); return tokens.t_booleanconstant.ordinal();}

{identifier} {System.out.print("id "); trie(yytext()); return tokens.t_id.ordinal();}
{whitespace} { }
{newline} {System.out.print("\n");} /*preserve line breaks*/
{integer} {System.out.print("intconstant "); return tokens.t_intconstant.ordinal();}
{double} {System.out.print("doubleconstant "); return tokens.t_doubleconstant.ordinal();}


/*Operators and Punctuation*/

"+" {System.out.print("plus "); return tokens.t_plus.ordinal();}
"-" {System.out.print("minus "); return tokens.t_minus.ordinal();}
"*" {System.out.print("multiplication "); return tokens.t_multiplication.ordinal();}
"/" {System.out.print("division "); return tokens.t_division.ordinal();}
"%" {System.out.print("mod "); return tokens.t_mod.ordinal();}
"<" {System.out.print("less "); return tokens.t_less.ordinal();}
"<=" {System.out.print("lessequal "); return tokens.t_lessequal.ordinal();}
">" {System.out.print("greater "); return tokens.t_greater.ordinal();}
">=" {System.out.print("greaterequal "); return tokens.t_greaterequal.ordinal();}
"==" {System.out.print("equal "); return tokens.t_equal.ordinal();}
"!=" {System.out.print("notequal "); return tokens.t_notequal.ordinal();}
"&&" {System.out.print("and"); return tokens.t_and.ordinal();}
"||" {System.out.print("or"); return tokens.t_or.ordinal();}
"!" {System.out.print("not"); return tokens.t_not.ordinal();}
"=" {System.out.print("assignop "); return tokens.t_assignop.ordinal();}
";" {System.out.print("semicolon "); return tokens.t_semicolon.ordinal();}
"," {System.out.print("comma "); return tokens.t_comma.ordinal();}
"." {System.out.print("period "); return tokens.t_period.ordinal();}
"(" {System.out.print("leftparen "); return tokens.t_leftparen.ordinal();}
")" {System.out.print("rightparen "); return tokens.t_rightparen.ordinal();}
"[" {System.out.print("rightbracket "); return tokens.t_rightbracket.ordinal();}
"]" {System.out.print("leftbracket "); return tokens.t_leftbracket.ordinal();}
"{" {System.out.print("leftbrace "); return tokens.t_leftbrace.ordinal();}
"}" {System.out.print("rightbrace "); return tokens.t_rightbrace.ordinal();}

. { /* ignore illegal chars */ }