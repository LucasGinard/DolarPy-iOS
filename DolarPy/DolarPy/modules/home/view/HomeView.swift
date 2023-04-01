//
//  HomeView.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-20.
//

import SwiftUI

struct HomeView: View {
    @State private var quotations = Array<QuotationModel>()
    @State var lastUpdate: String = ""
    
    @State var amountInput: String = ""
    @FocusState var isInputActive: Bool
    @State private var isEditing = false
    @State private var isLoading = true
    @State var arrowOrientation: Angle = .zero
    @State var selectedOption: String? = nil


    var body: some View {
        VStack(alignment: .center) {
            Text("💸 DolarPy 💸").padding()
            TextField("Monto", text: $amountInput)
                .keyboardType(.numberPad)
                .textFieldStyle(CustomTextFieldStyleWithBorder(isEditing: isInputActive, lineWidth: 2, activeColor: .green, inactiveColor: .gray)).padding()
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
                    Text(selectedOption ?? "Compra")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .background(Color(Colors.green_46B6AC))
                        .cornerRadius(16)
                        .contextMenu {
                            Button(action: {
                                selectedOption = "Compra"
                            }) {
                                Text("Compra")
                            }
                            Button(action: {
                                selectedOption = "Venta"
                            }) {
                                Text("Venta")
                            }
                        }
                }

                Button(action: {
                    withAnimation {
                        arrowOrientation += .degrees(180)
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(Color(Colors.green_46B6AC))
                        .rotationEffect(arrowOrientation)
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
            if isLoading {
                ProgressView()
            }else{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(quotations.indices, id: \.self) { position in
                        let ref = self.calculateQuotation(amount: quotations[position].referencial_diario) ?? nil
                        let buy = self.calculateQuotation(amount: quotations[position].compra)!
                        let sell = self.calculateQuotation(amount: quotations[position].venta)!
                        let text1 = "Compra"
                        let text2 = "\(buy)"
                            let font = Font.system(size: 16, weight: .regular)
                        
                        VStack(alignment: .leading){
                            GeometryReader { geometry in
                                let availableWidth = geometry.size.width
                                let textSize1 = getTextSize(for: text1, with: font, bold: false) ?? .zero
                                let textSize2 = getTextSize(for: text2, with: font, bold: false) ?? .zero
                                
                                Group {
                                    if textSize1.width + textSize2.width > availableWidth {
                                        returnViewH(buy: buy, sell: sell, ref: ref)

                                    } else {
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

                                    }
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
                Text("Actualizado: \(lastUpdate)").padding()
            }
        }.task {
            await self.getListQuotationService()
        }
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
            isLoading = false
        }catch {
            isLoading = false
            print("Error service")
        }
    }
    
    
    func getTextSize(for text: String, with font: Font, bold: Bool) -> CGSize? {
        let uiFont = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: bold ? .bold : .regular)
            let attributedString = NSAttributedString(string: text, attributes: [.font: uiFont])
            return attributedString.size()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct returnViewH: View{
    var buy:Double,sell:Double,ref:Double?
    var body: some View {
        VStack{
            VStack{
                Text("Compra:")
                    .foregroundColor(.white)
                Spacer()
                Text(String(buy.formatDecimal()))
                    .foregroundColor(.white)
            }.padding(8)
            
            VStack{
                Text("Venta: ")
                    .foregroundColor(.white)
                Spacer()
                Text(String(sell.formatDecimal()))
                    .foregroundColor(.white)
            }.padding(8)
            
            if let refDaily = ref {
                VStack{
                    Text("Ref Día:")
                        .foregroundColor(.white)
                    Text(String(refDaily)
                    )
                    .foregroundColor(.white)
                }.padding(8)
            }
        }

    }
    
}


