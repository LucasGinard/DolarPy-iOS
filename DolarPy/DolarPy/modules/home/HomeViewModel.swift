//
//  HomeViewModel.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-04-06.
//

import Foundation

class HomeViewModel:ObservableObject {
    
    @Published var quotations = Array<QuotationModel>()
    @Published var lastUpdate: String = ""
    @Published var isLoading = true

    func getListQuotationService() async{
        do{
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://dolar.melizeche.com/api/1.0/")!)

            let decodedResponse = try? JSONDecoder().decode(QuotationResponse.self, from: data)
            decodedResponse?.loadNamesQuotation()
            lastUpdate = decodedResponse?.updated ?? ""
            decodedResponse?.dolarpy.values.forEach{
                self.quotations.append($0)
            }
            isLoading = false
        }catch {
            isLoading = false
            print("Error service")
        }
    }
    
    
}
