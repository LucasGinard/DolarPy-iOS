//
//  QuotationRowView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct QuotationRowView: View {
    var quotation:QuotationModel
    @State var buy:Double
    @State var sell:Double
    @State var ref:Double?
    
    var body: some View {
        
        VStack(alignment: .leading){
            VStack{
                if ref == nil{
                    Spacer()
                }
                
                HStack{
                    Text("Compra:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(buy.formatDecimal()))
                        .foregroundColor(.white)
                }.padding(8)
                
                if ref == nil{
                    Spacer()
                }
                
                HStack{
                    Text("Venta:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(self.printtest().formatDecimal()))
                        .foregroundColor(.white)
                }.padding(8)
                
                if ref == nil{
                    Spacer()
                }
                
                if let refDaily = ref {
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
    
    func printtest()-> Double{
        print("imprime venta -> \(sell)")
        
        return sell
    }
}

struct QuotationRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuotationRowView(quotation: QuotationModel(name: "Cambios dolar", compra: 5500, venta: 600, ref: nil),buy: 5500,sell: 5000,ref: nil)
    }
}
