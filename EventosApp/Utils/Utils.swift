//
//  File.swift
//  EventosApp
//
//  Created by Lucas Santiago on 25/04/21.
//

import UIKit

class Utils {
    
    static func buildCornedButton(title: String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        btn.layer.cornerRadius = 25
        return btn
    }
    
    static func formatDoubleString(_ price: Double) -> String{
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = "."
            numberFormatter.groupingSize = 3
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.decimalSeparator = ","
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter.string(from: price as NSNumber)!
        }
}
