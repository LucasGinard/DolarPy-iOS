//
//  HomeView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct HomeView: View {
    @State private var quotations = Array<QuotationModel>()
    @State var amountInput: String = ""
    @State var lastUpdate: String = ""
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding()
            TextField("Monto", text: $amountInput)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder).padding()
                .focused($isInputActive)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Cerrar") {
                            isInputActive = false
                        }.padding([.trailing])
                    }
                }
            self.QuotationsRowsView()
        }
        .padding()
        
    }
    
    func calculateQuotation(amount:Double?)-> Double?{
        if amount == nil{
            return nil
        }

        return (Double(amountInput) ?? 1) * amount!
    }
    
    func getListQuotationService() async{
        do{
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://dolar.melizeche.com/api/1.0/")!)

            let decodedResponse = try? JSONDecoder().decode(QuotationResponse.self, from: data)
            decodedResponse?.loadNamesQuotation()
            lastUpdate = decodedResponse?.updated ?? ""
            decodedResponse?.dolarpy.values.forEach{
                self.quotations.append($0)
            }
            
        }catch {
            print("Error service")
        }
    }
    
    func QuotationsRowsView()-> some View{
        let columns = [
            GridItem(.fixed(160)),
            GridItem(.flexible()),
        ]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(quotations.indices, id: \.self) { position in
                    let ref = self.calculateQuotation(amount: quotations[position].referencial_diario) ?? nil
                    let buy = self.calculateQuotation(amount: quotations[position].compra)!
                    let sell = self.calculateQuotation(amount: quotations[position].venta)!
                    
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
                                Text(String(sell.formatDecimal()))
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
                            if let name = quotations[position].name {
                                Text(name).foregroundColor(Color(Colors.green_46B6AC))
                                    .frame(maxWidth: .infinity,alignment: .leading).padding(8)
                            }
                        }.background(Color.white)
                    }.frame(width: 160,height: 170)
                        .background(Rectangle().fill(Color(Colors.green_46B6AC)).shadow(radius: 8))
                }
            }
            .padding(.horizontal)
            .task {
                await self.getListQuotationService()
            }
            Text("Actualizado: \(lastUpdate)").padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
