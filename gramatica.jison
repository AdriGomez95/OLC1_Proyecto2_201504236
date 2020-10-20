/************************************************  Aqui los imports ************************************************/
%{
    let panic = false;
    const Nodo = require('./arbolNodo');
%}

/************************************************ Aqui va el lenguaje lexico ************************************************/

%lex
%options case-insensitive
%%

//ESPACIOS, ENTER Y RETORNOS
[ \t\r\n\f]          /*skip*/

//CADENA EN COMILLAS DOBLES
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]         %{yytext.substr(1,yyleng-2);  return 'tk_cadena'; %}

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
.                   %{ console.log("Error Lexico: "+yytext+"  - linea: "+yylloc.first_line+" - columna: "+yylloc.first_column); %}


/lex


/************************************************ Aqui va el lenguaje sintactico ***********************************************/
%left  '||'
%left  '&&'
%left  '==', '!='
%left  '>=', '<=', '<', '>'
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
    |error tk_puntoComa {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una clase");};


DEF: tk_public A tk_id tk_lla METHODS tk_llc                { $$ = new Nodo($1,"public");
                                                                $$.addHijo($2);
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"{"));
                                                                $$.addHijo($5);
                                                                $$.addHijo(new Nodo($6,"}"));
                                                            }
    |tk_public A tk_id tk_lla tk_llc                        { $$ = new Nodo($1,"public");
                                                                $$.addHijo($2);
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"{"));
                                                                $$.addHijo(new Nodo($5,"}"));
                                                            };


A: tk_class         { $$ = new Nodo($1,"class"); }
    |tk_interface   { $$ = new Nodo($1,"interface"); }
    |error tk_puntoComa {console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};


METHODS: METHODS DEFMET     { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                                $$.addHijo($2);
                            }
    |DEFMET                 { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                            } 
    |METHODS VARIABLES1 tk_puntoComa       { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                                $$.addHijo($2);
                            }
    |VARIABLES1  tk_puntoComa              { $$ = new Nodo("METODOS","");
                                $$.addHijo($1);
                            } 
    |METHODS tk_boolean tk_id '=' BOOLEAN tk_puntoComa      { $$ = new Nodo("METODOS","");
                                                                $$.addHijo($1);
                                                                $$.addHijo(new Nodo($2,"boolean"));
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"="));
                                                                $$.addHijo($5);
                                                            }
    |tk_boolean tk_id '=' BOOLEAN tk_puntoComa              { $$ = new Nodo("METODOS","");
                                                                $$.addHijo(new Nodo($1,"boolean"));
                                                                $$.addHijo(new Nodo($2,"id"));
                                                                $$.addHijo(new Nodo($3,"="));
                                                                $$.addHijo($4);
                                                            }
    |METHODS PRINTSENTENCE tk_puntoComa     { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                            }
    |PRINTSENTENCE tk_puntoComa             { $$ = new Nodo("METODOS","");
                                                $$.addHijo($1);
                                            }
    |error tk_puntoComa {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba un metodo");};



VARIABLES1: VARIABLES1 tk_coma tk_id      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,","));
                                            $$.addHijo(new Nodo($3,"id"));
                                        }  
    |tk_string tk_id '=' tk_cadena      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                        } 
    |tk_char tk_id '=' tk_cadena        { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                        }
    |tk_int tk_id '=' tk_numero         { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                        }
    |tk_double tk_id '=' tk_numero      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                        }
    |tk_int tk_id '=' tk_id             { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                        }
    |tk_double tk_id '=' tk_id          { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                        }
    |tk_string tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"string"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_char tk_id          { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"char"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_int tk_id           { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"int"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_double tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"double"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_id '=' tk_numero            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"numero"));
                                    }
    |tk_id '=' tk_cadena            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"cadena"));
                                    };


