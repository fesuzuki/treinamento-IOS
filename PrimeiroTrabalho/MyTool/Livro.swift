//
//  Livro.swift
//  MyTool
//
//  Created by Cruz, Felipe Suzuki da on 12/10/26.
//

import Foundation

// MARK: - Protocolo Documento
/// Protocolo que define a estrutura básica de um documento no sistema.
protocol Documento {
    var id: Int { get }
    func exibirDetalhes()
}

// MARK: - Classe Livro
/// Representa um livro na biblioteca, em conformidade com o protocolo Documento.
class Livro: Documento {
    // MARK: - Propriedades com Encapsulamento
    // O ID é imutável após a criação para garantir integridade.
    let id: Int
    
    // Propriedades privadas para escrita externa (private(set))
    // garantindo que modificações passem pelos métodos apropriados.
    private(set) var titulo: String
    private(set) var autor: String
    private(set) var anoPublicacao: Int
    private(set) var isEmprestado: Bool
    
    // MARK: - Construtor
    init(id: Int, titulo: String, autor: String, anoPublicacao: Int, isEmprestado: Bool = false) {
        self.id = id
        self.titulo = titulo
        self.autor = autor
        self.anoPublicacao = anoPublicacao
        self.isEmprestado = isEmprestado
    }
    
    // MARK: - Métodos Modificadores (Encapsulamento)
    
    /// Realiza o empréstimo do livro caso esteja disponível.
    /// - Returns: `true` se o empréstimo foi realizado com sucesso, ou `false` se já estiver emprestado.
    @discardableResult
    func emprestar() -> Bool {
        guard !isEmprestado else {
            return false
        }
        isEmprestado = true
        return true
    }
    
    /// Realiza a devolução do livro caso esteja emprestado.
    /// - Returns: `true` se a devolução foi realizada com sucesso, ou `false` se o livro não estiver emprestado.
    @discardableResult
    func devolver() -> Bool {
        guard isEmprestado else {
            return false
        }
        isEmprestado = false
        return true
    }
    
    /// Atualiza as informações básicas do livro. Apenas os valores não nulos e válidos são alterados.
    func atualizar(titulo: String? = nil, autor: String? = nil, anoPublicacao: Int? = nil) {
        if let novoTitulo = titulo?.trimmingCharacters(in: .whitespacesAndNewlines), !novoTitulo.isEmpty {
            self.titulo = novoTitulo
        }
        
        if let novoAutor = autor?.trimmingCharacters(in: .whitespacesAndNewlines), !novoAutor.isEmpty {
            self.autor = novoAutor
        }
        
        if let novoAno = anoPublicacao, novoAno > 0 {
            self.anoPublicacao = novoAno
        }
    }
    
    // MARK: - Conformidade com Documento
    
    /// Exibe os detalhes formatados do livro no console.
    func exibirDetalhes() {
        let status = isEmprestado ? "📕 Emprestado" : "📗 Disponível"
        print("""
        +--------------------------------------------------
        | ID:                \(id)
        | Título:            \(titulo)
        | Autor:             \(autor)
        | Ano de Publicação: \(anoPublicacao)
        | Status:            \(status)
        +--------------------------------------------------
        """)
    }
}

// MARK: - Classe Biblioteca (Gerenciador de Coleção)
/// Gerencia a coleção de livros aplicando lógica de CRUD e integridade dos dados.
class Biblioteca {
    private var livros: [Livro] = []
    
    var totalLivros: Int {
        return livros.count
    }
    
    /// Adiciona um novo livro garantindo que não existam IDs duplicados.
    /// - Parameter livro: Instância de Livro a ser cadastrada.
    /// - Returns: `true` se cadastrado com sucesso, ou `false` se o ID já existir.
    @discardableResult
    func cadastrar(livro: Livro) -> Bool {
        guard !existeLivro(comId: livro.id) else {
            return false
        }
        livros.append(livro)
        return true
    }
    
    /// Verifica se já existe um livro cadastrado com o ID informado.
    func existeLivro(comId id: Int) -> Bool {
        return livros.contains { $0.id == id }
    }
    
    /// Lista todos os livros cadastrados na biblioteca.
    func listarTodos() {
        guard !livros.isEmpty else {
            print("\n⚠️  Nenhum livro cadastrado no sistema.")
            return
        }
        
        print("\n==================================================")
        print("          📚 LISTA DE LIVROS (\(livros.count))")
        print("==================================================")
        for livro in livros {
            livro.exibirDetalhes()
        }
    }
    
    /// Busca um livro por seu identificador único.
    /// - Parameter id: Identificador do livro.
    /// - Returns: O livro correspondente ou `nil` caso não seja encontrado.
    func buscar(porId id: Int) -> Livro? {
        return livros.first { $0.id == id }
    }
    
    /// Busca livros cujo título contenha o termo informado (busca parcial sem diferenciação de maiúsculas).
    /// - Parameter termo: Texto a ser buscado no título.
    /// - Returns: Lista de livros que satisfazem a busca.
    func buscar(porTitulo termo: String) -> [Livro] {
        let termoNormalizado = termo.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !termoNormalizado.isEmpty else { return [] }
        return livros.filter { $0.titulo.lowercased().contains(termoNormalizado) }
    }
    
    /// Remove um livro do sistema através do seu ID.
    /// - Parameter id: Identificador do livro a ser removido.
    /// - Returns: `true` se o livro foi encontrado e removido, ou `false` caso contrário.
    @discardableResult
    func remover(porId id: Int) -> Bool {
        if let index = livros.firstIndex(where: { $0.id == id }) {
            livros.remove(at: index)
            return true
        }
        return false
    }
}
