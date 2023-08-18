//
//  CustomTextFieldStyle.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-03-11.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyleWithBorder: TextFieldStyle {
    var isEditing: Bool
    var lineWidth: CGFloat = 2
    var activeColor: Color = Color(Colors.green_46B6AC)
    var inactiveColor: Color = .gray
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.clear)
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEditing ? activeColor : inactiveColor, lineWidth: lineWidth)
            )
            .accentColor(Color(Colors.green_46B6AC))
    }
}
