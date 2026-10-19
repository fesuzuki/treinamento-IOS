//
//  LivroDigital.swift
//  MyTool
//
//  Created by Cruz, Felipe Suzuki da on 15/10/26.
//

import Foundation

// MARK: - Classe LivroDigital (Herança de Livro)
/// Representa um livro digital (e-book) que herda as características de Livro e adiciona informações sobre o tamanho do arquivo.
class LivroDigital: Livro {
    // MARK: - Propriedades Específicas
    private(set) var tamanhoEmMB: Double
    
    // MARK: - Construtor
    init(id: Int, titulo: String, autor: String, anoPublicacao: Int, tamanhoEmMB: Double, isEmprestado: Bool = false) {
        self.tamanhoEmMB = tamanhoEmMB
        super.init(id: id, titulo: titulo, autor: autor, anoPublicacao: anoPublicacao, isEmprestado: isEmprestado)
    }
    
    // MARK: - Sobrescrita de Métodos (Override)
    
    /// Exibe os detalhes formatados do livro digital no console, incluindo o tamanho em MB.
    override func exibirDetalhes() {
        let status = isEmprestado ? "📕 Emprestado" : "📗 Disponível"
        print("""
        +--------------------------------------------------
        | ID:                \(id)
        | Título:            \(titulo)
        | Autor:             \(autor)
        | Ano de Publicação: \(anoPublicacao)
        | Tamanho:           \(tamanhoEmMB) MB
        | Status:            \(status)
        +--------------------------------------------------
        """)
    }
}
