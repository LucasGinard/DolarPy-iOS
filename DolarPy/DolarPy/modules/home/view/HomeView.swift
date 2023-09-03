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
    
    @State private var isCompraSelected: Bool = true

    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸")
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
                .onChange(of: amountInput) { newValue in
                    if newValue.count > 5 {
                        amountInput = String(newValue.prefix(5))
                    }
                }
            HStack {
                Spacer()
                HStack(spacing: 0) {
                            Button(action: {
                                self.viewModel.selectedOption = "Compra"
                                self.viewModel.isOrderBy = .buy
                                self.viewModel.orderQuotations()
                                self.isCompraSelected = true
                            }) {
                                Text("Compra")
                                    .font(.headline)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isCompraSelected ? Color(Colors.green_46B6AC) : Color.gray)
                                    )
                            }

                            Button(action: {
                                self.viewModel.selectedOption = "Venta"
                                self.viewModel.isOrderBy = .sell
                                self.viewModel.orderQuotations()
                                self.isCompraSelected = false
                            }) {
                                Text("Venta")
                                    .font(.headline)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .foregroundColor(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(!isCompraSelected ? Color(Colors.green_46B6AC) : Color.gray)
                                    )
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(Colors.green_46B6AC))
                        )
                
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
                        let ref = self.viewModel.calculateQuotation(amount: viewModel.quotations[position].referencial_diario,amountInput: amountInput) ?? nil
                        let buy = self.viewModel.calculateQuotation(amount: viewModel.quotations[position].compra,amountInput: amountInput)!
                        let sell = self.viewModel.calculateQuotation(amount: viewModel.quotations[position].venta,amountInput: amountInput)!
                        
                        VStack(alignment: .leading){
                            VStack{
                                if ref == nil{
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Compra:")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 14, weight: .regular))
                                        .lineLimit(1)
                                    Spacer()
                                    Text(String(buy.formatDecimal()))
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 16, weight: .bold))
                                        .lineLimit(1)
                                }
                                .minimumScaleFactor(0.1)
                                .padding(8)
                                
                                if ref == nil{
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Venta: ")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 14, weight: .regular))
                                        .lineLimit(1)
                                    Spacer()
                                    Text(String(sell.formatDecimal()))
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 16, weight: .bold))
                                        .lineLimit(1)
                                }
                                .padding(8)
                                .minimumScaleFactor(0.1)
                                
                                if ref == nil{
                                    Spacer()
                                }
                                
                                if let refDaily = ref {
                                    HStack{
                                        Text("Ref Día:")
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 14, weight: .regular))
                                        Spacer()
                                        Text(refDaily.formatDecimal())
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 16, weight: .bold))
                                            .lineLimit(1)
                                    }
                                    .padding(8)
                                    .minimumScaleFactor(0.1)
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
        }
        .task {
            await self.viewModel.getListQuotationService()
        }
        .refreshable {
            await self.viewModel.getListQuotationService()
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

