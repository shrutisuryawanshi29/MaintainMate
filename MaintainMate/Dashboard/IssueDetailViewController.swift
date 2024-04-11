//
//  IssueDetailViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 4/9/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import DropDown

class IssueDetailViewController: UIViewController {

    @IBOutlet weak var tblViwDetails: UITableView!
    @IBOutlet weak var btnUpdateStatus: UIButton!
    
    var responseData: IssuesModel?
    let statusOfIssueDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        changeStatusOfIssueDropDown()
    }
 
    func initialSetup() {
        
        self.view.backgroundColor = Colors.shared.background
        tblViwDetails.register(UINib(nibName: "IssueDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IssueDetailTableViewCell")
        
        Utils.shared.cornerRadius( view: btnUpdateStatus)
        btnUpdateStatus.backgroundColor = Colors.shared.primaryLight
        
        let storageRef = Storage.storage(url: "gs://maintenancemate-25270.appspot.com").reference(forURL: responseData?.imageUrl ?? "")
        storageRef.getData(maxSize: 15 * 1024 * 1024, completion: { data, error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                let image = UIImage(data: data!)
                if let cell : IssueDetailTableViewCell = self.tblViwDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as? IssueDetailTableViewCell {
                    cell.imgViw.image = image
                    self.tblViwDetails.reloadData()
                }
            }
        })
    }
    
    func changeStatusOfIssueDropDown() {
        //DROPDOWNS
        if let cell = tblViwDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as? IssueDetailTableViewCell {
            statusOfIssueDropDown.anchorView = cell.txtFldIssueStatus
            //KEYS: Closed, Inprogress, Open
            statusOfIssueDropDown.dataSource = ["Open", "In-Progress", "Close"]
            statusOfIssueDropDown.bottomOffset = CGPoint(x: 0 , y: cell.txtFldIssueStatus.bounds.height)
            statusOfIssueDropDown.backgroundColor = Colors.shared.background
            statusOfIssueDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                cell.txtFldIssueStatus.text = item
            }
            statusOfIssueDropDown.show()
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUpdateStatusClick(_ sender: Any) {
        
    }
    
}

extension IssueDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : IssueDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "IssueDetailTableViewCell", for: indexPath) as! IssueDetailTableViewCell
        cell.lblIssueType.text = "Issue Type: \(responseData?.issueType ?? "")"
        cell.lblIssueId.text = responseData?.issueId ?? ""
        cell.lblBuildingName.text = responseData?.buildingName ?? ""
        cell.lblFloorRoom.text = "Floor: \(responseData?.buildingFloors ?? "") Room: \(responseData?.room ?? "")"
        cell.lblDate.text = responseData?.timestamp ?? ""
        cell.lblDescription.text = responseData?.description ?? ""
        cell.selectionStyle = .none
        cell.backgroundColor = Colors.shared.background
        
        if (responseData?.status ?? "" == "Closed") {
            cell.viwStatus.backgroundColor = .green
        }
        else if (responseData?.status ?? "" == "Inprogress") {
            cell.viwStatus.backgroundColor = .yellow
        }
        else {
            cell.viwStatus.backgroundColor = .red
        }
        
        cell.txtFldIssueStatus.delegate = self
        cell.txtFldIssueStatus.tag = 100
        
        Utils.shared.setupTextField(textfield: cell.txtFldIssueStatus, placeholder: "Change Status")
        return cell
    }
}

extension IssueDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 100 {
            changeStatusOfIssueDropDown()
            return false
        }
        return true
    }
}