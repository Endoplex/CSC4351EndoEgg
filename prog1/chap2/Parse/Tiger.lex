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

%state COMMENT
%state STRING
%state IGNORE
num = [0-9]

%%

<YYINITIAL> " "	  {}
<YYINITIAL> \n	  {newline();}
<YYINITIAL> ","	  {return tok(sym.COMMA, null);}
<YYINITIAL> "int"   {return tok(sym.INT);}
<YYINITIAL> ">"   {return tok(sym.GT);}
<YYINITIAL> "/"   {return tok(sym.DIVIDE);}
<YYINITIAL> ":"   {return tok(sym.COLON);}
<YYINITIAL> "else" {return tok(sym.ELSE);}
<YYINITIAL> "|"   {return tok(sym.OR);}
<YYINITIAL> "nil"   {return tok(sym.NIL);}
<YYINITIAL> "do"   {return tok(sym.DO);}
<YYINITIAL> ">="  {return tok(sym.GE);}

<YYINITIAL> "<"   {return tok(sym.LT);}
<YYINITIAL> "of"  {return tok(sym.OF);}
<YYINITIAL> "-"   {return tok(sym.MINUS);}
<YYINITIAL> "array"  {return tok(sym.ARRAY);}
<YYINITIAL> "type"  {return tok(sym.TYPE);}
<YYINITIAL> "for"  {return tok(sym.FOR);}
<YYINITIAL> "to"  {return tok(sym.TO);}
<YYINITIAL> "*"   {return tok(sym.TIMES);}
<YYINITIAL> "<="  {return tok(sym.LE);}
<YYINITIAL> "in"   {return tok(sym.IN);}
<YYINITIAL> "end"   {return tok(sym.END);}
<YYINITIAL> ":="  {return tok(sym.ASSIGN);}

<YYINITIAL> "."   {return tok(sym.DOT);}
<YYINITIAL> "("   {return tok(sym.LPAREN);}
<YYINITIAL> ")"   {return tok(sym.RPAREN);}
<YYINITIAL> "if"   {return tok(sym.IF);}
<YYINITIAL> ";"   {return tok(sym.SEMICOLON);}
<YYINITIAL> "id"   {return tok(sym.ID); /**/}
<YYINITIAL> "while"   {return tok(sym.WHILE);}
<YYINITIAL> "["   {return tok(sym.LBRACK);}
<YYINITIAL> "]"   {return tok(sym.RBRACK);}
<YYINITIAL> "<>"   {return tok(sym.NEQ);}
<YYINITIAL> "var"   {return tok(sym.VAR);}
<YYINITIAL> "break"   {return tok(sym.BREAK);}
<YYINITIAL> "&"   {return tok(sym.AND);}
<YYINITIAL> "+"   {return tok(sym.PLUS);}
<YYINITIAL> "{"   {return tok(sym.LBRACE);}
<YYINITIAL> "}"   {return tok(sym.RBRACE);}
<YYINITIAL> "let"   {return tok(sym.LET);}
<YYINITIAL> "then"   {return tok(sym.THEN);}
<YYINITIAL> "="   {return tok(sym.EQ);}\

<YYINITIAL> {NUM} {return tok(yytext());}

/* COMMENTS

<YYINITIAL> {
  <COMMENT> {
    "/*"    { yybegin(COMMENT); nestDepth = 1; }
    *       { nestDepth++ }
    \n      { newline(); }
    .       {}
    "*/"    { nestDepth--; if(nestDepth == 0) {yybegin(YYINITIAL)} }
  }
}

/*
* WHITESPACE = [\r\n \t\b\012]+ 
*/
<YYINITIAL> {
  <STRING> {  
    \"    { yybegin(STRING); 
            StringBuffer string = new StringBuffer(); 
            return tok(sym.STRING, string.toString()); 
            linecount = 1;
          }

    {WHITESPACE}    { string.append(yytext()); linecount ++; }
    \t              { string.append('\t'); }
    \"              { string.append('\"'); }
    \\              { string.append('\\'); }  
    \\\             { string.append('\\\'); }
    \n              { string.append('\n'); }

    {CONTROL}       { return tok(sym.STRING, yytext());}
  }
  <IGNORE> {
    \n            {newline();}
    {WHITESPACE}  {}
    \\            {yybegin(YYINITIAL);}
  }
}
. { err("Illegal character: " + yytext()); }