DEFMET: tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_lla SENTENCES tk_llc     { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                    $$.addHijo(new Nodo($7,"{"));
                                                                                    $$.addHijo($8);
                                                                                    $$.addHijo(new Nodo($9,"}"));
                                                                                }     
    |tk_public TYPE tk_id tk_pa  tk_pc tk_lla SENTENCES tk_llc                   { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($6,"{"));
                                                                                    $$.addHijo($7);
                                                                                    $$.addHijo(new Nodo($8,"}"));
                                                                                } 
    |tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_lla  tk_llc                 { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                }       
    |tk_public TYPE tk_id tk_pa tk_pc tk_lla tk_llc                             { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                }          
    |tk_public TYPE tk_id tk_pa PARAMETERS tk_pc tk_puntoComa                   { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($4,"("));
                                                                                    $$.addHijo($5);
                                                                                    $$.addHijo(new Nodo($6,")"));
                                                                                    $$.addHijo(new Nodo($7,";"));
                                                                                }    
    |tk_public TYPE tk_id tk_pa tk_pc tk_puntoComa                              { $$ = new Nodo($1,"public");
                                                                                    $$.addHijo($2);
                                                                                    $$.addHijo(new Nodo($3,"id"));
                                                                                    $$.addHijo(new Nodo($6,";"));
                                                                                }
    |tk_public tk_static tk_void tk_main tk_pa tk_string tk_ca tk_cc tk_args tk_pc tk_lla SENTENCES tk_llc   { $$ = new Nodo($4,"main");
                                                                                                                $$.addHijo(new Nodo($11,"{"));
                                                                                                                $$.addHijo(new Nodo($12,"}"));
                                                                                                            };


TYPE: tk_int        { $$ = new Nodo($1,"int"); }
    |tk_double      { $$ = new Nodo($1,"double"); }
    |tk_char        { $$ = new Nodo($1,"char"); }
    |tk_string      { $$ = new Nodo($1,"string"); }
    |tk_void        { $$ = new Nodo($1,"void"); }
    |tk_static      { $$ = new Nodo($1,"static"); }
    |tk_boolean     { $$ = new Nodo($1,"boolean"); }
    |error tk_puntoComa {console.log("Error sintactico en la linea: "+this._$.first_line+" y columna: "+this._$.first_column);};


PARAMETERS: PARAMETERS DEFPA    { $$ = new Nodo("PARAMET","");
                                    $$.addHijo($1);
                                    $$.addHijo($2);
                                }
    |DEFPA                      { $$ = new Nodo("PARAMET","");
                                    $$.addHijo($1);
                                }
    |error tk_puntoComa  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba un parametro");};
    

