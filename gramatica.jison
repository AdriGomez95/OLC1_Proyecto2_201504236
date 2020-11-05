/************************************************  Aqui los imports ************************************************/
%{
    let tokenArray = new Array();
    module.exports.tokenArray = tokenArray;
    const Nodo = require('./arbolNodo');
    
    let panic = false
    let count = 1
    let errors = new Array();
    module.exports.errors = errors;
%}

/************************************************ Aqui va el lenguaje lexico ************************************************/

%lex
%options case-insensitive
%%

//ESPACIOS, ENTER Y RETORNOS
[ \t\r\n\f]          /*skip*/

//CADENA EN COMILLAS DOBLES
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]         %{yytext =yytext.substr(1,yyleng-2);  return 'tk_cadena'; %}



//COMENTARIO MULTILINEA
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             /* skip multiline */      //%{yytext.substr(1,yyleng-2);  return 'tk_comentario_multilinea'; %}

//COMENTARIO UNILINEA
"//".*						                    /* skip uniline */


//PALABRAS RESERVADAS
"public"            %{ return 'tk_public'; %}
"class"             %{ return 'tk_class'; %}
"interface"         %{ return 'tk_interface'; %}
"int"               %{ return 'tk_int'; %}
"double"            %{ return 'tk_double'; %}
"char"              %{ return 'tk_char'; %}
"string"            %{ return 'tk_string'; %}
"void"              %{ return 'tk_void'; %}
"static"            %{ return 'tk_static'; %}
"main"              %{ return 'tk_main'; %}
"args"              %{ return 'tk_args'; %}
"for"               %{ return 'tk_for'; %}
"while"             %{ return 'tk_while'; %}
"do"                %{ return 'tk_do'; %}
"if"                %{ return 'tk_if'; %}
"else"              %{ return 'tk_else'; %}
"boolean"           %{ return 'tk_boolean'; %}
"break"             %{ return 'tk_break'; %}
"continue"          %{ return 'tk_continue'; %}
"return"            %{ return 'tk_return'; %}
"true"              %{ return 'tk_true'; %}
"false"             %{ return 'tk_false'; %}
"system"            %{ return 'tk_system'; %}
"."                 return '.';
"out"               %{ return 'tk_out'; %}
"print"             %{ return 'tk_print'; %}
"println"           %{ return 'tk_println'; %}

//SIMBOLOS
"{"                 %{ return 'tk_lla'; %}
"}"                 %{ return 'tk_llc'; %}
"("                 %{ return 'tk_pa'; %}
")"                 %{ return 'tk_pc'; %}
"["                 %{ return 'tk_ca'; %}
"]"                 %{ return 'tk_cc'; %}
","                 %{ return 'tk_coma'; %}
";"                 %{ return 'tk_puntoComa'; %}
"&&"                return '&&'
"||"                return '||'
"^"                 return '^'
"<="                return '<='
">="                return '>='
"<"                 return '<'
">"                 return '>'
"=="                return '=='
"="                 return '='
"!="                return '!='
"!"                 return '!'
"++"                return '++'
"+"                 return '+'
"--"                return '--'
"-"                 return '-'
"*"                 return '*'
"/"                 return '/'

//NUMERO Y ID
[0-9]+("."[0-9]+)*  %{ return 'tk_numero'; %}
[a-z]([a-z0-9_])*   %{ return 'tk_id'; %}

<<EOF>>             %{ return 'EOF'; %}
//.                   %{ console.log("Error Lexico: "+yytext+"  - linea: "+yylloc.first_line+" - columna: "+yylloc.first_column); %}
.  { 
	let row = yylloc.first_line;
	let column = yylloc.first_column + 1;
	let newError = count.toString() + "." +
                " Error léxico: "+ yytext + 
                " - linea: " + row +
                " - columna: " + column +
                ". No pertenece al lenguaje"
                "\n";
	count+=1;
	errors.push(newError);
	console.log('Error lexico: \'' + yytext + '\'. En fila: ' + row + ', columna: ' + column + '.');
	}

/lex


/************************************************ Aqui va el lenguaje sintactico ***********************************************/
%left  '||'
%left  '&&'
%left  '==' '!='
%left  '>=' '<=' '<' '>'
%left  '+' '-'
%left  '*' '/'
%left  '^'
%left  '++' '--'
%left  '!'

