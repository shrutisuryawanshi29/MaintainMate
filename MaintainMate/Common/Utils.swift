//
//  Utils.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/2/24.
//

import UIKit
import MaterialTextField

class Utils {
    static let shared = Utils()
    
    func cornerRadius(view: UIView, radius: CGFloat = 5) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    
    func setupTextField(textfield: MFTextField, placeholder: String="") {
        textfield.placeholderColor = Colors.shared.primaryDark
        textfield.tintColor = Colors.shared.primaryDark
        textfield.textColor = .black
        textfield.placeholderAnimatesOnFocus = true
        textfield.placeholder = placeholder
        textfield.defaultPlaceholderColor = .gray
    }
}


