//
//  Turma.swift
//  SegundoTrabalho
//
//  Created by Cruz, Felipe Suzuki da on 26/10/26.
//

struct Turma {
    
    var listaAlunos : [Aluno] = [
        Aluno(nome: "Felipe", nota1: 7, nota2: 6),
        Aluno(nome: "Carol", nota1: 8, nota2: 5),
        Aluno(nome: "Gustavo", nota1: 9, nota2: 4),
        Aluno(nome: "Alice", nota1: 10, nota2: 8),
    ]
    
    mutating func adicionar(aluno : Aluno){
        self.listaAlunos.append(aluno);
        
    }
    
    mutating func remover(aluno : Aluno){
        self.listaAlunos.removeAll { $0.id == aluno.id }
    }
    
    func mediaClasse () -> Float{
        let soma = listaAlunos.reduce(0.0) { partialResult, aluno in
            partialResult + aluno.media()
        }
        if (listaAlunos.count == 0 ) {
            return 0
        }
        return soma/Float(listaAlunos.count)
        
    }
    
    func aprovados () -> Int {
        return  listaAlunos.filter{ $0.passou() }.count
    }
    
    func reprovados () -> Int {
        return  listaAlunos.filter{ !$0.passou() }.count
    }
    
}
