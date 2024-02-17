//
//  ViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/12/24.
//

import UIKit
import MaterialTextField

class ViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var txtFldEmail: MFTextField!
    @IBOutlet weak var txtFldPassword: MFTextField!
    @IBOutlet weak var viewBg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func initialSetup() {
        self.view.backgroundColor = Colors.shared.primaryDark
        self.viewBg.backgroundColor = Colors.shared.background
        self.viewBg.dropShadow()
        Utils.shared.cornerRadius(view: self.imgLogo, radius: 10)
        
        self.registerBtn.addTarget(self, action: #selector(openDashboard(_:)), for: .touchUpInside)
        
        viewBg.layer.borderWidth = 1.0
        viewBg.layer.borderColor = Colors.shared.borderColor.cgColor
        Utils.shared.cornerRadius(view: viewBg, radius: 20)
        
        registerBtn.backgroundColor = Colors.shared.primaryLight
        registerBtn.setTitleColor(.white, for: .normal)
        Utils.shared.cornerRadius(view: registerBtn)
        
        Utils.shared.setupTextField(textfield: txtFldEmail, placeholder: "Email")
        Utils.shared.setupTextField(textfield: txtFldPassword, placeholder: "Password")
    }
    
    @objc func openDashboard(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "AdminDBViewController") as! AdminDBViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }

}

