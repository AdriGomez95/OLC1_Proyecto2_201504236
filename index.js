let errorsArray = [];

/************* Manda el texto del area principal al backEnd NODE *************/
function Conn() {

    var url = 'http://localhost:8080/Analyze/';

    var dataAsJson = {
        input: document.getElementById("javaText").value
    };

    $.post(url, dataAsJson, function (data, status) {
        console.log(status);
        if (data.length == 0) {
            alert("No hay errores");
        }
        else {
            alert("Sí hay errores");
            errorsArray = data;
        }
    });
}


/************* Abrir archivos *************/
function processFiles(files) {
    var file = files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
        // Cuando éste evento se dispara, los datos están ya disponibles.
        // Se trata de copiarlos a una área <div> en la página.
        var output = document.getElementById("fileOutput");
        output.textContent = e.target.result;
        document.getElementById("javaText").value = output.textContent;
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