
const express = require("express");
const app = express();
var cors = require('cors');
app.use(cors());

app.set('port', process.env.PORT || 8079);

//  middlewares
const morgan = require("morgan");
app.use(morgan('dev'));
app.use(express.urlencoded({ extended: false }));
app.use(express.json());


//  Inicio la app
app.listen(app.get('port'), () => {
    console.log(`Server on port ${app.get('port')}`);
});
//  Metodos
app.get('/', (req, res) => {
    console.log('Just for testing')
    res.send('Hello');
});





let errLEX;

app.post('/AnalyzePY/', (req, res) => {
    console.log("ENTRO");

    const { input } = req.body;
    //var entrada = req.body.text;
    recorreGramatica(input.toString());    
    console.log(input.toString());
    res.send(errLEX);
});



function recorreGramatica(parrafo){
    console.log("ENTRO AL METODO");
    /*
    if(parrafo==="a"){
        errLEX.push("hola");
    }else{
        errLEX.push("no se pudo");
    }*/
    errLEX = new Array();
    var estado = 0;
    var p="";
    var No=1;
    
    for(var i=0; i<parrafo.length; i++){
        console.log("\nENTRO AL FOR");
        switch(estado){
            case 0:
                if((parrafo[i]===" ")||(parrafo[i]==="\n")||(parrafo[i]==="\t")||(parrafo[i]==="\r")){
                    estado = 0;

                }else if(parrafo[i].match("[A-Aa-z]")){
                    //p=parrafo[i];
                    //errLEX.push("\nEstado uno "+p);
                    estado = 0;

                }else if(parrafo[i].match("[0-9]")){
                    //p=parrafo[i];
                    //errLEX.push("\nEstado dos "+p);
                    estado = 0;

                }else if(parrafo[i]==="/"){
                    //p=parrafo[i];
                    //errLEX.push("\n"+No+". barrita "+p);
                    estado = 1;

                }else if((parrafo[i]==="(")||(parrafo[i]===")")||(parrafo[i]==="{")||(parrafo[i]==="}")||(parrafo[i]==="[")||(parrafo[i]==="]")){
                    estado = 0;
                
                }else if((parrafo[i]===".")||(parrafo[i]===",")||(parrafo[i]===";")||(parrafo[i]===":")){
                    estado = 0;
                
                }else if((parrafo[i]===">")||(parrafo[i]==="<")||(parrafo[i]==="!")||(parrafo[i]==="-")||(parrafo[i]==="+")||(parrafo[i]==="*")||(parrafo[i]==="=")){
                    estado = 0;
                
                }else if(parrafo[i]==="'"){
                    estado = 12;

                }else if(parrafo[i]==="\""){
                    estado = 14;

                }else{
                    p=parrafo[i];
                    errLEX.push("\n"+No+". Error lexico "+p);
                    No+=1;
                    estado = 0;

                }
            

            
            
            case 1:
                if(parrafo[i]==="/"){
                    estado = 2;
                }else if(parrafo[i]==="*"){
                    estado = 4;
                }else{
                    p=parrafo[i];
                    errLEX.push("\n"+No+". Error lexico "+p);
                    No+=1;
                    estado = 0;
                }

            case 2:
                if(parrafo[i]==="\n"){
                    estado = 3;
                }else{
                    estado = 2;
                }

            //estado de aceptacion de comentarios
            case 3:
                estado = 0;




            //estado de aceptacion de letras
            case 7:
                estado = 0;
                /*
                if(parrafo[i].match("[A-Aa-z]")){
                    //p=parrafo[i];
                    //errLEX.push("\nEstado tres "+p);
                    estado = 0;
                }else{
                    p=parrafo[i];
                    errLEX.push("\n"+No+". Error lexico "+p);
                    No+=1;
                    estado = 0;

                }*/

                
            //estado de aceptacion de numeros
            case 8:
                estado = 0;
            
            
            //estado de aceptacion de ()[]{}
            case 9:
                estado = 0;


            //estado de aceptacion de .:;
            case 10:
                estado = 0;


            //estado de aceptacion de .:;
            case 11:
                estado = 0;


            case 12:
                if(parrafo[i]==="'"){
                    estado = 13;
                }else{
                    estado = 12;
                }

            
            case 13:
                estado = 0;


            case 14:
                if(parrafo[i]==="\""){
                    estado = 13;
                }else{
                    estado = 14;                    
                }


        }
    }    
    
    
};  