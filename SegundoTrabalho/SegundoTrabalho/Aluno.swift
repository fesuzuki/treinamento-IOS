//
//  Aluno.swift
//  MyApp
//
//  Created by Cruz, Felipe Suzuki da on 24/10/26.
//

import Foundation

struct Aluno: Identifiable {
    var id = UUID()
    var nome: String = ""
    var nota1: Float? = nil
    var nota2: Float? = nil
    
    
    func media() -> Float{
        let n1 = nota1 ?? 0.0
        let n2 = nota2 ?? 0.0
        return ((n1 + n2) / 2)
    }
    
    func passou()  -> Bool {
        if media() >= 7{
            return true
        }
        return false
    }
}