%start INICIO
%%

INICIO: CLASS EOF       { $$ = new Nodo("RAIZ",""); 
                            $$.addHijo($1);
                            return $$;
                        };


CLASS: CLASS DEF    { $$ = new Nodo("CLASE","");
                        $$.addHijo($1);
                        $$.addHijo($2);
                    }
    |DEF            { $$ = new Nodo("CLASE","");
                        $$.addHijo($1);
                    }        
    |CLASS ERROR tk_puntoComa  //{console.log("Error sintactico - linea: "+(yylineno - 1)+" - columna: "+this._$.first_column+" - Se esperaba una clase");}
    |ERROR tk_puntoComa;//  {console.log("Error sintactico - linea: "+(yylineno - 1)+" - columna: "+this._$.first_column+" - Se esperaba una clase");};


DEF: tk_public A tk_id tk_lla METHODS tk_llc                { $$ = new Nodo($1,"public");
                                                                $$.addHijo($2);
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"{"));
                                                                $$.addHijo($5);
                                                                $$.addHijo(new Nodo($6,"}"));
                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");  
                                                                tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                            }
    |tk_public A tk_id tk_lla tk_llc                        { $$ = new Nodo($1,"public");
                                                                $$.addHijo($2);
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"{"));
                                                                $$.addHijo(new Nodo($5,"}"));
                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                            };


A: tk_class         { $$ = new Nodo($1,"class"); tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_interface   { $$ = new Nodo($1,"interface"); tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");}
    |ERROR tk_puntoComa;
    /*
    |error tk_puntoComa {$$ = new Nodo("error","error");};
                            //console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};
    */

METHODS: METHODS DEFMET     { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                                $$.addHijo($2); 
                            }
    |DEFMET                 { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                            } 
    |METHODS VARIABLES1 tk_puntoComa        { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                                $$.addHijo($2); 
                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo");
                                            }
    |VARIABLES1  tk_puntoComa              { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo");
                                            } 
    |METHODS BOOLEAN        { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                                $$.addHijo($2);
                            }
    |BOOLEAN                { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                            }
    |METHODS PRINTSENTENCE      { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                            }
    |PRINTSENTENCE              { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                            }            
    |METHODS ERROR tk_puntoComa  //{console.log("Error sintactico - linea: "+(yylineno - 1)+" - columna: "+this._$.first_column+" - Se esperaba un metodo o variable");}          
    |ERROR tk_puntoComa;// {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba un metodo o variable");};


VARIABLES1: VARIABLES1 tk_coma tk_id      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,","));
                                            $$.addHijo(new Nodo($3,"id"));
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                        }  
    |tk_string tk_id '=' tk_cadena      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: string"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: cadena"); 
                                        } 
    |tk_char tk_id '=' tk_cadena        { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: char"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: cadena"); 
                                        }
    |tk_int tk_id '=' tk_numero         { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: int"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: numero"); 
                                        }
    |tk_double tk_id '=' tk_numero      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: double"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: numero"); 
                                        }
    |tk_int tk_id '=' tk_id             { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: int"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: id"); 
                                        }
    |tk_double tk_id '=' tk_id          { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: double"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: id"); 
                                        }
    |tk_string tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"string"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: string"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_char tk_id          { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"char"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: char"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_int tk_id           { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"int"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: int"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_double tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"double"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: double"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_id '=' tk_numero            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"numero"));
                                        tokenArray.push("Token: " +$1+ " - Tipo: id"); 
                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                        tokenArray.push("Token: " +$3+ " - Tipo: numero"); 
                                    }
    |tk_id '=' tk_cadena            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"cadena"));
                                        tokenArray.push("Token: " +$1+ " - Tipo: id"); 
                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                        tokenArray.push("Token: " +$3+ " - Tipo: cadena"); 
                                    };


