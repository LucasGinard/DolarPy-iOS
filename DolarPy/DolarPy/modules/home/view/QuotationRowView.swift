//
//  QuotationRowView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct QuotationRowView: View {
    var body: some View {
        VStack(alignment: .leading){
            VStack{
                HStack{
                    Text("Compra")
                    Spacer()
                    Text("51000")
                }.padding(8)
                HStack{
                    Text("Venta")
                    Spacer()
                    Text("51000")
                }.padding(8)
            }
            Text("cambios chaquito").foregroundColor(.green)
                .background(Color.white)
        }.background(Color.green)
            .frame(width: 160)
    }
}

struct QuotationRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuotationRowView()
    }
}
