//
//  ViagemViewModel.swift
//  TerceiroTrabalho
//
//  Created by Cruz, Felipe Suzuki da on 05/11/26.
//
import SwiftUI


@Observable
class ViagemViewModel{
    var pacotes : [PacoteViagem] = []
    var favoritos : Set<UUID> = []
    
    
    
    init(){
        carregarDados()
    }
    
    
    var pacotesFavoritos : [PacoteViagem]{
        pacotes.filter{ favoritos.contains($0.id) }
    }
    
    var quantidadeFavoritos : Int{
        pacotesFavoritos.count
    }
    
    func isFavorito(_ pacote: PacoteViagem) -> Bool{
        return  favoritos.contains(pacote.id)
    }
    
    
    func toggleFavorito(_ pacote: PacoteViagem){
        if isFavorito(pacote){
            favoritos.remove(pacote.id)
        }else{
            favoritos.insert(pacote.id)
        }
    }
 
    private func carregarDados(){
        self.pacotes = [
             PacoteViagem(titulo: "Bombinhas Inesquecivel", local: "Santa Catarina", diarias: 5, dataPartida: "01/12/2024", dataChegada: "06/12/2024", detalheHospedagem: "Hotel Pousada", imagem: "bombinhas", preco: 1500.0),
             PacoteViagem(titulo: "Santiago Romantico", local: "Chile", diarias: 7, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel Santiago", imagem: "chile", preco: 2000.0),
             PacoteViagem(titulo: "Paris para dois", local: "França", diarias: 14, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel 5 Estrelas", imagem: "franca", preco: 3000.0),
             PacoteViagem(titulo: "Milão Historica", local: "Italia", diarias: 10, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel 5 Estrelas", imagem: "milao", preco: 2500.0),
             PacoteViagem(titulo: "Madrid Incrivel", local: "Espanha", diarias: 7, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel 5 Estrelas", imagem: "madrid", preco: 4000.0),
             PacoteViagem(titulo: "Bahia Incrivel", local: "Brasil", diarias: 5, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel 5 Estrelas", imagem: "bahia", preco: 1800.0),
             PacoteViagem(titulo: "Japão Medieval", local: "Japão", diarias: 7, dataPartida: "10/12/2024", dataChegada: "17/12/2024", detalheHospedagem: "Hotel Resort", imagem: "japao", preco: 3500.0),
        ]
    }
    
}
