//
//  HomeViewModel.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-04-06.
//

import Foundation
import SwiftUI

class HomeViewModel:ObservableObject {
    
    @Published var quotations = Array<QuotationModel>()
    @Published var lastUpdate: String = ""
    @Published var isLoading = true
    @Published var isOrderBy:OrderQuotation = .buy
    
    @Published var arrowOrientation:Angle = .zero
    @Published var selectedOption: String? = nil

    func getListQuotationService() async{
        do{
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://dolar.melizeche.com/api/1.0/")!)

            let decodedResponse = try? JSONDecoder().decode(QuotationResponse.self, from: data)
            decodedResponse?.loadNamesQuotation()
            
            DispatchQueue.main.async {
                self.quotations.removeAll()
                self.lastUpdate = decodedResponse?.updated ?? ""
                decodedResponse?.dolarpy.values.forEach {
                    if $0.compra > 0 && $0.venta > 0 {
                        self.quotations.append($0)
                    }
                }
                self.quotations = self.quotations.sortedDescending(by: .buy)
                self.isLoading = false
            }
            
        }catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            print("Error service")
        }
    }
    
    func orderQuotations(){
        orderQuotation(isDescending: arrowOrientation == .zero ? true : false, orderBy: isOrderBy)
    }
    
    private func orderQuotation(isDescending:Bool,orderBy:OrderQuotation){
        self.quotations = isDescending ? self.quotations.sortedDescending(by: orderBy) : self.quotations.sorted(by: orderBy)
    }
    
    func calculateQuotation(amount:Double?,amountInput:String)-> Double?{
        if amount == nil{
            return nil
        }
        return (Double(amountInput) ?? 1) * amount!
    }
    
}
