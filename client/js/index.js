let errorsArray = [];
let tokensArray = [];
let ArbolGet="";
let TraduccionGet="";



/************* Manda el texto del area principal al backEnd NODE *************/
function Conexion() {

    alert("Actualizado 55");

    var url = 'http://localhost:8080/Analyze/';

    var dataAsJson = {
        input: document.getElementById("javaText").value
    };

    $.post(url, dataAsJson, function (data, status) {
        console.log(status);
        if (data.length == 0) {
            alert("Archivo analizado sin errores");
        }
        else {
            alert("Archivo analizado con errores");
            errorsArray = data;
        }
    });
}



/************* Muestra los tokens de JS *************/
function ShowTokensJS() {
    alert("Actualizado 55");

    var url = 'http://localhost:8080/TOK/';

    var dataAsJson = {
        input: document.getElementById("javaText").value
    };

    $.post(url, dataAsJson, function (data, status) {
        tokensArray = data;
        
    });

    
    let SendTokens = "";
    let contador = 1;
    tokensArray.forEach(token => {
        SendTokens += contador + ". "+token + "\n";
        contador+=1;
    });
    document.getElementById("txtTokens").value = SendTokens;


}



/************* Muestra los errores de JS *************/
function ShowErrorsJS(){
    alert("Actualizado 55");
    let SendErrors = "";
    if(errorsArray!=null){
        errorsArray.forEach(error => {
            SendErrors += error + "\n";
        });
        document.getElementById("txtjs").value = SendErrors;

    }else{
        document.getElementById("txtjs").value = "";

    }
}



/************* Muestra codigo del arbol *************/
function ShowTree(){
    alert("Actualizado 55");
    var url = 'http://localhost:8080/Arbolin/';

    var dataAsJson = {
        input: document.getElementById("javaText").value
    };

    $.post(url, dataAsJson, function (data, status) {
        ArbolGet = data;
        
    });
    alert("despues del post "+ArbolGet);

    
    document.getElementById("txtShow").value = ArbolGet;
    alert(ArbolGet);
}

/************* Descarga el arbol *************/
function probandoArbol(){
    alert("Actualizado 55");
    /*
    d3.select("#graph").graphviz()
                        .renderDot("digraph  {"+ArbolGet+" }");

    */
    let htmlText = '<!DOCTYPE html>'
        +'<html>\n' 
        +'<meta charset="utf-8">\n' 
        +'<body>\n' 
        +'<script src="https://d3js.org/d3.v5.min.js"></script>\n' 
        +'<script src="https://unpkg.com/@hpcc-js/wasm@0.3.11/dist/index.min.js"></script>\n' 
        +'<script src="https://unpkg.com/d3-graphviz@3.0.5/build/d3-graphviz.js"></script>\n' 
        +'<div class="col">\n'
        +'<div class="row">\n'
        +'<div id="graph" style="text-align: center;"></div>\n' 
        +'<script>\n'
        + 'd3.select("#graph").graphviz()'
        + '.renderDot(\'digraph  { '
        + ArbolGet
        + ' }\');'
        + '</script>' 
        +'</div>\n'
        +'</div>\n'
        + '</body>\n' 
        +'</html>\n' 
    saveFile(htmlText, "ASTJS.html");
    
}



/************* Muestra traduccion del codigo *************/
function ShowCodeJS(){
    alert("Actualizado 55");
    var url = 'http://localhost:8080/CodigoTraducido/';

    var dataAsJson = {
        input: document.getElementById("javaText").value
    };

    $.post(url, dataAsJson, function (data, status) {
        TraduccionGet = data;
        
    });

    
    document.getElementById("txtShow").value = TraduccionGet;
    alert(TraduccionGet);
}

/************* Descarga el codigo traducido *************/
function probandoTraduccion(){
    alert("Actualizado 55");
    
    saveFile(TraduccionGet, "TraduccionJS.js");
    
}





/************* Abrir archivos *************/
function processFiles(files) {
    var file = files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
        
        var output = document.getElementById("fileOutput");
        output.textContent = e.target.result;
        document.getElementById("javaText").value = output.textContent;

        var editor=CodeMirror.fromTextArea(
            document.getElementById("javaText"),{ 
                lineNumbers: true,
                value: tact.value,
                matchBrackets: true,
                styleActiveLine: true,
                theme: "eclipse",
                mode: "text/x-java"
            });
        editor.setSize("550px","300px");
            /*
            let editor = document.getElementById("editor");
            let e = CodeMirror.fromTextArea(editor, {
                mode: "text/x-java",
                lineNumbers: true,
                theme: "material-darker"
            });
            e.setSize("","750px");
            */
        
    };
    reader.readAsText(file);
}



/************* Guardar archivos del area de texto principal *************/
function saveJava() {
    let javaText = document.getElementById("javaText").value;
    saveFile(javaText, "Archivo.txt");
}

function saveFile(text, name) {
    // get the textbox data...
    let textToWrite = text;
    // put the data in a Blob object...
    var textFileAsBlob = new Blob([textToWrite], { type: 'text/plain' });
    // create a hyperlink <a> element tag that will be automatically clicked below...
    var downloadLink = document.createElement("a");
    // set the file name...
    downloadLink.download = name;
    // set the <a> tag href as a URL to point to the Blob
    downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
    // automatically click the <a> element to go to the URL to save the textFileAsBlob...
    downloadLink.click();
}