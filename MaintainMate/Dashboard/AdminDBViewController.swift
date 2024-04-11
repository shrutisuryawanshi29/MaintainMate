//
//  AdminDBViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/16/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuth

class AdminDBViewController: UIViewController {
    
    @IBOutlet weak var tblViw: UITableView!
    
    var responseData = [IssuesModel]()
    var buildingDict = [String: Int]()
    var keysArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        responseData = []
        buildingDict = [:]
        let database = Firestore.firestore()
        let query: Query = database.collection("issues")
        
        query.getDocuments(completion: { data, error in
            if error != nil {
                return
            }
            
            for document in data!.documents {
                var dict = document.data()
                self.responseData.append(IssuesModel(documentId: document.documentID, buildingFloors: dict["floor"] as! String, buildingName: dict["building_name"] as! String, description: dict["description"] as! String, imageUrl: dict["image_url"] as! String, issueId: dict["issue_id"] as! String, issueType: dict["issue_type"] as! String, room: dict["room"] as! String, timestamp: dict["timestamp"] as! String, uid: dict["uid"] as! String, status: dict["status"] as! String))
            }
            
            for resp in self.responseData {
                self.buildingDict[resp.buildingName!, default: 0] += 1
            }
            
            self.keysArray = Array(self.buildingDict.keys)
            
            self.tblViw.reloadData()
        })
        
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
        return buildingDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AdminDBTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminDBTableViewCell", for: indexPath) as! AdminDBTableViewCell
        cell.selectionStyle = .none
        let currentKey = keysArray[indexPath.row]
        let currentIndexKey = buildingDict[currentKey] as! Int
        
        cell.lblBuildingName.text = currentKey
        cell.lblOpenIssues.text = "\(currentIndexKey)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentKey = keysArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DashboardViewController") as! DashboardViewController
//        controller.responseData = self.responseData.filter {$0.buildingName == currentKey}
        controller.buildingName = currentKey
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
    }
    
}
