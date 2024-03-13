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
    
    func getCurrentDate() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatterGet.string(from: Date())
    }
    
    func convertDateToString() {
        let timestamp: TimeInterval = Date().timeIntervalSince1970

        let date = Date(timeIntervalSince1970: timestamp)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // for example, "2024-02-18 15:00:00"

        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") 

        let dateString = dateFormatter.string(from: date)
    }
    
    func showError(title: String = "Error!", message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func generateRandomIssueID(digits: Int = 5) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return "MM"+number+"\(Date().timeIntervalSince1970)".prefix(10)
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
