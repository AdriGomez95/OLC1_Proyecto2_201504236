var idNodo = 1;
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
        
        nodo.hijos.forEach(element => {
            //TRANSICIONES
            console.log(nodo.id +' -> '+ idNodo +';');
            this.recorrerArbol(element);
        });
    }
}

module.exports = arbolRecorrido;
