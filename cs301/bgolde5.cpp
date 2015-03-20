/*
 * =====================================================================================
 *
 *    Description: Regular expression parser
 *           Name: Bradley Golden 
 *   Organization: University of Illinois at Chicago
 *          Class: CS301, Spring 2015: HW10
 *
 * =====================================================================================
 */

/*
 *      W/O LEFT RECURSION
 * <expr> -> <expr>
 *         | <union>
 * <union> -> <union> '|' <concat>
 *         | <concat>
 * <concat> -> <concat><kleene>
 *         | <kleene>
 * <kleene> -> <kleen>'*'
 *         | <terminal>
 * <terminal> -> <id>
 *         | '('<expr>')'
 * <id> -> 'a' | 'b' | 'c' | 'd'
 *
*/

/* 
 *      W/ LEFT RECURSION
 * <expr> -> <union><union_tail>
 * <union_tail> -> <union_op><union><union_tail>
 *              | E
 * <union> -> <concat><concat_tail>
 * <concat_tail> -> <concat><concat_tail>
 *              | E
 * <concat> -> <kleene><kleene_tail>
 * <kleen_tail> -> <kleen_op><kleen_tail>
 *              | E
 * <kleen> -> <terminal>
 * <terminal> -> '(' <expr> ')'
 *              | <id>
 * <id> -> 'a' | 'b' | 'c' | 'd'
 * <union_op> -> '|' 
 *              | E
 * <kleen_op> -> '*' 
 *              | E
 * 
 */

#include <iostream>
#include <string>

using namespace std;

int i;
string input;

int nextchar(){
  return input[i];
}

void consume(){
  i++;
}

void match(int c){
  if(c == nextchar())
    consume();
  else
    throw 20;
}

void RE(string s);

// <kleene_op> -> '*' | E
void kleene_op(string s){
  if(nextchar() == '*')
   match('*'); 
  else
    ;
}

// <union_op> -> '|' | E
void union_op(string s){
  if(nextchar() == '|')
   match('|'); 
  else
    ;
}

// <id> -> 'a' | 'b' | 'c' | 'd'
void id(string s){
  if(nextchar() == 'a')
  { match('a'); }
  else if(nextchar() == 'b')
  { match('b'); }
  else if(nextchar() == 'c')
  { match('c'); }
  else if(nextchar() == 'd')
  { match('d'); } 
  else
  { throw 20; }
}

// <terminal> -> '(' <expr> ')' | <id>
void terminal(string s){
  if(nextchar() == '(')
  { match('('); RE(s); match(')'); }
  else if(nextchar() >= 'a' && nextchar() <= 'd')
    id(s);
  else
  { throw 20; }
}

// <kleen> -> <terminal>
void kleene(string s){
  terminal(s);
}

// <kleen_tail> -> <kleen_op><kleen_tail> | E
void kleene_tail(string s){
  if(nextchar() == '*')
  { kleene_op(s); kleene_tail(s);} 
  else
    ;
}

// <concat> -> <kleene><kleene_tail>
void concat(string s){
  kleene(s); kleene_tail(s); 
}

// <concat_tail> -> <concat><concat_tail> | E
void concat_tail(string s){
  if((nextchar() >= 'a' && nextchar() <= 'd') 
      || nextchar() == '('){
    concat(s); concat_tail(s);  
  }
  else
    ;
}

// <union> -> <concat><concat_tail>
void union_(string s){
  concat(s); concat_tail(s);
}

// <union_tail> -> <union_op><union><union_tail> | E
void union_tail(string s){
  if(nextchar() == '|'){
    union_op(s); union_(s); union_tail(s);
  }
  else
    ;
}

// <expr> -> <union><union_tail>
void RE(string s){
  union_(s); union_tail(s);
}

int main(){

  cout << "** please enter a regular expression: ";
  getline(cin, input);

  input = input + "$"; //add EOS marker to end;
  i = 0;

  try{
    RE(input); //call start symbol to derive input
    match('$'); //if we reach EOS, input is an RE!

    cout << endl;
    cout << "**Yes, input is a valid RE!" << endl;
    cout << endl;
  }
  catch(...){
    cout << endl;
    cout << "Sorry, input is not a valid RE..." << endl;
    cout << endl;
  }
  return 0;

}
