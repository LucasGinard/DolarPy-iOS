//
//  HomeView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State var amountInput: String = ""
    @FocusState var isInputActive: Bool
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding()
            TextField("Monto", text: $amountInput)
                .keyboardType(.numberPad)
                .textFieldStyle(CustomTextFieldStyleWithBorder(isEditing: isInputActive, lineWidth: 2, activeColor: Color(Colors.green_46B6AC), inactiveColor: .gray)).padding()
                .focused($isInputActive)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Cerrar") {
                            isInputActive = false
                        }.padding([.trailing])
                    }
                }
            HStack {
                Spacer()
                HStack(){
                    Text(self.viewModel.selectedOption ?? "Compra")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .background(Color(Colors.green_46B6AC))
                        .cornerRadius(16)
                        .contextMenu {
                            Button(action: {
                                self.viewModel.selectedOption = "Compra"
                                self.viewModel.isOrderBy = .buy
                                self.viewModel.orderQuotations()
                            }) {
                                Text("Compra")
                            }
                            Button(action: {
                                self.viewModel.selectedOption = "Venta"
                                self.viewModel.isOrderBy = .sell
                                self.viewModel.orderQuotations()
                            }) {
                                Text("Venta")
                            }
                        }
                }

                Button(action: {
                    withAnimation {
                        self.viewModel.arrowOrientation = self.viewModel.arrowOrientation == .zero ? .degrees(180) : .zero
                        self.viewModel.orderQuotations()
                    }
                }) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(Color(Colors.green_46B6AC))
                        .rotationEffect(self.viewModel.arrowOrientation)
                }.padding(.trailing,18)
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
    
    func QuotationsRowsView()-> some View{
        let columns = [
            GridItem(.fixed(160)),
            GridItem(.flexible()),
        ]
        return ScrollView {
            if viewModel.isLoading {
                ProgressView()
            }else{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.quotations.indices, id: \.self) { position in
                        let ref = self.calculateQuotation(amount: viewModel.quotations[position].referencial_diario) ?? nil
                        let buy = self.calculateQuotation(amount: viewModel.quotations[position].compra)!
                        let sell = self.calculateQuotation(amount: viewModel.quotations[position].venta)!
                        let text1 = "Compra"
                        let text2 = "\(buy)"
                            let font = Font.system(size: 16, weight: .regular)
                        
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
                                    Text("Venta: ")
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
                                if let name = viewModel.quotations[position].name {
                                    Text(name).foregroundColor(Color(Colors.green_46B6AC))
                                        .frame(maxWidth: .infinity,alignment: .leading).padding(8)
                                }
                            }.background(Color.white)
                        }.frame(width: 150,height: 160)
                            .background(Rectangle().fill(Color(Colors.green_46B6AC)).shadow(radius: 8))
                    }
                }
                .padding(.horizontal)
                Text("Actualizado: \(viewModel.lastUpdate)").padding()
            }
        }.task {
            await self.viewModel.getListQuotationService()
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

