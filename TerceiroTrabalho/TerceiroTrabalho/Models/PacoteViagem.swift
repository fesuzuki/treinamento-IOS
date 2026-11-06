//
//  PacoteViagem.swift
//  TerceiroTrabalho
//
//  Created by Cruz, Felipe Suzuki da on 05/11/26.
//

import Foundation

struct PacoteViagem : Identifiable , Hashable {
    var id : UUID = UUID()
    var titulo : String
    var local : String
    var diarias : Int
    var dataPartida : String
    var dataChegada : String
    var detalheHospedagem : String
    var imagem : String
    var preco : Double

}
    
extension Double{
    var emReais : String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "BRL"
        return formatter.string(from: NSNumber(value: self)) ?? "R$ \(self)"
    }
}
    
