//
//  DashboardViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DashboardViewController: UIViewController {

    @IBOutlet weak var topViw: UIView!
    @IBOutlet weak var allHighlightedViw: UIView!
    @IBOutlet weak var openHighlightedViw: UIView!
    @IBOutlet weak var closeHighlightedViw: UIView!
    @IBOutlet weak var dbTblViw: UITableView!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var widthConstraintForBackBtn: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    var responseData = [IssuesModel]()
    var buildingName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
        // only show welcome screen for first time users and not admin
        if !Utils.shared.isAdmin && !UserDefaults.standard.bool(forKey: "FirstTimeUser") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                let controller = storyboard.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
                controller.modalPresentationStyle = .popover
                self.present(controller, animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.responseData = []
        let database = Firestore.firestore()
        
        var query: Query = Utils.shared.isAdmin ? database.collection("issues").whereField("building_name", isEqualTo: buildingName) : database.collection("issues").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid)
        
        query.getDocuments(completion: { data, error in
            if error != nil {
                return
            }
            
            for document in data!.documents {
                var dict = document.data()
                self.responseData.append(IssuesModel(documentId: document.documentID, buildingFloors: dict["floor"] as! String, buildingName: dict["building_name"] as! String, description: dict["description"] as! String, imageUrl: dict["image_url"] as! String, issueId: dict["issue_id"] as! String, issueType: dict["issue_type"] as! String, room: dict["room"] as! String, timestamp: dict["timestamp"] as! String, uid: dict["uid"] as! String, status: dict["status"] as! String))
            }
            self.responseData = self.responseData.sorted {$0.issueTypeSortOrder < $1.issueTypeSortOrder}
            self.dbTblViw.reloadData()
        })
    }
    
    func initialSetup() {
        dbTblViw.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        
        self.view.backgroundColor = Colors.shared.background
        Utils.shared.cornerRadius(view: topViw)
        
        Utils.shared.cornerRadius(view: closeHighlightedViw,radius: 3.0)
        Utils.shared.cornerRadius(view: allHighlightedViw,radius: 3.0)
        Utils.shared.cornerRadius(view: openHighlightedViw,radius: 3.0)
        
        addBtn.backgroundColor = Colors.shared.primaryDark
        Utils.shared.cornerRadius(view: addBtn, radius: 40.0)
        
        addBtn.setTitle(" ADD ISSUE", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        
        
        addBtn.isHidden = Utils.shared.isAdmin
        btnLogout.isHidden = Utils.shared.isAdmin
        widthConstraintForBackBtn.constant = Utils.shared.isAdmin ? 40 : 0
        backBtn.isHidden = !Utils.shared.isAdmin
    }
    
    @objc func viewDetailsClick(sender: UIButton) {
        let tag = sender.tag-1
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "IssueDetailViewController") as! IssueDetailViewController
        controller.responseData = self.responseData[tag]
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
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
    
    @IBAction func navigateToAddIssue(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddIssue", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "AddIssueViewController") as! AddIssueViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @IBAction func handleTopCategoryClick(_ sender: UIButton) {
        if sender.tag == 10 {
            allHighlightedViw.isHidden = false
            closeHighlightedViw.isHidden = true
            openHighlightedViw.isHidden = true
        }
        else if sender.tag == 20 {
            allHighlightedViw.isHidden = true
            closeHighlightedViw.isHidden = true
            openHighlightedViw.isHidden = false
        }
        else if sender.tag == 30 {
            allHighlightedViw.isHidden = true
            closeHighlightedViw.isHidden = false
            openHighlightedViw.isHidden = true
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        cell.selectionStyle = .none
        Utils.shared.cornerRadius(view: cell.statusViw,radius: 8.0)
        Utils.shared.cornerRadius( view: cell.viewBtn)
        cell.viewBtn.backgroundColor = Colors.shared.primaryLight
        cell.viewBtn.addTarget(self, action: #selector(viewDetailsClick(sender:)), for: .touchUpInside)
        cell.viewBtn.tag = indexPath.row+1
        cell.lblIdDate.text = "\(responseData[indexPath.row].issueId!) | \(responseData[indexPath.row].timestamp!)"
        cell.lblDescription.text = responseData[indexPath.row].description
        cell.lblBuildingName.text = responseData[indexPath.row].buildingName
        cell.lblIssueType.text = responseData[indexPath.row].issueType
        
        if (responseData[indexPath.row].status == "Closed") {
            cell.statusViw.backgroundColor = .green
        }
        else if (responseData[indexPath.row].status == "Inprogress") {
            cell.statusViw.backgroundColor = .yellow
        }
        else {
            cell.statusViw.backgroundColor = .red
        }
        return cell
    }
    
    
}
