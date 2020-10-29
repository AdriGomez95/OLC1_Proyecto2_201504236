var idNodo = 1;
var CodigoTraduccion="";
class arbolRecorrido{
    constructor(){
    }

    recorrerArbol(nodo){
        if(nodo.id == 0){
            nodo.id = idNodo;
            idNodo++;
        }

        //MIS NODOS
        console.log(nodo.id +'[label = "'+ nodo.valor +'" shape = "circle"];');
        //dato+=nodo.id +'[label = "'+ nodo.valor +'" shape = "circle"];\n';

        
        //console.log(nodo.valor+"  valor de arriba");

        

        nodo.hijos.forEach(element => {
            //TRANSICIONES
            console.log(nodo.id +' -> '+ idNodo +';');
            //dato+=nodo.id +' -> '+ idNodo +';\n';

            
            
            //console.log(nodo.valor+"  valor del hijo")
            this.recorrerArbol(element);
        });
        
    }





    
    traduccionTree(nodo){//[METODOS.hijos[METODOS,public] o METODOS[public]
        //console.log(nodo.valor);
        if(nodo.valor=="RAIZ"){
            this.traduccionTree(nodo.hijos[0]); //RAIZ.hijos]
            console.log(CodigoTraduccion);
        }

        /********************************* CLASES *********************************************/
        else if(nodo.valor=="CLASE"){//[CLASE.hijos[CLASE,public] o CLASE[public]
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            console.log("Hijos Clase: "+pruebaTamaño);

            if(pruebaTamaño==1){
                if(nodo.hijos[0].hijos[0].valor=="class"){
                    CodigoTraduccion+= "\nclass " + nodo.hijos[0].hijos[1].valor +" {\n     constructor(){\n     }\n"
                    
                    
                    //AQUI VALIDAR SI VIENE O NO VACIA SIN METODOS
                    if(nodo.hijos[0].hijos[3].valor=="METODOS"){
                        this.traduccionTree(nodo.hijos[0].hijos[3]); //METODOS[hijos]
                        CodigoTraduccion+="\n}\n"  
                    }else{
                        //SI VIENE VACIO, SOLO CONCATENAR
                        CodigoTraduccion+="\n}\n"    
                    }

                }

            }else if(pruebaTamaño==2){

                //primero hacemos el hijo izquierdo
                this.traduccionTree(nodo.hijos[0]); //CLASE.hijos[CLASE,0;public,1]
                
               //luego hacemos el hijo derecho
               CodigoTraduccion+= "\nclass " + nodo.hijos[1].hijos[1].valor +" {\n     constructor(){\n     }\n"

               //AQUI VALIDAR SI VIENE O NO VACIA SIN METODOS              
              if(nodo.hijos[1].hijos[3].valor=="METODOS"){
                
                    this.traduccionTree(nodo.hijos[1].hijos[3]); //METODOS[hijos]
                    CodigoTraduccion+="\n}\n"  

                }else{
                    //SI VIENE VACIO, SOLO CONCATENAR
                    CodigoTraduccion+="\n}\n"    
                }

            }else{
                console.log("Fail Clase");
            }
        }

        /********************************* METODOS *********************************************/
        else if(nodo.valor=="METODOS"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            //console.log("nodos de metodos: "+pruebaTamaño);

            if(pruebaTamaño==1){
                if(nodo.hijos[0].valor=="public"){
                    if(nodo.hijos[0].tipo=="1"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[0].hijos[1].valor +"(";
                        this.traduccionTree(nodo.hijos[0].hijos[3]);
                        CodigoTraduccion+="){\n"
                        //console.log("SENTENCIAS: "+nodo.hijos[1].hijos[6].valor);
                        this.traduccionTree(nodo.hijos[0].hijos[6]);
                        CodigoTraduccion+="    }\n";
                        
                    }else if(nodo.hijos[0].tipo=="2"){
                        CodigoTraduccion+= "\n    "+ nodo.hijos[0].hijos[0].valor +" "+ nodo.hijos[0].hijos[1].valor +"(){\n     }\n";
                    }else if(nodo.hijos[0].tipo=="3"){
                        CodigoTraduccion+= "\n    "+ nodo.hijos[0].hijos[0].valor +" "+ nodo.hijos[0].hijos[1].valor +"(){\n     }\n";
                    }else if(nodo.hijos[0].tipo=="4"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[0].hijos[1].valor +"(){\n";
                            CodigoTraduccion+="    }\n";
                    }else if(nodo.hijos[0].tipo=="5"){
                        CodigoTraduccion+= "\n    "+ nodo.hijos[0].hijos[0].valor +" "+ nodo.hijos[0].hijos[1].valor +"(){\n     }\n";
                    }else if(nodo.hijos[0].tipo=="6"){
                        CodigoTraduccion+= "\n    "+ nodo.hijos[0].hijos[0].valor +" "+ nodo.hijos[0].hijos[1].valor +"(){\n     }\n";
                    }else if(nodo.hijos[0].tipo=="7"){
                        CodigoTraduccion+= "\n    function main( ){";
                        CodigoTraduccion+="\n";
                        this.traduccionTree(nodo.hijos[0].hijos[2]);
                        CodigoTraduccion+="    }\n";
                        
                    }else if(nodo.hijos[0].tipo=="8"){
                        CodigoTraduccion+= "\n    function main( ){ }\n";

                    }
                }else{
                    this.traduccionTree(nodo.hijos[0]);
                }


            }else if(pruebaTamaño==2){
                //primero hacemos el hijo izquierdo
                    this.traduccionTree(nodo.hijos[0]); //METODOS.hijos[METODOS,0; public,1; VARIAB,2; PRINT,3; BOOL,4]
                
               //luego hacemos el hijo derecho
                    this.traduccionTree(nodo.hijos[1]); //METODOS.hijos[METODOS,0; public,1; VARIAB,2; PRINT,3; BOOL,4]


                if(nodo.hijos[1].valor=="public"){
                    if(nodo.hijos[1].tipo=="1"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[1].hijos[1].valor +"(";
                        this.traduccionTree(nodo.hijos[1].hijos[3]);
                        CodigoTraduccion+="){\n"
                        //console.log("SENTENCIAS: "+nodo.hijos[1].hijos[6].valor);
                        this.traduccionTree(nodo.hijos[1].hijos[6]);
                        CodigoTraduccion+="    }\n";
                        
                    }else if(nodo.hijos[1].tipo=="2"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[1].hijos[1].valor +"( ){";
                        CodigoTraduccion+="\n";
                        this.traduccionTree(nodo.hijos[1].hijos[3]);
                        CodigoTraduccion+="    }\n";

                    }else if(nodo.hijos[1].tipo=="3"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[1].hijos[1].valor +"(";
                        this.traduccionTree(nodo.hijos[1].hijos[3]);
                        CodigoTraduccion+="){ }\n";

                    }else if(nodo.hijos[1].tipo=="4"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[1].hijos[1].valor +"( ){ }\n";

                    }else if(nodo.hijos[1].tipo=="5"){
                        CodigoTraduccion+= "\n    function "+ nodo.hijos[1].hijos[1].valor +"( );\n";
                    }else if(nodo.hijos[1].tipo=="6"){
                        CodigoTraduccion+= "\n    function ( );\n";

                    }else if(nodo.hijos[1].tipo=="7"){
                        CodigoTraduccion+= "\n    function main( ){";
                        CodigoTraduccion+="\n";
                        this.traduccionTree(nodo.hijos[1].hijos[2]);
                        CodigoTraduccion+="    }\n";
                        
                    }else if(nodo.hijos[1].tipo=="8"){
                        CodigoTraduccion+= "\n    function main( ){ }\n";

                    }

                    //CodigoTraduccion+= "\n    "+ nodo.hijos[1].hijos[0].valor +" "+ nodo.hijos[1].hijos[1].valor +"(){\n     }\n"
                    
                }


               

            }

        
        }

        /********************************* VARIABLES *********************************************/
        else if(nodo.valor=="VARIAB"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            //console.log("nodos de var: "+pruebaTamaño);

            if(pruebaTamaño==1){//algo asi -> char t;
                CodigoTraduccion+="\n     var "+nodo.hijos[1].valor;  
                
            }else if(pruebaTamaño==2){
                CodigoTraduccion+="\n     var "+nodo.hijos[1].valor; 

            }else if(pruebaTamaño==3){// si es coma: algo asi -> string x,y; 
                //this.traduccionTree(nodo.hijos[0]); //PRIMERO HACE IZQUIERDO: , y;
                this.traduccionTree(nodo.hijos[0]);
                CodigoTraduccion+= ", " +nodo.hijos[2].valor; 
                
            }else if(pruebaTamaño==4){//algo asi -> int x = 0;
                if(nodo.hijos[3].tipo=="cadena"){
                    CodigoTraduccion+="\n     var "+nodo.hijos[1].valor+" "+nodo.hijos[2].valor+" \""+nodo.hijos[3].valor+"\";\n";

                }else{
                    CodigoTraduccion+="\n     var "+nodo.hijos[1].valor+" "+nodo.hijos[2].valor+" "+nodo.hijos[3].valor+";\n";

                }
            }
        
        }

        /********************************* BOOLEANO *********************************************/
        else if(nodo.valor=="BOOLE"){

            CodigoTraduccion+="     var "+nodo.hijos[1].valor+" "+nodo.hijos[2].valor+" "+nodo.hijos[3].valor+";\n"; 
                     
        }

        /********************************* PRINT *********************************************/
        else if(nodo.valor=="PRINT"){

            CodigoTraduccion+="     console.log( ";
            this.traduccionTree(nodo.hijos[1]); 
            CodigoTraduccion+=" );\n";
                     
        }

        /********************************* EXP *********************************************/
        else if(nodo.valor=="EXP"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });

