//
//  QuotationRowView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct QuotationRowView: View {
    var quotation:QuotationModel
    
    var body: some View {
        VStack(alignment: .leading){
            VStack{
                HStack{
                    Text("Compra:")
                    Spacer()
                    Text(String(quotation.compra))
                }.padding(8)
                HStack{
                    Text("Venta:")
                    Spacer()
                    Text(String(quotation.venta))
                }.padding(8)
                if let refDaily = quotation.referencial_diario {
                    HStack{
                        Text("Ref Día:")
                        Spacer()
                        Text(String(refDaily))
                    }.padding(8)
                }
            }
            if let name = quotation.name {
                Text(name).foregroundColor(.green)
                    .background(Color.white)
            }
        }.background(Color.green)
            .frame(width: 160)
    }
}

struct QuotationRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuotationRowView(quotation: QuotationModel(name: "Cambios dolar", compra: 5500, venta: 600, ref: 1000))
    }
}
