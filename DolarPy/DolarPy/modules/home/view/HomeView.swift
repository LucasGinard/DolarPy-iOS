//
//  HomeView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct HomeView: View {
    @State private var quotations = Array<QuotationModel>()

    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding().padding()
            Button {
                        Task {
                            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://dolar.melizeche.com/api/1.0/")!)

                            let decodedResponse = try? JSONDecoder().decode(QuotationResponse.self, from: data)
                            decodedResponse?.loadNamesQuotation()
                            print("response return -> \(decodedResponse?.dolarpy)")
                            decodedResponse?.dolarpy.values.forEach{
                                self.quotations.append($0)
                            }
                        }
                    } label: {
                        Text("Fetch Joke")
                    }
            
                let columns = [
                    GridItem(.fixed(160)),
                    GridItem(.flexible()),
                ]

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(quotations.indices, id: \.self) { item in
                        QuotationRowView(quotation: self.quotations[item])
                    }
                }
                .padding(.horizontal)
            }
            
            
        }
        .padding()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
