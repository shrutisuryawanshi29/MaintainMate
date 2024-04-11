//
//  ViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/12/24.
//

import UIKit
import MaterialTextField
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var txtFldEmail: MFTextField!
    @IBOutlet weak var txtFldPassword: MFTextField!
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        if let userExists = UserDefaults.standard.object(forKey: "FIRUser") as? Data {
            if Auth.auth().currentUser!.uid.localizedCaseInsensitiveCompare("6rXRM0C4nAYxP66deoXCI995GbA2") == .orderedSame {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utils.shared.isAdmin = true
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "AdminDBViewController") as! AdminDBViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utils.shared.isAdmin = false
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
                }
            }
        }
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
        Utils.shared.cornerRadius(view: registerBtn)
        
        Utils.shared.setupTextField(textfield: txtFldEmail, placeholder: "Email")
        Utils.shared.setupTextField(textfield: txtFldPassword, placeholder: "Password")
    }
    
    @objc func openDashboard(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                
                
                if error != nil {
                    return
                }
                
                var user = FIRUser()
                user.email = result?.user.email
                user.name = result?.user.displayName
                user.uid = result?.user.uid
                
                if let encoded = try? JSONEncoder().encode(user) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "FIRUser")
                }
                
                let value = UserDefaults.standard.bool(forKey: "FirstTimeUser")
                if !value {
                    UserDefaults.standard.set(true, forKey: "FirstTimeUser")
                }
                
                //6rXRM0C4nAYxP66deoXCI995GbA2 - admin
                if result?.user.uid.localizedCaseInsensitiveCompare("6rXRM0C4nAYxP66deoXCI995GbA2") == .orderedSame {
                    Utils.shared.isAdmin = true
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "AdminDBViewController") as! AdminDBViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                }
                else {
                    Utils.shared.isAdmin = false
                    let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
                }
            }
        }
    }
}

