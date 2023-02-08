## CSC 4351 Compiler Construction
## LSU Spring 2023
## Professor Baumgartner
## Kaylin Archuleta & Justin Nguyen

To run the program set up the environment as instructed by the HW directions

- export CS4351=/classes/cs4351/cs4351_bau/pub
- export PROG=chap2
- export TIGER=${CS4351}/tiger
- export CLASSPATH=.:..:${CS4351}/classes/${PROG}:${CS4351}/classes

run the command 'make clean' while in the prog1 directory
run the command java Parse.Main testcases/<desired test file>

output of merge.tig

![image](https://user-images.githubusercontent.com/76065821/217415440-34ff467b-fc03-448e-b832-eec85ae8ae63.png)

  
  
# Handling Strings 

Input from merge.tig: 

![image](https://user-images.githubusercontent.com/76065821/217417286-ab5fbcec-0c80-4e9e-8ca7-7f0bb47688e8.png)

Output: 

![image](https://user-images.githubusercontent.com/76065821/217417391-48ea460a-bea2-41e4-97da-fb0944f5b92b.png)

  Errors: String creates an error sometimes when using the newline character.

current progress

- only the tiger.lex file has been edited
- 4 states are used:
yyinitial, comment, string, and ignore
- 2 states are fully implemented: 
yyinitial - all token return statements & state switch statements & errors (with the assumption that the only yyiniital error handling message is needed is the . error) are implmented
comment - switch to yyinitial, nesting depth, and the EOF in comment state error is implemented

2 states are partially implemented:
string - switch to yyinitial, recognizing all escape characters, putting some escape characters into the stringbuffer & an error when EOF is reached in string state is implemented. proper line counting & getting the values of strings & control characters via stringbuffer is not.
ignore - switch to string, ignoring white spaces, line counting, and the EOF in ignore state is implemented. this state is not fully tested and (despite the code planning for that) a bug for line count is possible.
- macros are used for ints, ids, strings & the ignore state to increase readability

- token return statements are seperated into 10 categories:
whitespace, algebraic operations, boolean operators, parens & brackets & braces, keywords, int & id, comment state, string state, ignore state, illegal character error
- more broadly, the statements are organized into 4 parts:
yyinitial statements, comment statements, string statements, ignore statements

logic:
yyinitial statements are organized into categories for reader/coder convienence. this should not have any conflict with longest match or rule priority because all yyinitial tokens except id & int are unique and have only one interpretation. the id and int token return statements are put as the last statements to comply with rule priority. int is organized such that it will not recognize 00 as one int, so there will be no leading zeroes.

comment nesting depth is handled with a counter that counts every "/*". comment state is only left if the counter is at 0. otherwise, the characters, aside from newline, are ignored & an error will return if comment state is not left in the case that all "/*" are not matched with a "*/"

macros are used for the string escape characters for readability. the code is unoptimized & likely buggy as this was a 'last day' effort. control and ascii characters are converted to int and then cast as char to get the respective output

ignore only recognizes white space, /, and new line characters to account for escape character errors
