/*
const http = require('http');

const hostname = '127.0.0.1';
const port = 8080;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('\n \n                   Hola Adriana \n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
*/






var fs = require('fs');
var parser = require('./gramatica');
var arbol = require('./arbolRecorrido');
//crear variables para el texto del arbol y mandarlo en consola luego a la pagina

/*
fs.readFile('./entrada.txt', (err,data) => {
   // if (err) trhow err;
    //parser.parse(data.toString());

    var raiz = new arbol();
    var SendCodigoGrafo="";
    var SendCodigoTraduccion="";

    //SendCodigoGrafo += raiz.recorrerArbol(arbolNodo);
    SendCodigoGrafo += raiz.recorrerArbol( parser.parse(data.toString()));
    console.log(SendCodigoGrafo);

    //raiz.traduccionTree( parser.parse(data.toString()));
    //SendCodigoTraduccion += raiz.traduccionTree( parser.parse(data.toString()));
    //console.log(SendCodigoTraduccion);
});

*/





const express = require("express");
const app = express();
var cors = require('cors');
app.use(cors());

app.set('port', process.env.PORT || 8080);

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

var ast;
var parser = require('./gramatica');
var arbol = require('./arbolRecorrido');
var raiz = new arbol();
var SendCodigoGrafo="";
var SendCodigoTraduccion="";


app.post('/Analyze/', (req, res) => {
    try {
        const { input } = req.body;
        var fs = require('fs');
        //  se instancia al analizador o gramatica
        //var parser = require('./gramatica');
    
        try {
            ast = parser.parse(input.toString());
            SendCodigoGrafo += raiz.recorrerArbol(ast);
            SendCodigoTraduccion += raiz.traduccionTree(ast);
            fs.writeFileSync('./ast.json', JSON.stringify(ast, null, 2));
        } catch (e) {
            console.log("No se pudo recuperar del ultimo error");
            console.error(e);
        }
        
        let errors = require('./gramatica').errors;
        
        if (ast != undefined) {
            console.log(errors);
        }
        res.send(errors);
    } catch (e) {
        console.error(e);
    }
});






app.post('/TOK/', (req, res) => {
    try {
        
        let tokenArray = require('./gramatica').tokenArray;
        
        if (ast != undefined) {
            console.log(tokenArray);
        }
        res.send(tokenArray);

    } catch (e) {
        console.error(e);
    }
});




app.post('/Arbolin/', (req, res) => {
    try {
        
        console.log("ENTRO");
    
        
        if (ast != undefined) {
            console.log(SendCodigoGrafo);
        }
        res.send(SendCodigoGrafo);

    } catch (e) {
        console.error(e);
    }
});



app.post('/CodigoTraducido/', (req, res) => {
        console.log("ENTRO");
    
        
            console.log(SendCodigoTraduccion);
        
        res.send(SendCodigoTraduccion);

});
