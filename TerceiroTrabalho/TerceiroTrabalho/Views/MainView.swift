//
//  Opcao1DetalhesView.swift
//  TerceiroTrabalho
//
//  Created by Cruz, Felipe Suzuki da on 05/11/26.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = ViagemViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.pacotes) { pacote in
                        NavigationLink(value: pacote) {
                            CardPacote(pacote: pacote, viewModel: viewModel)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Explorar Viagens")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        FavoritosView(viewModel: viewModel)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("\(viewModel.quantidadeFavoritos)")
                                .font(.subheadline)
                                .bold()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
            .navigationDestination(for: PacoteViagem.self) { pacote in
                DetalhesView(pacote: pacote, viewModel: viewModel)
            }
        }
    }
}

// Card 
struct CardPacote: View {
    let pacote: PacoteViagem
    var viewModel: ViagemViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(pacote.imagem)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                HStack {
                    Text("\(pacote.diarias) diárias")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button {
                        viewModel.toggleFavorito(pacote)
                    } label: {
                        Image(systemName: viewModel.isFavorito(pacote) ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorito(pacote) ? .red : .gray)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pacote.titulo)
                    .font(.headline)
                
                Text(pacote.local)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(pacote.preco.emReais)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// Detalhes do Pacote
struct DetalhesView: View {
    let pacote: PacoteViagem
    var viewModel: ViagemViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(pacote.imagem)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(pacote.titulo)
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            viewModel.toggleFavorito(pacote)
                        } label: {
                            Image(systemName: viewModel.isFavorito(pacote) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(viewModel.isFavorito(pacote) ? .red : .gray)
                        }
                    }
                    
                    Label(pacote.local, systemImage: "mappin.and.ellipse")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Label("Duração: \(pacote.diarias) diárias", systemImage: "clock")
                    Label("Partida: \(pacote.dataPartida)", systemImage: "calendar")
                    Label("Retorno: \(pacote.dataChegada)", systemImage: "calendar.badge.clock")
                    Label("Hospedagem: \(pacote.detalheHospedagem)", systemImage: "bed.double.fill")
                }
                .font(.body)
                
                Spacer(minLength: 30)
                
                Button(action: {}) {
                    Text("Reservar por \(pacote.preco.emReais)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Favoritos
struct FavoritosView: View {
    var viewModel: ViagemViewModel
    
    var body: some View {
        Group {
            if viewModel.pacotesFavoritos.isEmpty {
                ContentUnavailableView(
                    "Nenhum Favorito",
                    systemImage: "heart.slash",
                    description: Text("Você ainda não adicionou nenhum pacote à sua lista de favoritos.")
                )
            } else {
                List(viewModel.pacotesFavoritos) { pacote in
                    NavigationLink(value: pacote) {
                        HStack(spacing: 12) {
                            Image( pacote.imagem)
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pacote.titulo)
                                    .font(.headline)
                                Text(pacote.preco.emReais)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Meus Favoritos")
    }
}


#Preview {
    MainView()
}

