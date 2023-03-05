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
    
    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding()
            TextField("Monto", text: $amountInput)
                .onChange(of: amountInput) { newValue in
                    
                }
                .textFieldStyle(.roundedBorder).padding()
            
            let columns = [
                GridItem(.fixed(160)),
                GridItem(.flexible()),
            ]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(quotations.indices, id: \.self) { item in
                        let ref = self.calculateQuotation(amount: quotations[item].referencial_diario) ?? nil
                        QuotationRowView(quotation: quotations[item], buy: self.calculateQuotation(amount: quotations[item].compra)!,sell: self.calculateQuotation(amount: quotations[item].venta)!,ref: ref)
                    }
                }
                .padding(.horizontal)
                .task {
                    await self.getListQuotationService()
                }
                Text("Actualizado: \(lastUpdate)").padding()
            }
        }
        .padding()
        
    }
    
    func calculateQuotation(amount:Double?)-> Double?{
        if amount == nil{
            return nil
        }
        print(" se refresca venta -> \((Double(amountInput) ?? 1) * amount!)")

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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
