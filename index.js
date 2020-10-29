let errorsArray = [];

/**
 * Tries to connect to another url (in this case should be our back-end server)
 * and executes a POST operation
 */

/************* Manda el texto del area principal al backEnd NODE *************/
function Conn() {

    alert("Actualizado ");

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


function processJson(files) {
    var file = files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
        // Cuando éste evento se dispara, los datos están ya disponibles.
        // Se trata de copiarlos a una área <div> en la página.
        let text = document.getElementById("ast");
        text.textContent = e.target.result;
        text.value = text.textContent;
        //document.getElementById("javaText").value = output.textContent;
    };
    reader.readAsText(file);
}

function ShowErrors(){
    alert("actualizado ");
    let SendErrors = "";
    
    errorsArray.forEach(error => {
        SendErrors += error + "\n";
    });
    document.getElementById("txtjs").value = SendErrors;
}

function htmlReport() {
    let htmlText = "<html>\n" +
        "<head>\n" +
        "<meta charset='utf-16'>\n" +
        "<title>Reporte - Errores</title>\n" +
        "<body>\n" +
        "<h1>\n" +
        "<center>Listado de Errores y su descripción</center>\n" +
        "</h1>\n" +
        "<body>\n" +
        "<center>\n"
        + "<p>\n"
        + "<br>\n"
        + "</p>\n"
        + "<table border= 4>\n"
        + "<tr>\n" +
        "<td><center><b>#</b></center></td>\n"
        + "<td><center><b>Error</b></center></td>\n"
        + "<td><center><b>Fila</b></center></td>\n"
        + "<td><center><b>Columna</b></center></td>\n"
        + "<td><center><b>Descripción</b></center></td>\n"
        + "</tr>\n";
    errorsArray.forEach(error => {
        htmlText += error + "\n";
    });
    htmlText += "</table>\n" +
        "</center>\n" +
        "</body>\n" +
        "</html>";
    saveFile(htmlText, "Errores.html");
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