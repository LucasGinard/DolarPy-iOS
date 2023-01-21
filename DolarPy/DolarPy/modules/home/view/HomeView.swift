//
//  HomeView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct HomeView: View {
    @State private var joke: String = ""

    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding().padding()
            Button {
                        Task {
                            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://dolar.melizeche.com/api/1.0/")!)

                            let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
                        }
                    } label: {
                        Text("Fetch Joke")
                    }
            let data = (1...100).map { "Item \($0)" }

                let columns = [
                    GridItem(.fixed(160)),
                    GridItem(.flexible()),
                ]

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(data, id: \.self) { item in
                        QuotationRowView()
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

struct Joke: Codable {
    let dolarpy: [String: Item]
}
struct Item: Codable {
    let compra: Double
    let venta: Double
}
