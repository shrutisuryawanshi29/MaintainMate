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

extension UIView {
    func dropShadow(scale: Bool = true, shadowOpacity: Float = 0.1, shadowRadius: Float = 6) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
