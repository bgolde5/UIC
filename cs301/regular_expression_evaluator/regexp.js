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

var i;
var input;
var originalInput;
var pageFlag;

function nextchar() {
    return input[i];
}

function consume() {
    i++;
}

function match(c) {
    if (c === nextchar())
        consume();
    else
        throw 20;
}

// <kleene_op> -> '*' | E
function kleene_op(s) {
    if (nextchar() === '*')
        match('*');
    else
    ;
}

// <union_op> -> '|' | E
function union_op(s) {
    if (nextchar() === '|')
        match('|');
    else
    ;
}

// <id> -> 'a' | 'b' | 'c' | 'd'
function id(s) {
    if (nextchar() === 'a') {
        match('a');
    } else if (nextchar() === 'b') {
        match('b');
    } else if (nextchar() === 'c') {
        match('c');
    } else if (nextchar() === 'd') {
        match('d');
    } else {
        throw 20;
    }
}

// <terminal> -> '(' <expr> ')' | <id>
function terminal(s) {
    if (nextchar() === '(') {
        match('(');
        RE(s);
        match(')');
    } else if (nextchar() >= 'a' && nextchar() <= 'd') {
        id(s);
    } else {
        throw 20;
    }
}

// <kleen> -> <terminal>
function kleene(s) {
    terminal(s);
}

// <kleen_tail> -> <kleen_op><kleen_tail> | E
function kleene_tail(s) {
    if (nextchar() === '*') {
        kleene_op(s);
        kleene_tail(s);
    } else
    ;
}

// <concat> -> <kleene><kleene_tail>
function concat(s) {
    kleene(s);
    kleene_tail(s);
}

// <concat_tail> -> <concat><concat_tail> | E
function concat_tail(s) {
    if ((nextchar() >= 'a' && nextchar() <= 'd') || nextchar() === '(') {
        concat(s);
        concat_tail(s);
    } else
    ;
}

// <union> -> <concat><concat_tail>
function union_(s) {
    concat(s);
    concat_tail(s);
}

// <union_tail> -> <union_op><union><union_tail> | E
function union_tail(s) {
    if (nextchar() == '|') {
        union_op(s);
        union_(s);
        union_tail(s);
    } else
    ;
}

// <expr> -> <union><union_tail>
function RE(s) {
    union_(s);
    union_tail(s);
}

function main() {

    i = 0;
    originalInput = input;
    input = input + "$";

    try {
        RE(input); //call start symbol to derive input
        match('$'); //if we reach EOS, input is an RE!

        pageFlag = originalInput + " is valid!";
        
        document.getElementById("display").innerHTML = "<div class=\"col-lg-6\"><h4 class=\"alert alert-success\" role=\"alert\">"+pageFlag+"</h4></div>";
        
    } catch (err) {
        pageFlag = originalInput + " is not valid.";
        document.getElementById("display").innerHTML = "<div class=\"col-lg-6\"><h4 class=\"alert alert-danger\" role=\"alert\">"+pageFlag+"</h4></div>";
    }
    return 0;

}

document.getElementById("mybtn").addEventListener("click", readBox);

function readBox() {

    var nameElement = document.getElementById("regex");
    var theName = nameElement.value;
    input = theName;
    main();
}