DEFMET: tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_lla SENTENCES tk_llc     { $$ = new Nodo("public","1");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                    $$.addHijo(new Nodo($7,"{"));
                                                                                    $$.addHijo($8);
                                                                                    $$.addHijo(new Nodo($9,"}"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$9+ " - Tipo: simbolo"); 
                                                                                }     
    |tk_public TYPE tk_id tk_pa  tk_pc tk_lla SENTENCES tk_llc                   { $$ = new Nodo("public","2");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($6,"{"));
                                                                                    $$.addHijo($7);
                                                                                    $$.addHijo(new Nodo($8,"}"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                } 
    |tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_lla  tk_llc                 { $$ = new Nodo("public","3");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                }       
    |tk_public TYPE tk_id tk_pa tk_pc tk_lla tk_llc                             { $$ = new Nodo("public","4");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                }          
    |tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_puntoComa                   { $$ = new Nodo("public","5");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                    $$.addHijo(new Nodo($7,";"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                }    
    |tk_public TYPE tk_id tk_pa tk_pc tk_puntoComa                              { $$ = new Nodo("public","6");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($6,";"));
                                                                                    tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                    tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                    tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                }
    |tk_public tk_static tk_void tk_main tk_pa tk_string tk_ca tk_cc tk_args tk_pc tk_lla SENTENCES tk_llc   { $$ = new Nodo("public","7");
                                                                                                                $$.addHijo(new Nodo($4,"main"));
                                                                                                                $$.addHijo(new Nodo($11,"{"));
                                                                                                                $$.addHijo($12);
                                                                                                                $$.addHijo(new Nodo($13,"}"));
                                                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$2+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$3+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$4+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$6+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$9+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$10+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$11+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$13+ " - Tipo: simbolo"); 
                                                                                                            }
    |tk_public tk_static tk_void tk_main tk_pa tk_string tk_ca tk_cc tk_args tk_pc tk_lla  tk_llc   { $$ = new Nodo("public","8");
                                                                                                                $$.addHijo(new Nodo($4,"main"));
                                                                                                                $$.addHijo(new Nodo($11,"{"));
                                                                                                                $$.addHijo(new Nodo($12,"}"));
                                                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$2+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$3+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$4+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$6+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$9+ " - Tipo: palabra reservada"); 
                                                                                                                tokenArray.push("Token: " +$10+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$11+ " - Tipo: simbolo"); 
                                                                                                                tokenArray.push("Token: " +$12+ " - Tipo: simbolo"); 
                                                                                                            };


TYPE: tk_int        { $$ = new Nodo($1,"int");      tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_double      { $$ = new Nodo($1,"double");   tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_char        { $$ = new Nodo($1,"char");     tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_string      { $$ = new Nodo($1,"string");   tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_void        { $$ = new Nodo($1,"void");     tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_static      { $$ = new Nodo($1,"static");   tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |tk_boolean     { $$ = new Nodo($1,"boolean");  tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); }
    |ERROR tk_puntoComa;// {console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};


PARAMETERS: PARAMETERS DEFPA    { $$ = new Nodo("PARAMET","");
                                    $$.addHijo($1);
                                    $$.addHijo($2);
                                }
    |DEFPA                      { $$ = new Nodo("PARAMET","");
                                    $$.addHijo($1);
                                }
    |ERROR tk_puntoComa;//  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba un parametro");};
    

DEFPA: tk_int tk_id         { $$ = new Nodo($1,"int"); 
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_double tk_id        { $$ = new Nodo($1,"double"); 
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_char tk_id          { $$ = new Nodo($1,"char"); 
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_string tk_id        { $$ = new Nodo($1,"string"); 
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_boolean tk_id       { $$ = new Nodo($1,"boolean"); 
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                            }
    |tk_coma                { $$ = new Nodo($1,","); 
                                tokenArray.push("Token: " +$1+ " - Tipo: simbolo"); 
                            };









//INICIA LA SUPER PRODUCCION
SENTENCES: SENTENCES DEFSENT tk_lla tk_llc  { $$ = new Nodo("SENTENCIAS","1");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                                $$.addHijo(new Nodo($3,"{"));
                                                $$.addHijo(new Nodo($4,"}"));
                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                            }
    |DEFSENT tk_lla tk_llc                  { $$ = new Nodo("SENTENCIAS","2");
                                                $$.addHijo($1);
                                                $$.addHijo(new Nodo($2,"{"));
                                                $$.addHijo(new Nodo($3,"}"));
                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            }
    |SENTENCES DEFSENT tk_lla SENTENCES tk_llc  { $$ = new Nodo("SENTENCIAS","3");
                                                    $$.addHijo($1);
                                                    $$.addHijo($2);
                                                    $$.addHijo(new Nodo($3,"{"));
                                                    $$.addHijo($4);
                                                    $$.addHijo(new Nodo($5,"}"));
                                                    tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                    tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                }
    |DEFSENT tk_lla SENTENCES tk_llc            { $$ = new Nodo("SENTENCIAS","4");
                                                    $$.addHijo($1);
                                                    $$.addHijo(new Nodo($2,"{"));
                                                    $$.addHijo($3);
                                                    $$.addHijo(new Nodo($4,"}"));
                                                    tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                    tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                }            
    //AQUI INICIA EL DO WHILE
    |SENTENCES tk_do tk_lla SENTENCES tk_llc tk_while tk_pa EXPRE tk_pc tk_puntoComa  { $$ = new Nodo("SENTENCIAS","5");
                                                                                        $$.addHijo(new Nodo($1,"doWhile"));
                                                                                        $$.addHijo($2);
                                                                                        $$.addHijo(new Nodo($3,"{"));
                                                                                        $$.addHijo($4);
                                                                                        $$.addHijo(new Nodo($5,"}"));
                                                                                        $$.addHijo(new Nodo($7,"("));
                                                                                        $$.addHijo($8);
                                                                                        $$.addHijo(new Nodo($9,")"));
                                                                                        tokenArray.push("Token: " +$2+ " - Tipo: palabra reservada"); 
                                                                                        tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$6+ " - Tipo: palabra reservada"); 
                                                                                        tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$9+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$10+ " - Tipo: simbolo"); 
                                                                                    }
    |tk_do tk_lla SENTENCES tk_llc  tk_while tk_pa EXPRE tk_pc tk_puntoComa           { $$ = new Nodo("SENTENCIAS","6");
                                                                                        $$.addHijo(new Nodo($1,"doWhile"));
                                                                                        $$.addHijo(new Nodo($2,"{"));
                                                                                        $$.addHijo($3);
                                                                                        $$.addHijo(new Nodo($4,"}"));
                                                                                        $$.addHijo(new Nodo($6,"("));
                                                                                        $$.addHijo($7);
                                                                                        $$.addHijo(new Nodo($8,")"));
                                                                                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$5+ " - Tipo: palabra reservada"); 
                                                                                        tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                        tokenArray.push("Token: " +$9+ " - Tipo: simbolo"); 
                                                                                    }
    |SENTENCES tk_do tk_lla  tk_llc tk_while tk_pa EXPRE tk_pc tk_puntoComa   { $$ = new Nodo("SENTENCIAS","7");
                                                                                $$.addHijo(new Nodo($1,"doWhile"));
                                                                                $$.addHijo($2);
                                                                                $$.addHijo(new Nodo($3,"{"));
                                                                                $$.addHijo(new Nodo($4,"}"));
                                                                                $$.addHijo(new Nodo($6,"("));
                                                                                $$.addHijo($7);
                                                                                $$.addHijo(new Nodo($8,")"));
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$5+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$9+ " - Tipo: simbolo"); 
                                                                            }
    |tk_do tk_lla  tk_llc  tk_while tk_pa EXPRE tk_pc tk_puntoComa            { $$ = new Nodo("SENTENCIAS","8");
                                                                                $$.addHijo(new Nodo($1,"doWhile"));
                                                                                $$.addHijo(new Nodo($2,"{"));
                                                                                $$.addHijo(new Nodo($3,"}"));
                                                                                $$.addHijo(new Nodo($5,"("));
                                                                                $$.addHijo($6);
                                                                                $$.addHijo(new Nodo($7,")"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$4+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$7+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$8+ " - Tipo: simbolo");
                                                                            }
    //AQUI FINALIZA EL DO WHILE
    //AQUI INICIAN LOS RETURNS, PRINT Y EL RESTO
    |SENTENCES VARIABLES tk_puntoComa   { $$ = new Nodo("SENTENCIAS","9");
                                            $$.addHijo($1);
                                            $$.addHijo($2);
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                        }  
    |VARIABLES tk_puntoComa             { $$ = new Nodo("SENTENCIAS","10");
                                            $$.addHijo($1);
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                        }
    |SENTENCES RETURNS tk_puntoComa     { $$ = new Nodo("SENTENCIAS","11");
                                            $$.addHijo($1);
                                            $$.addHijo($2);
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                        }
    |RETURNS tk_puntoComa               { $$ = new Nodo("SENTENCIAS","12");
                                            $$.addHijo($1);
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                        }
    |SENTENCES BOOLEAN      { $$ = new Nodo("SENTENCIAS","13");
                                $$.addHijo($1);
                                $$.addHijo($2);
                            }
    |BOOLEAN                { $$ = new Nodo("SENTENCIAS","14");
                                $$.addHijo($1);
                            }
    |SENTENCES PRINTSENTENCE    { $$ = new Nodo("SENTENCIAS","15");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                            }
    |PRINTSENTENCE              { $$ = new Nodo("SENTENCIAS","16");
                                                $$.addHijo($1);
                                            }   
    |SENTENCES EXPRE  tk_puntoComa  { $$ = new Nodo("SENTENCIAS","17");
                                        $$.addHijo($1);
                                        $$.addHijo($2);
                                        tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                    }
    |EXPRE  tk_puntoComa            { $$ = new Nodo("SENTENCIAS","18");
                                        $$.addHijo($1);
                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                    }       
    |SENTENCES ERROR tk_puntoComa  {console.log("Error sintactico - linea: "+(yylineno - 1)+" - columna: "+this._$.first_column+" - Se esperaba una sentencia");}          
    |ERROR tk_puntoComa;// {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una sentencia");};









DEFSENT: tk_for tk_pa CONDITION tk_puntoComa EXPRE tk_puntoComa DEC tk_pc   { $$ = new Nodo("for","1");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,";"));
                                                                                $$.addHijo($5);
                                                                                $$.addHijo(new Nodo($6,";"));
                                                                                $$.addHijo($7);
                                                                                $$.addHijo(new Nodo($8,")"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$6+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$8+ " - Tipo: simbolo"); 
                                                                                
                                                                            }
    |tk_while tk_pa EXPRE tk_pc                                             { $$ = new Nodo("while","2");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,")"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo");
                                                                            }
    |tk_if tk_pa EXPRE tk_pc                                                { $$ = new Nodo("if","3");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,")"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                                tokenArray.push("Token: " +$4+ " - Tipo: simbolo");
                                                                            }
    |tk_else tk_if tk_pa EXPRE tk_pc                                        { $$ = new Nodo("elif","4");
                                                                                $$.addHijo(new Nodo($3,"("));
                                                                                $$.addHijo($4);
                                                                                $$.addHijo(new Nodo($5,")"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$2+ " - Tipo: palabra reservada"); 
                                                                                tokenArray.push("Token: " +$3+ " - Tipo: simbolo");
                                                                                tokenArray.push("Token: " +$5+ " - Tipo: simbolo");
                                                                            }
    |tk_else                                                                { $$ = new Nodo("else","5");
                                                                                $$.addHijo(new Nodo($1,"else"));
                                                                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                            };


PRINTSENTENCE: tk_system '.' tk_out '.' tk_print tk_pa EXP tk_pc tk_puntoComa   { $$ = new Nodo("PRINT","");
                                                                        $$.addHijo(new Nodo($6,"("));
                                                                        $$.addHijo($7);
                                                                        $$.addHijo(new Nodo($8,")"));
                                                                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                        tokenArray.push("Token: " +$3+ " - Tipo: palabra reservada");
                                                                        tokenArray.push("Token: " +$4+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$5+ " - Tipo: palabra reservada");
                                                                        tokenArray.push("Token: " +$6+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$8+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$9+ " - Tipo: simbolo");
                                                                    }
    |tk_system '.' tk_out '.' tk_println tk_pa EXP tk_pc  tk_puntoComa          { $$ = new Nodo("PRINT","");
                                                                        $$.addHijo(new Nodo($6,"("));
                                                                        $$.addHijo($7);
                                                                        $$.addHijo(new Nodo($8,")"));
                                                                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                                                        tokenArray.push("Token: " +$3+ " - Tipo: palabra reservada");
                                                                        tokenArray.push("Token: " +$4+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$5+ " - Tipo: palabra reservada");
                                                                        tokenArray.push("Token: " +$6+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$8+ " - Tipo: simbolo");
                                                                        tokenArray.push("Token: " +$9+ " - Tipo: simbolo");
                                                                    };


RETURNS: tk_break   { $$ = new Nodo("RET","1");
                        $$.addHijo(new Nodo($1,"break"));
                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                    }
    |tk_continue    { $$ = new Nodo("RET","2");
                        $$.addHijo(new Nodo($1,"continue"));
                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                    }
    |tk_return EXP  { $$ = new Nodo("RET","3");
                        $$.addHijo(new Nodo($1,"return"));
                        $$.addHijo($2);
                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                    };


BOOLEAN: tk_boolean tk_id '=' tk_true tk_puntoComa  { $$ = new Nodo("BOOLE","");
                                                        $$.addHijo(new Nodo($1,"boolean"));
                                                        $$.addHijo(new Nodo($2,"id"));
                                                        $$.addHijo(new Nodo($3,"="));
                                                        $$.addHijo(new Nodo($4,"true"));
                                                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                        tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                                        tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                        tokenArray.push("Token: " +$4+ " - Tipo: palabra reservada"); 
                                                        tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                    }
    |tk_boolean tk_id '=' tk_false tk_puntoComa     { $$ = new Nodo("BOOLE","");
                                                        $$.addHijo(new Nodo($1,"boolean"));
                                                        $$.addHijo(new Nodo($2,"id"));
                                                        $$.addHijo(new Nodo($3,"="));
                                                        $$.addHijo(new Nodo($4,"false"));
                                                        tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                                        tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                                        tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                                        tokenArray.push("Token: " +$4+ " - Tipo: palabra reservada"); 
                                                        tokenArray.push("Token: " +$5+ " - Tipo: simbolo"); 
                                                    };


DEC: tk_id '++' { $$ = new Nodo("DEC",""); 
                    $$.addHijo(new Nodo($1,"id"));
                    $$.addHijo(new Nodo("++","adicion"));
                    tokenArray.push("Token: " +$1+ " - Tipo: id"); 
                    tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                }
    |tk_id '--' { $$ = new Nodo("DEC",""); 
                    $$.addHijo(new Nodo($1,"id"));
                    $$.addHijo(new Nodo("--","sustraccion"));
                    tokenArray.push("Token: " +$1+ " - Tipo: id"); 
                    tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                }
    |ERROR tk_puntoComa;//  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una declaracion");};



CONDITION: tk_int tk_id                 { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                        } 
    |tk_double tk_id                    { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                        }
    |tk_char tk_id                      { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                        }                                                    
    |tk_string tk_id                    { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada"); 
                                            tokenArray.push("Token: " +$2+ " - Tipo: id"); 
                                        }      
    |CONDITION '=' tk_numero            { $$ = new Nodo("COND","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,"="));
                                            $$.addHijo(new Nodo($3,"numero"));
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: numero"); 
                                        }                                
    |CONDITION '=' tk_id                { $$ = new Nodo("COND","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,"="));
                                            $$.addHijo(new Nodo($3,"id"));
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                        }                                                        
    |ERROR tk_puntoComa;//  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una condicion");};


VARIABLES: VARIABLES tk_coma tk_id      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,","));
                                            $$.addHijo(new Nodo($3,"id"));
                                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$3+ " - Tipo: id"); 
                                        }  
    |tk_string tk_id '=' tk_cadena      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: cadena"); 
                                        } 
    |tk_char tk_id '=' tk_cadena        { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: cadena"); 
                                        }
    |tk_int tk_id '=' tk_numero         { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: numero"); 
                                        }
    |tk_double tk_id '=' tk_numero      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: numero"); 
                                        }
    |tk_int tk_id '=' tk_id             { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: id"); 
                                        }
    |tk_double tk_id '=' tk_id          { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                            tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                            tokenArray.push("Token: " +$2+ " - Tipo: id");  
                                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                                            tokenArray.push("Token: " +$4+ " - Tipo: id"); 
                                        }
    |tk_string tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"string"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                tokenArray.push("Token: " +$2+ " - Tipo: id");  
                            }
    |tk_char tk_id          { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"char"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                tokenArray.push("Token: " +$2+ " - Tipo: id");  
                            }
    |tk_int tk_id           { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"int"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                tokenArray.push("Token: " +$2+ " - Tipo: id");  
                            }
    |tk_double tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"double"));
                                $$.addHijo(new Nodo($2,"id"));
                                tokenArray.push("Token: " +$1+ " - Tipo: palabra reservada");
                                tokenArray.push("Token: " +$2+ " - Tipo: id");  
                            }
    |tk_id '=' tk_numero            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"numero"));
                                        tokenArray.push("Token: " +$1+ " - Tipo: id");
                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                                        tokenArray.push("Token: " +$3+ " - Tipo: numero");  
                                    }
    |tk_id '=' tk_cadena            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"cadena"));
                                        tokenArray.push("Token: " +$1+ " - Tipo: id");
                                        tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                                        tokenArray.push("Token: " +$3+ " - Tipo: cadena");  
                                    };