            //console.log("nodos de expresion: "+pruebaTamaño);
            if(pruebaTamaño==1){
                if(nodo.hijos[0].tipo=="id"){
                    CodigoTraduccion+= nodo.hijos[0].valor;
                }else if(nodo.hijos[0].tipo=="cadena"){
                    CodigoTraduccion+= "\""+nodo.hijos[0].valor+"\"";
                }else if(nodo.hijos[0].tipo=="numero"){
                    CodigoTraduccion+= nodo.hijos[0].valor;
                }else if(nodo.hijos[0].valor=="EXP"){
                    this.traduccionTree(nodo.hijos[0]); 
                }
                
            }else if(pruebaTamaño==2){
                this.traduccionTree(nodo.hijos[0]); 
                CodigoTraduccion+= nodo.hijos[1].valor;

            }else if(pruebaTamaño==3){
                if(nodo.hijos[1].valor=="EXP"){
                    CodigoTraduccion+= nodo.hijos[0].valor;
                    this.traduccionTree(nodo.hijos[1]); 
                    CodigoTraduccion+= nodo.hijos[2].valor;
                }else{
                    this.traduccionTree(nodo.hijos[0]); 
                    CodigoTraduccion+= nodo.hijos[1].valor;
                    this.traduccionTree(nodo.hijos[2]); 
                }
            }
                     
        }

        /********************************* PARAMETROS DE METODOS *********************************************/
        else if(nodo.valor=="PARAMET"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });

            if (pruebaTamaño==1){
                CodigoTraduccion+= " "+nodo.hijos[0].hijos[0].valor+" ";
            }else if(pruebaTamaño==2){
                this.traduccionTree(nodo.hijos[0]); 
                if(nodo.hijos[1].valor!=","){
                    CodigoTraduccion+= ", "+nodo.hijos[1].hijos[0].valor+" ";
                }
            }
                     
        }

        /********************************* SENTENCIAS *********************************************/
        else if(nodo.valor=="SENTENCIAS"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            
            console.log("nodos de sentencias: "+pruebaTamaño);
            //console.log(nodo.hijos[0].valor);
            //primero hijo izquierdo
            this.traduccionTree(nodo.hijos[0]); 

            //-----HACIENDO LOS QUE VAN VACIOS
            if(pruebaTamaño==7){//para el do while no vacio
                CodigoTraduccion+= "          do{\n";
                CodigoTraduccion+= "    ";
                this.traduccionTree(nodo.hijos[2]); 
                CodigoTraduccion+= "          } while( ";
                this.traduccionTree(nodo.hijos[5]); 
                CodigoTraduccion+= " );\n"; 

            }else if(pruebaTamaño==6){//para el do while vacio
               //console.log("aqui "+nodo.hijos[0].valor);
                CodigoTraduccion+= "          do{\n          } while( ";
                this.traduccionTree(nodo.hijos[4]); 
                CodigoTraduccion+= " );\n"; 

            }else if(pruebaTamaño==5){//para el do while vacio
                if(nodo.hijos[3].valor=="SENTENCIAS"){
                    this.traduccionTree(nodo.hijos[1]); 
                    CodigoTraduccion+= " {\n"; 
                    CodigoTraduccion+= "    ";
                    this.traduccionTree(nodo.hijos[3]); 
                    CodigoTraduccion+= "          }\n"; 
                }
                     
            //luego hijo derecho
            }else if(pruebaTamaño==4){//para cualquier otro pero vacío
                if(nodo.hijos[1].valor=="{"){
                    CodigoTraduccion+= "{\n";
                    CodigoTraduccion+= "    ";
                    this.traduccionTree(nodo.hijos[2]); 
                    CodigoTraduccion+= "          }\n";

                }else{
                    this.traduccionTree(nodo.hijos[1]); 
                    CodigoTraduccion+= "{\n          }\n";
                }

            }else if(pruebaTamaño==3){//para cualquier otro pero vacío
                this.traduccionTree(nodo.hijos[1]); 
                CodigoTraduccion+= "{\n          }\n";

            }else if(pruebaTamaño==2){
                CodigoTraduccion+= "     ";
                this.traduccionTree(nodo.hijos[1]);
            }else if(pruebaTamaño==1){
                  
                CodigoTraduccion+= "     ";
                //this.traduccionTree(nodo.hijos[0]);
                
            }
        }

        /********************************* FOR *********************************************/
        else if(nodo.valor=="for"){

            CodigoTraduccion+= "          for( ";
            this.traduccionTree(nodo.hijos[1]); 
            CodigoTraduccion+= "; ";
            this.traduccionTree(nodo.hijos[3]); 
            CodigoTraduccion+= "; ";
            this.traduccionTree(nodo.hijos[5]); 
            CodigoTraduccion+= " )";

        }

        /********************************* CONDITION del for *********************************************/
        else if(nodo.valor=="COND"){
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            
            //console.log("nodos de cond: "+pruebaTamaño);
            if(pruebaTamaño==2){
                CodigoTraduccion+= "var "+nodo.hijos[1].valor;

            }else if(pruebaTamaño==3){
                CodigoTraduccion+= "var = "+nodo.hijos[2].valor;

            }
        }

        /********************************* DEC del for *********************************************/
        else if(nodo.valor=="DEC"){            
            CodigoTraduccion+= nodo.hijos[0].valor+nodo.hijos[1].valor;

        }

        /********************************* IF *********************************************/
        else if(nodo.valor=="if"){            
            
            CodigoTraduccion+= "          if( ";
            this.traduccionTree(nodo.hijos[1]); 
            CodigoTraduccion+= " )";

        }

        /********************************* ELSE IF *********************************************/
        else if(nodo.valor=="elif"){            
            
            CodigoTraduccion+= "          else if";

        }

        /********************************* ELSE *********************************************/
        else if(nodo.valor=="else"){            
            
            CodigoTraduccion+= "          else";

        }

        /********************************* WHILE *********************************************/
        else if(nodo.valor=="while"){            
            
            CodigoTraduccion+= "          while( ";
            this.traduccionTree(nodo.hijos[1]); 
            CodigoTraduccion+= " )";

        }

        /********************************* RETURN *********************************************/
        else if(nodo.valor=="RET"){ 
            var pruebaTamaño=0;
            nodo.hijos.forEach(element => {
               pruebaTamaño++;
            });
            
            //console.log("nodos de cond: "+pruebaTamaño);
            if(pruebaTamaño==2){
                CodigoTraduccion+= "     return ";
                this.traduccionTree(nodo.hijos[1]); 
                CodigoTraduccion+= ";\n";

            }else if(pruebaTamaño==1){
                CodigoTraduccion+= "     "+nodo.hijos[0].valor;
                CodigoTraduccion+= ";\n";

            }           
            

        }

        
    }



}

module.exports = arbolRecorrido;
