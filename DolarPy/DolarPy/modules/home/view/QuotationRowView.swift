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
                if quotation.referencial_diario == nil{
                    Spacer()
                }
                
                HStack{
                    Text("Compra:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(quotation.compra.formatDecimal()))
                        .foregroundColor(.white)
                }.padding(8)
                
                if quotation.referencial_diario == nil{
                    Spacer()
                }
                
                HStack{
                    Text("Venta:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(quotation.venta.formatDecimal()))
                        .foregroundColor(.white)
                }.padding(8)
                
                if quotation.referencial_diario == nil{
                    Spacer()
                }
                
                if let refDaily = quotation.referencial_diario {
                    HStack{
                        Text("Ref Día:")
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(refDaily)
                        )
                        .foregroundColor(.white)
                    }.padding(8)
                }
            }
            VStack{
                if let name = quotation.name {
                    Text(name).foregroundColor(Color(Colors.green_46B6AC))
                        .frame(maxWidth: .infinity,alignment: .leading).padding(8)
                }
            }.background(Color.white)
        }.frame(width: 160,height: 170)
            .background(Rectangle().fill(Color(Colors.green_46B6AC)).shadow(radius: 8))

    }
}

struct QuotationRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuotationRowView(quotation: QuotationModel(name: "Cambios dolar", compra: 5500, venta: 600, ref: nil))
    }
}
