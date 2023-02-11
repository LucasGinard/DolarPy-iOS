//
//  QuotationModel.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-21.
//

import Foundation

struct QuotationResponse: Codable {
    var dolarpy: [String: QuotationModel]
    let updated: String
    
    func loadNamesQuotation(){
        for x in self.dolarpy.indices{
            self.dolarpy[x].value.name = self.dolarpy[x].key
        }
    }
}

class QuotationModel: Codable {
    var name: String?
    var compra: Double
    var venta: Double
    var referencial_diario: Double?
    
    init(name:String,compra:Double,venta:Double,ref:Double?){
        self.name = name
        self.compra = compra
        self.venta = venta
        self.referencial_diario = ref
    }
}