DEFPA: tk_int tk_id         { $$ = new Nodo($1,"int"); 
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_double tk_id        { $$ = new Nodo($1,"double"); 
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_char tk_id          { $$ = new Nodo($1,"char"); 
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_string tk_id        { $$ = new Nodo($1,"string"); 
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_boolean tk_id       { $$ = new Nodo($1,"boolean"); 
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_coma                { $$ = new Nodo($1,","); 
                            };








//INICIA LA SUPER PRODUCCION
SENTENCES: SENTENCES DEFSENT tk_lla tk_llc  { $$ = new Nodo("SENTENCIAS","");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                                $$.addHijo(new Nodo($3,"{"));
                                                $$.addHijo(new Nodo($4,"}"));
                                            }
    |DEFSENT tk_lla tk_llc                  { $$ = new Nodo("SENTENCIAS","");
                                                $$.addHijo($1);
                                                $$.addHijo(new Nodo($2,"{"));
                                                $$.addHijo(new Nodo($3,"}"));
                                            }
    |SENTENCES DEFSENT tk_lla SENTENCES tk_llc  { $$ = new Nodo("SENTENCIAS","");
                                                    $$.addHijo($1);
                                                    $$.addHijo($2);
                                                    $$.addHijo(new Nodo($3,"{"));
                                                    $$.addHijo($4);
                                                    $$.addHijo(new Nodo($5,"}"));
                                                }
    |DEFSENT tk_lla SENTENCES tk_llc            { $$ = new Nodo("SENTENCIAS","");
                                                    $$.addHijo($1);
                                                    $$.addHijo(new Nodo($2,"{"));
                                                    $$.addHijo($3);
                                                    $$.addHijo(new Nodo($4,"}"));
                                                }            
    //AQUI INICIA EL DO WHILE
    |SENTENCES tk_do tk_lla SENTENCES tk_llc tk_while tk_pa EXPRE tk_pc tk_puntoComa  { $$ = new Nodo("SENTENCIAS","");
                                                                                        $$.addHijo(new Nodo($1,"doWhile"));
                                                                                        $$.addHijo($2);
                                                                                        $$.addHijo(new Nodo($3,"{"));
                                                                                        $$.addHijo($4);
                                                                                        $$.addHijo(new Nodo($5,"}"));
                                                                                        $$.addHijo(new Nodo($7,"("));
                                                                                        $$.addHijo($8);
                                                                                        $$.addHijo(new Nodo($9,")"));
                                                                                    }
    |tk_do tk_lla SENTENCES tk_llc  tk_while tk_pa EXPRE tk_pc tk_puntoComa           { $$ = new Nodo("SENTENCIAS","");
                                                                                        $$.addHijo(new Nodo($1,"doWhile"));
                                                                                        $$.addHijo(new Nodo($2,"{"));
                                                                                        $$.addHijo($3);
                                                                                        $$.addHijo(new Nodo($4,"}"));
                                                                                        $$.addHijo(new Nodo($6,"("));
                                                                                        $$.addHijo($7);
                                                                                        $$.addHijo(new Nodo($8,")"));
                                                                                    }
    |SENTENCES tk_do tk_lla  tk_llc tk_while tk_pa EXPRE tk_pc tk_puntoComa   { $$ = new Nodo("SENTENCIAS","");
                                                                                $$.addHijo(new Nodo($1,"doWhile"));
                                                                                $$.addHijo($2);
                                                                                $$.addHijo(new Nodo($3,"{"));
                                                                                $$.addHijo(new Nodo($4,"}"));
                                                                                $$.addHijo(new Nodo($6,"("));
                                                                                $$.addHijo($7);
                                                                                $$.addHijo(new Nodo($8,")"));
                                                                            }
    |tk_do tk_lla  tk_llc  tk_while tk_pa EXPRE tk_pc tk_puntoComa            { $$ = new Nodo("SENTENCIAS","");
                                                                                $$.addHijo(new Nodo($1,"doWhile"));
                                                                                $$.addHijo(new Nodo($2,"{"));
                                                                                $$.addHijo(new Nodo($3,"}"));
                                                                                $$.addHijo(new Nodo($5,"("));
                                                                                $$.addHijo($6);
                                                                                $$.addHijo(new Nodo($7,")"));
                                                                            }
    //AQUI FINALIZA EL DO WHILE
    //AQUI INICIAN LOS RETURNS, PRINT Y EL RESTO
    |SENTENCES VARIABLES tk_puntoComa   { $$ = new Nodo("SENTENCIAS","");
                                            $$.addHijo($1);
                                            $$.addHijo($2);
                                            $$.addHijo(new Nodo($3,";"));
                                        }  
    |VARIABLES tk_puntoComa             { $$ = new Nodo("SENTENCIAS","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,";"));
                                        }
    |SENTENCES RETURNS tk_puntoComa     { $$ = new Nodo("SENTENCIAS","");
                                            $$.addHijo($1);
                                            $$.addHijo($2);
                                            $$.addHijo(new Nodo($3,";"));
                                        }
    |RETURNS tk_puntoComa               { $$ = new Nodo("SENTENCIAS","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,";"));
                                        }
    |SENTENCES tk_boolean tk_id '=' BOOLEAN tk_puntoComa    { $$ = new Nodo("SENTENCIAS","");
                                                                $$.addHijo($1);
                                                                $$.addHijo(new Nodo($2,"boolean"));
                                                                $$.addHijo(new Nodo($3,"id"));
                                                                $$.addHijo(new Nodo($4,"="));
                                                                $$.addHijo($5);
                                                            }
    |tk_boolean tk_id '=' BOOLEAN tk_puntoComa              { $$ = new Nodo("SENTENCIAS","");
                                                                $$.addHijo(new Nodo($1,"boolean"));
                                                                $$.addHijo(new Nodo($2,"id"));
                                                                $$.addHijo(new Nodo($3,"="));
                                                                $$.addHijo($4);
                                                            }
    |SENTENCES PRINTSENTENCE tk_puntoComa   { $$ = new Nodo("SENTENCIAS","");
                                                $$.addHijo($1);
                                                $$.addHijo($2);
                                            }
    |PRINTSENTENCE tk_puntoComa             { $$ = new Nodo("SENTENCIAS","");
                                                $$.addHijo($1);
                                            }   
    |SENTENCES EXPRE  tk_puntoComa  { $$ = new Nodo("SENTENCIAS","");
                                        $$.addHijo($1);
                                        $$.addHijo($2);
                                    }
    |EXPRE  tk_puntoComa            { $$ = new Nodo("SENTENCIAS","");
                                        $$.addHijo($1);
                                    };









DEFSENT: tk_for tk_pa CONDITION tk_puntoComa EXPRE tk_puntoComa DEC tk_pc   { $$ = new Nodo("for","");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,";"));
                                                                                $$.addHijo($5);
                                                                                $$.addHijo(new Nodo($6,";"));
                                                                                $$.addHijo($7);
                                                                                $$.addHijo(new Nodo($8,")"));
                                                                            }
    |tk_while tk_pa EXPRE tk_pc                                             { $$ = new Nodo("while","");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,")"));
                                                                            }
    |tk_if tk_pa EXPRE tk_pc                                                { $$ = new Nodo("if","");
                                                                                $$.addHijo(new Nodo($2,"("));
                                                                                $$.addHijo($3);
                                                                                $$.addHijo(new Nodo($4,")"));
                                                                            }
    |tk_else tk_if tk_pa EXPRE tk_pc                                        { $$ = new Nodo("elif","");
                                                                                $$.addHijo(new Nodo($3,"("));
                                                                                $$.addHijo($4);
                                                                                $$.addHijo(new Nodo($5,")"));
                                                                            }
    |tk_else                                                                { $$ = new Nodo("else","");
                                                                                $$.addHijo(new Nodo($1,"else"));
                                                                            };


PRINTSENTENCE: tk_system '.' tk_out '.' tk_print tk_pa EXP tk_pc    { $$ = new Nodo("print","");
                                                                        $$.addHijo(new Nodo($6,"("));
                                                                        $$.addHijo($7);
                                                                        $$.addHijo(new Nodo($8,")"));
                                                                    }
    |tk_system '.' tk_out '.' tk_println tk_pa EXP tk_pc            { $$ = new Nodo("println","");
                                                                        $$.addHijo(new Nodo($6,"("));
                                                                        $$.addHijo($7);
                                                                        $$.addHijo(new Nodo($8,")"));
                                                                    };


RETURNS: tk_break   { $$ = new Nodo("RETU","");
                        $$.addHijo(new Nodo($1,"break"));
                    }
    |tk_continue    { $$ = new Nodo("RET","");
                        $$.addHijo(new Nodo($1,"continue"));
                    }
    |tk_return EXP  { $$ = new Nodo("RET","");
                        $$.addHijo(new Nodo($1,"return"));
                        $$.addHijo($2);
                    };


BOOLEAN: tk_true    { $$ = new Nodo("BOOLE","");
                        $$.addHijo(new Nodo($1,"true"));
                    }
    |tk_false       { $$ = new Nodo("BOOLE","");
                        $$.addHijo(new Nodo($1,"false"));
                    };


DEC: tk_id '++' { $$ = new Nodo("DEC",""); 
                    $$.addHijo(new Nodo($1,"id"));
                    $$.addHijo(new Nodo("++","adicion"));
                }
    |tk_id '--' { $$ = new Nodo("DEC",""); 
                    $$.addHijo(new Nodo($1,"id"));
                    $$.addHijo(new Nodo("--","sustraccion"));
                }
    |error tk_puntoComa  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una declaracion");};


CONDITION: tk_int tk_id                 { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                        } 
    |tk_double tk_id                    { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                        }
    |tk_char tk_id                      { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                        }                                                    
    |tk_string tk_id                    { $$ = new Nodo("COND","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                        }      
    |CONDITION '=' tk_numero            { $$ = new Nodo("COND","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,"="));
                                            $$.addHijo(new Nodo($3,"numero"));
                                        }                                
    |CONDITION '=' tk_id                { $$ = new Nodo("COND","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,"="));
                                            $$.addHijo(new Nodo($3,"id"));
                                        }                                                        
    |error tk_puntoComa  {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una condicion");};


VARIABLES: VARIABLES tk_coma tk_id      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo($1);
                                            $$.addHijo(new Nodo($2,","));
                                            $$.addHijo(new Nodo($3,"id"));
                                        }  
    |tk_string tk_id '=' tk_cadena      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"string"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                        } 
    |tk_char tk_id '=' tk_cadena        { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"char"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"cadena"));
                                        }
    |tk_int tk_id '=' tk_numero         { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                        }
    |tk_double tk_id '=' tk_numero      { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"numero"));
                                        }
    |tk_int tk_id '=' tk_id             { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"int"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                        }
    |tk_double tk_id '=' tk_id          { $$ = new Nodo("VARIAB","");
                                            $$.addHijo(new Nodo($1,"double"));
                                            $$.addHijo(new Nodo($2,"id"));
                                            $$.addHijo(new Nodo($3,"="));
                                            $$.addHijo(new Nodo($4,"id"));
                                        }
    |tk_string tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"string"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_char tk_id          { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"char"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_int tk_id           { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"int"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_double tk_id        { $$ = new Nodo("VARIAB","");
                                $$.addHijo(new Nodo($1,"double"));
                                $$.addHijo(new Nodo($2,"id"));
                            }
    |tk_id '=' tk_numero            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"numero"));
                                    }
    |tk_id '=' tk_cadena            { $$ = new Nodo("VARIAB","");
                                        $$.addHijo(new Nodo($1,"id"));
                                        $$.addHijo(new Nodo($2,"="));
                                        $$.addHijo(new Nodo($3,"cadena"));
                                    };


EXPRE: EXPRE ',' EXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,","));
                            $$.addHijo($3);
                        }
    |EXP                { $$ = new Nodo("EXP","");
                                $$.addHijo($1);
                        };

