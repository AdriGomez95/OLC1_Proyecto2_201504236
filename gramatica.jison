/************************************************  Aqui los imports ************************************************/
%(
    
%}

/************************************************ Aqui va el lenguaje lexico ************************************************/

%lex
%options case-insensitive
%%

/*
"*"                 %{ return 'tk_multiplicacion'; %}
"/"                 %{ return 'tk_division'; %}
"-"                 %{ return 'tk_resta'; %}
"+"                 %{ return 'tk_suma'; %}
*/

"public"            %{ return 'tk_public'; %}
"class"             %{ return 'tk_class'; %}
"interface"         %{ return 'tk_interface'; %}
"int"               %{ return 'tk_int'; %}
"double"            %{ return 'tk_double'; %}
"char"              %{ return 'tk_char'; %}
"string"            %{ return 'tk_string'; %}
"void"              %{ return 'tk_void'; %}

"{"                 %{ return 'tk_lla'; %}
"}"                 %{ return 'tk_llc'; %}
"("                 %{ return 'tk_pa'; %}
")"                 %{ return 'tk_pc'; %}
","                 %{ return 'tk_coma'; %}
";"                 %{ return 'tk_puntoComa'; %}

[0-9]+              %{ return 'tk_numero'; %}
[a-z]([a-z0-9_])*   %{ return 'tk_id'; %}

[ \t\r\n\f]         %{ /*Los ignoramos*/ %}
<<EOF>>             %{ return 'EOF'; %}
.                   %{ console.log("Error Lexico: "+yytext+", linea "+yylloc.first_line+", columna "+yylloc.first_column); %}



/lex


/************************************************ Aqui va el lenguaje sintactico ***********************************************/


%start INICIO
%%

INICIO: EXP EOF {};

EXP: tk_public A tk_id tk_lla tk_llc 
    |error tk_puntoComa EXP {console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};

A: tk_class 
    |tk_interface
    |error tk_puntoComa {console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};