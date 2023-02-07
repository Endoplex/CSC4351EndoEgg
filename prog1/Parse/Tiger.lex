package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{

private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

private int nestDepth = 0;
private StringBuffer sb;
private java_cup.runtime.Symbol strtok;
private int linecount;


Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}     

%eof{
  {
    if(yy_lexical_state == COMMENT)
    err("Cannot end file in COMMENT state");
    else if((yy_lexical_state == STRING))
     err("Cannot end file in STRING state");
    else if((yy_lexical_state == IGNORE))
     err("Cannot end file in IGNORE state");
  }
%eof}


%state COMMENT, STRING, IGNORE

INTNUM = 0|[1-9][0-9]*
ID = [a-zA-Z][a-z0-9A-Z_]*

TEXT = [^\"|\\|^]+
CONTROL = "^"[@-_a-z]
ASCII = \\[0-2][0-9][0-9]

WHITESPACE = [\n\ \t\r\b\012]

%%

<YYINITIAL> " "	  {}
<YYINITIAL> \n	  {newline();}

<YYINITIAL> ","	  {return tok(sym.COMMA);}
<YYINITIAL> ";"   {return tok(sym.SEMICOLON);}
<YYINITIAL> ":"   {return tok(sym.COLON);}
<YYINITIAL> ":="  {return tok(sym.ASSIGN);}
<YYINITIAL> "."   {return tok(sym.DOT);}

<YYINITIAL> "-"   {return tok(sym.MINUS);}
<YYINITIAL> "+"   {return tok(sym.PLUS);}
<YYINITIAL> "/"   {return tok(sym.DIVIDE);}
<YYINITIAL> "*"   {return tok(sym.TIMES);}

<YYINITIAL> "&"   {return tok(sym.AND);}
<YYINITIAL> "|"   {return tok(sym.OR);}
<YYINITIAL> ">"   {return tok(sym.GT);}
<YYINITIAL> ">="  {return tok(sym.GE);}
<YYINITIAL> "<"   {return tok(sym.LT);}
<YYINITIAL> "<="  {return tok(sym.LE);}
<YYINITIAL> "="   {return tok(sym.EQ);}
<YYINITIAL> "<>"   {return tok(sym.NEQ);}

<YYINITIAL> "("   {return tok(sym.LPAREN);}
<YYINITIAL> ")"   {return tok(sym.LPAREN);}
<YYINITIAL> "["   {return tok(sym.LBRACK);}
<YYINITIAL> "]"   {return tok(sym.RBRACK);}
<YYINITIAL> "{"   {return tok(sym.LBRACE);}
<YYINITIAL> "}"   {return tok(sym.RBRACE);}

<YYINITIAL> "array"  {return tok(sym.ARRAY);}
<YYINITIAL> "break"   {return tok(sym.BREAK);}
<YYINITIAL> "do"   {return tok(sym.DO);}
<YYINITIAL> "end"   {return tok(sym.END);}
<YYINITIAL> "else" {return tok(sym.ELSE);}
<YYINITIAL> "for"  {return tok(sym.FOR);}
<YYINITIAL> "if"   {return tok(sym.IF);}
<YYINITIAL> "in"   {return tok(sym.IN);}
<YYINITIAL> "let"   {return tok(sym.LET);}
<YYINITIAL> "nil"   {return tok(sym.NIL);}
<YYINITIAL> "of"  {return tok(sym.OF);}
<YYINITIAL> "to"  {return tok(sym.TO);}
<YYINITIAL> "then"   {return tok(sym.THEN);}
<YYINITIAL> "typedef"  {return tok(sym.TYPE);}
<YYINITIAL> "var"   {return tok(sym.VAR);}
<YYINITIAL> "while"   {return tok(sym.WHILE);}

<YYINITIAL> {INTNUM}   {return tok(sym.INT, new Integer(yytext()));}
<YYINITIAL> {ID}   {return tok(sym.ID, yytext());}


<YYINITIAL> {
  "/*" {yybegin(COMMENT); nestDepth = 1;}
  <COMMENT> { 
    "/*" {nestDepth++;}
    \n	  {newline(); }
    . {}
    "*/" {  nestDepth--; 
            if(nestDepth == 0) { yybegin(YYINITIAL); }
            else if(nestDepth < 0) { err("Illegal closing comment"); }
          }
  }
}

<YYINITIAL> { 
  \" {yybegin(STRING); sb = new StringBuffer();}
  <STRING> { 
    \\" {sb.append(yytext()); System.out.print("\\")}
    \\n {sb.append(yytext()); System.out.print("\\n")}
    \\t {sb.append(yytext()); System.out.print("\\t") }
    \\\\ {sb.append(yytext().charAt(1)); System.out.print("\\\\")}
    {CONTROL} {return tok(sym.STRING, yytext());}
    {ASCII} {System.out.print("debug"); int c = new Integer(yytext().substring(1)); sb.append((char) c); }
    \" {System.out.print(sb.toString()); yybegin(YYINITIAL); }
    {TEXT} {return tok(sym.STRING, yytext());}
    \\ {WHITESPACE} { yybegin(IGNORE);} 
    <IGNORE> {
      \n {newline();}
      {WHITESPACE} {}
      \\ {yybegin(STRING);}
    }
  }
}


. { err("Illegal character: " + yytext()); }
