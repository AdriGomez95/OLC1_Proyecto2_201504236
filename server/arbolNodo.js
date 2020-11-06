class arbolNodo{

    constructor(valor, tipo){
        this.id=0;
        this.valor = valor;
        this.tipo = tipo;
        this.hijos = [];
    }

    getValor(){
        this.valor;
    }
    
    getTipo(){
        this.tipo;
    }

    addHijo(hijo){
        this.hijos.push(hijo);
    }
}

module.exports = arbolNodo;