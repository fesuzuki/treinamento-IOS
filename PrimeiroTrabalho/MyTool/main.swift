//
//  main.swift
//  MyTool
//
//  Created by Cruz, Felipe Suzuki da on 12/10/26.
//

import Foundation

// MARK: - Funções Auxiliares de Leitura do Console

/// Lê uma linha de texto do console, removendo espaços excedentes nas pontas.
func lerEntrada(mensagem: String) -> String {
    print(mensagem, terminator: "")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

/// Solicita um texto obrigatório ao usuário, repetindo até receber uma entrada não vazia.
func lerTextoObrigatorio(mensagem: String) -> String {
    while true {
        let entrada = lerEntrada(mensagem: mensagem)
        if !entrada.isEmpty {
            return entrada
        }
        print("❌ O campo não pode ficar vazio. Tente novamente.")
    }
}

/// Solicita um número inteiro obrigatório ao usuário, tratando conversões inválidas com segurança.
func lerInteiroObrigatorio(mensagem: String) -> Int {
    while true {
        let entrada = lerEntrada(mensagem: mensagem)
        if let valor = Int(entrada) {
            return valor
        }
        print("❌ Valor inválido! Digite um número inteiro.")
    }
}

/// Solicita um texto opcional. Retorna nil se o usuário apenas pressionar Enter.
func lerTextoOpcional(mensagem: String) -> String? {
    let entrada = lerEntrada(mensagem: mensagem)
    return entrada.isEmpty ? nil : entrada
}

/// Solicita um número inteiro opcional. Retorna nil se o usuário apenas pressionar Enter ou se for inválido.
func lerInteiroOpcional(mensagem: String) -> Int? {
    let entrada = lerEntrada(mensagem: mensagem)
    if entrada.isEmpty {
        return nil
    }
    guard let valor = Int(entrada) else {
        print("⚠️  Valor não reconhecido como número. O campo não será alterado.")
        return nil
    }
    return valor
}

// MARK: - Ações do Menu

func cadastrarLivro(na biblioteca: Biblioteca) {
    print("\n--- 📖 CADASTRO DE NOVO LIVRO ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro (número inteiro): ")
    
    // Validação de unicidade de ID
    if biblioteca.existeLivro(comId: id) {
        print("❌ Erro: Já existe um livro cadastrado com o ID \(id)!")
        return
    }
    
    let titulo = lerTextoObrigatorio(mensagem: "Digite o título do livro: ")
    let autor = lerTextoObrigatorio(mensagem: "Digite o autor do livro: ")
    let anoPublicacao = lerInteiroObrigatorio(mensagem: "Digite o ano de publicação: ")
    
    let novoLivro = Livro(id: id, titulo: titulo, autor: autor, anoPublicacao: anoPublicacao)
    if biblioteca.cadastrar(livro: novoLivro) {
        print("\n✅ Livro \"\(novoLivro.titulo)\" cadastrado com sucesso!")
    } else {
        print("\n❌ Erro ao cadastrar livro.")
    }
}

func buscarLivroPorId(na biblioteca: Biblioteca) {
    print("\n--- 🔍 BUSCA POR ID ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro: ")
    if let livro = biblioteca.buscar(porId: id) {
        print("\n✅ Livro encontrado:")
        livro.exibirDetalhes()
    } else {
        print("⚠️  Nenhum livro encontrado com o ID \(id).")
    }
}

func buscarLivroPorTitulo(na biblioteca: Biblioteca) {
    print("\n--- 🔍 BUSCA POR TÍTULO ---")
    let termo = lerTextoObrigatorio(mensagem: "Digite o termo para busca no título: ")
    let resultados = biblioteca.buscar(porTitulo: termo)
    
    if resultados.isEmpty {
        print("⚠️  Nenhum livro encontrado com o termo \"\(termo)\".")
    } else {
        print("\n✅ Encontrado(s) \(resultados.count) livro(s):")
        for livro in resultados {
            livro.exibirDetalhes()
        }
    }
}

func atualizarLivro(na biblioteca: Biblioteca) {
    print("\n--- ✏️  ATUALIZAR LIVRO ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro que deseja atualizar: ")
    
    guard let livro = biblioteca.buscar(porId: id) else {
        print("⚠️  Nenhum livro encontrado com o ID \(id).")
        return
    }
    
    print("\nDados atuais do livro:")
    livro.exibirDetalhes()
    print("ℹ️  Dica: Pressione [Enter] para manter o valor atual de cada campo.\n")
    
    let novoTitulo = lerTextoOpcional(mensagem: "Novo título (atual: \(livro.titulo)): ")
    let novoAutor = lerTextoOpcional(mensagem: "Novo autor (atual: \(livro.autor)): ")
    let novoAno = lerInteiroOpcional(mensagem: "Novo ano de publicação (atual: \(livro.anoPublicacao)): ")
    
    livro.atualizar(titulo: novoTitulo, autor: novoAutor, anoPublicacao: novoAno)
    
    print("\nDeseja alterar o status de empréstimo?")
    print("1. Marcar como Emprestado")
    print("2. Marcar como Devolvido/Disponível")
    print("3. Manter status atual")
    let opcaoStatus = lerEntrada(mensagem: "Opção: ")
    
    switch opcaoStatus {
    case "1":
        if livro.emprestar() {
            print("📗 Status alterado para: Emprestado.")
        } else {
            print("ℹ️  O livro já estava emprestado.")
        }
    case "2":
        if livro.devolver() {
            print("📗 Status alterado para: Disponível.")
        } else {
            print("ℹ️  O livro já estava disponível.")
        }
    default:
        print("ℹ️  Status de empréstimo mantido.")
    }
    
    print("\n✅ Informações do livro atualizadas com sucesso!")
}

func emprestarLivro(na biblioteca: Biblioteca) {
    print("\n--- 📤 EMPRÉSTIMO DE LIVRO ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro para empréstimo: ")
    
    guard let livro = biblioteca.buscar(porId: id) else {
        print("⚠️  Nenhum livro encontrado com o ID \(id).")
        return
    }
    
    if livro.emprestar() {
        print("✅ Empréstimo realizado com sucesso! Livro: \"\(livro.titulo)\".")
    } else {
        print("⚠️  O livro \"\(livro.titulo)\" já se encontra emprestado!")
    }
}

func devolverLivro(na biblioteca: Biblioteca) {
    print("\n--- 📥 DEVOLUÇÃO DE LIVRO ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro para devolução: ")
    
    guard let livro = biblioteca.buscar(porId: id) else {
        print("⚠️  Nenhum livro encontrado com o ID \(id).")
        return
    }
    
    if livro.devolver() {
        print("✅ Devolução concluída com sucesso! Livro: \"\(livro.titulo)\" está disponível.")
    } else {
        print("⚠️  O livro \"\(livro.titulo)\" já estava disponível na biblioteca (não constava como emprestado).")
    }
}

func removerLivro(na biblioteca: Biblioteca) {
    print("\n--- 🗑️  REMOÇÃO DE LIVRO ---")
    let id = lerInteiroObrigatorio(mensagem: "Digite o ID do livro a ser removido: ")
    
    guard let livro = biblioteca.buscar(porId: id) else {
        print("⚠️  Nenhum livro encontrado com o ID \(id).")
        return
    }
    
    livro.exibirDetalhes()
    let confirmacao = lerEntrada(mensagem: "Tem certeza que deseja excluir este livro? (S/N): ").uppercased()
    
    if confirmacao == "S" || confirmacao == "SIM" {
        if biblioteca.remover(porId: id) {
            print("✅ Livro removido com sucesso!")
        } else {
            print("❌ Falha ao remover o livro.")
        }
    } else {
        print("ℹ️  Remoção cancelada.")
    }
}

// MARK: - Função Principal (Execução do Programa)

func main() {
    let biblioteca = Biblioteca()
    
    // Dados de exemplo para facilitar o teste inicial
    biblioteca.cadastrar(livro: Livro(id: 1, titulo: "Dom Casmurro", autor: "Machado de Assis", anoPublicacao: 1899))
    biblioteca.cadastrar(livro: Livro(id: 2, titulo: "O Alquimista", autor: "Paulo Coelho", anoPublicacao: 1988))
    
    var emExecucao = true
    
    while emExecucao {
        print("""
        
        ==================================================
              📚 SISTEMA DE GERENCIAMENTO DE LIVROS
        ==================================================
        1. Cadastrar Livro
        2. Listar Todos os Livros
        3. Buscar Livro por ID
        4. Buscar Livro por Título
        5. Atualizar Dados do Livro
        6. Emprestar Livro
        7. Devolver Livro
        8. Remover Livro
        0. Sair do Sistema
        ==================================================
        """)
        
        let opcao = lerEntrada(mensagem: "Escolha uma opção: ")
        
        switch opcao {
        case "1":
            cadastrarLivro(na: biblioteca)
        case "2":
            biblioteca.listarTodos()
        case "3":
            buscarLivroPorId(na: biblioteca)
        case "4":
            buscarLivroPorTitulo(na: biblioteca)
        case "5":
            atualizarLivro(na: biblioteca)
        case "6":
            emprestarLivro(na: biblioteca)
        case "7":
            devolverLivro(na: biblioteca)
        case "8":
            removerLivro(na: biblioteca)
        case "0":
            print("\n👋 Encerrando o sistema. Até logo!")
            emExecucao = false
        default:
            print("❌ Opção inválida! Escolha um número entre 0 e 8.")
        }
    }
}

// Inicia o programa
main()