EXPRE: EXPRE ',' EXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,","));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP                { $$ = new Nodo("EXP","");
                                $$.addHijo($1);
                        };

EXP: EXP '&&' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"&&"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '||' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"||"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '!' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"!"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }    
    |EXP '^' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"^"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }  
    |EXP '<' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"<"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        } 
    |EXP '<=' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"<="));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '>=' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,">="));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        } 
    |EXP '>' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,">"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '==' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"=="));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '!=' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"!="));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '+' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"+"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '-' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"-"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '*' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"*"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '/' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"/"));
                            $$.addHijo($3);
                            tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                        }
    |EXP '++'   { $$ = new Nodo("EXP",""); 
                    $$.addHijo($1);
                    $$.addHijo(new Nodo($2,"++"));
                    tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                }
    |EXP '--'   { $$ = new Nodo("EXP",""); 
                    $$.addHijo($1);
                    $$.addHijo(new Nodo($2,"--"));
                    tokenArray.push("Token: " +$2+ " - Tipo: simbolo");  
                }
    |tk_pa EXP tk_pc    { $$ = new Nodo("EXP","");
                            $$.addHijo(new Nodo($1,"("));
                            $$.addHijo($2); 
                            $$.addHijo(new Nodo($3,")"));
                            tokenArray.push("Token: " +$1+ " - Tipo: simbolo");  
                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo");  
                        }
    |tk_numero      { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"numero"));
                        tokenArray.push("Token: " +$1+ " - Tipo: numero");  
                    }
    |tk_id          { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"id"));
                        tokenArray.push("Token: " +$1+ " - Tipo: id");  
                    } 
    |tk_cadena      { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"cadena"));
                        tokenArray.push("Token: " +$1+ " - Tipo: cadena");  
                    }
    |;

