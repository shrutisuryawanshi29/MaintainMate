//
//  AdminDBViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/16/24.
//

import UIKit
import FirebaseAuth

class AdminDBViewController: UIViewController {
    
    @IBOutlet weak var tblViw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        tblViw.register(UINib(nibName: "AdminDBTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminDBTableViewCell")
        self.view.backgroundColor = Colors.shared.background
    }
    
    @IBAction func logoutBtnClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            if let data = UserDefaults.standard.object(forKey: "FIRUser") as? Data,
               let _ = try? JSONDecoder().decode(FIRUser.self, from: data) {
                let defaults = UserDefaults.standard
                defaults.set(nil, forKey: "FIRUser")
                self.dismiss(animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension AdminDBViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AdminDBTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminDBTableViewCell", for: indexPath) as! AdminDBTableViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
    }
    
}
