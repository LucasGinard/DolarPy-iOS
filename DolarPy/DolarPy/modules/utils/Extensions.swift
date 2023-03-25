//
//  Extensions.swift
//  DolarPy
//
//  Created by MacBook Pro on 2023-01-22.
//

import Foundation
import UIKit

extension Double{
    
    func formatDecimal() -> String{
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.currencyCode = "PYG"
        formatter.numberStyle = .decimal
        let input = formatter.string(for: self) ?? "?"
        return input.replacingOccurrences(of: ",", with: ".")
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension String{
    func getWidthOfString(_ text: String, font: UIFont) -> CGFloat {
           let fontAttributes = [NSAttributedString.Key.font: font]
           let size = (text as NSString).size(withAttributes: fontAttributes)
           return size.width
       }
}
