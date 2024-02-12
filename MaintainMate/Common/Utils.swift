//
//  Utils.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/2/24.
//

import UIKit

class Utils {
    static let shared = Utils()
    
    func cornerRadius(view: UIView, radius: CGFloat = 5) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
}