EXP: EXP '&&' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"&&"));
                            $$.addHijo($3);
                        }
    |EXP '||' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"||"));
                            $$.addHijo($3);
                        }
    |EXP '!' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"!"));
                            $$.addHijo($3);
                        }    
    |EXP '^' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"^"));
                            $$.addHijo($3);
                        }  
    |EXP '<' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"<"));
                            $$.addHijo($3);
                        } 
    |EXP '<=' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"<="));
                            $$.addHijo($3);
                        }
    |EXP '>=' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,">="));
                            $$.addHijo($3);
                        } 
    |EXP '>' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,">"));
                            $$.addHijo($3);
                        }
    |EXP '==' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"=="));
                            $$.addHijo($3);
                        }
    |EXP '!=' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"!="));
                            $$.addHijo($3);
                        }
    |EXP '+' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"+"));
                            $$.addHijo($3);
                        }
    |EXP '-' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"-"));
                            $$.addHijo($3);
                        }
    |EXP '*' DEFEXP     { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"*"));
                            $$.addHijo($3);
                        }
    |EXP '/' DEFEXP    { $$ = new Nodo("EXP","");
                            $$.addHijo($1);
                            $$.addHijo(new Nodo($2,"/"));
                            $$.addHijo($3);
                        }
    |EXP '++'   { $$ = new Nodo("EXP",""); 
                    $$.addHijo($1);
                    $$.addHijo(new Nodo($2,"++"));
                }
    |EXP '--'   { $$ = new Nodo("EXP",""); 
                    $$.addHijo($1);
                    $$.addHijo(new Nodo($2,"--"));
                }
    |tk_pa EXP tk_pc    { $$ = new Nodo("EXP","");
                            $$.addHijo($2); 
                        }
    |tk_numero  { $$ = new Nodo($1,"numero"); }
    |tk_id      { $$ = new Nodo($1,"id"); } 
    |tk_cadena  { $$ = new Nodo($1,"cadena"); }
    |;

DEFEXP: tk_numero   { $$ = new Nodo($1,"numero"); }
    |tk_id          { $$ = new Nodo($1,"id"); } 
    |tk_cadena      { $$ = new Nodo($1,"cadena"); }
    |tk_pa EXP tk_pc    { $$ = new Nodo("EXP","");
                            $$.addHijo($2); 
                        };
















/*
ERROR: error {console.log("Error sintactico - linea: "+this._$.first_line+" - columna: "+this._$.first_column+" - Se esperaba una instruccion valida");};

ERROR: error {
   if($1!=';' && !panic){
			
			console.log('Este es un error sintactico: ' + + '. En la linea: '+ this._$.first_line + ', columna: '+this._$.first_column);
			panic = true;
    }else if($1==';'){
			panic = false;
	}
};
*/