DEFEXP: tk_numero   { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"numero"));
                        tokenArray.push("Token: " +$1+ " - Tipo: numero"); 
                    }
    |tk_id          { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"id"));
                        tokenArray.push("Token: " +$1+ " - Tipo: id"); 
                    }  
    |tk_cadena      { $$ = new Nodo("EXP","");
                        $$.addHijo(new Nodo($1,"cadena"));
                        tokenArray.push("Token: " +$1+ " - Tipo: cadena");  
                    }
    |tk_pa EXP tk_pc    { $$ = new Nodo("EXP","");
                            $$.addHijo(new Nodo($1,"("));
                            $$.addHijo($2); 
                            $$.addHijo(new Nodo($3,")"));
                            tokenArray.push("Token: " +$1+ " - Tipo: simbolo"); 
                            tokenArray.push("Token: " +$3+ " - Tipo: simbolo"); 
                        };














/*
ERROR: error {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una instruccion valida");};
*/

ERROR: error {
   if($1!=';' && !panic){
			let row = this._$.first_line;
			let column = this._$.first_column + 1;
	        let newError = count.toString() + "." + 
                " Error sintáctico: "+ $1 +               
                "  - linea: " + row +
                " - columna: " + column +
                ". Se esperaba una instruccion correcta"
                "\n";
			count+=1;
			errors.push(newError);
			console.log('Este es un error sintactico: ' + $1 + '. En la fila: '+ (yylineno + 1) + ', columna: '+this._$.first_column);
			panic = true;
    }else if($1==';'){
		panic = false;
	}
	}
};

