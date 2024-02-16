//
//  AddIssueViewController.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/6/24.
//

import UIKit
import DropDown
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class AddIssueViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addIssueTblViw: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var imageIssue: UIImage? = nil
    let issueTypeDropDown = DropDown()
    let buildingDropDown = DropDown()
    
    var arrBuildings: [BuildingsModel] = []
    var arrBuildingStr : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
        fetchBuildingListFromDb()
        
    }
    
    @objc func openCamera(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func initialSetup() {
        self.view.backgroundColor = Colors.shared.background
        
        submitBtn.backgroundColor = Colors.shared.primaryLight
        submitBtn.setTitleColor(.white, for: .normal)
        Utils.shared.cornerRadius(view: submitBtn)
        addIssueTblViw.register(UINib(nibName: "CameraTableViewCell", bundle: nil), forCellReuseIdentifier: "CameraTableViewCell")
    }
    

    func issueTypeDropDownClick() {
        //DROPDOWNS
        if let cell = addIssueTblViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? CameraTableViewCell {
            issueTypeDropDown.anchorView = cell.txtFldIssueType
            issueTypeDropDown.dataSource = ["Water Leakage", "Electricity Outage", "Somebody is locked", "Other"]
            issueTypeDropDown.bottomOffset = CGPoint(x: 0 , y: cell.txtFldIssueType.bounds.height)
            issueTypeDropDown.backgroundColor = Colors.shared.background
            issueTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                cell.txtFldIssueType.text = item
            }
            issueTypeDropDown.show()
        }
    }
    
    func buildingDropDownClick() {
        //DROPDOWNS
        if let cell = addIssueTblViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? CameraTableViewCell {
            buildingDropDown.anchorView = cell.txtFldBuilding
            buildingDropDown.dataSource = arrBuildingStr
            buildingDropDown.bottomOffset = CGPoint(x: 0 , y: cell.txtFldBuilding.bounds.height)
            buildingDropDown.backgroundColor = Colors.shared.background
            buildingDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                cell.txtFldBuilding.text = item
            }
            buildingDropDown.show()
        }
    }
    
    
    //MARK: APIS
    func fetchBuildingListFromDb() {
        var database = Firestore.firestore()
        
        let collection = database.collection("buildings")
        collection.getDocuments(completion: { [self] snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            if let documents = snapshot?.documents {
                for val in documents {
                    print(val.data())
                    var building = BuildingsModel()
                    building.buildingFloors = val.data()["building_floors"] as? Int
                    building.buildingName = val.data()["building_name"] as? String
                    self.arrBuildings.append(building)
                    
                    self.arrBuildingStr.append((val.data()["building_name"] as? String)!)
                }
            }
        })

    }
    
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitBtnClick(_ sender: Any) {
    }
    
}

extension AddIssueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CameraTableViewCell", for: indexPath) as! CameraTableViewCell
        cell.selectionStyle = .none
        cell.cameraBtn.backgroundColor = Colors.shared.primaryLight
        cell.cameraBtn.tintColor = .white
        cell.cameraBtn.addTarget(self, action: #selector(openCamera(_:)), for: .touchUpInside)
        Utils.shared.cornerRadius(view: cell.cameraBtn)
        
        cell.cameraBtn.setTitle(imageIssue == nil ? "TAKE A PIC" : "RETAKE PIC"  , for: .normal)
        cell.imgViw.image = self.imageIssue
        Utils.shared.cornerRadius(view: cell.imgViw)
        
        cell.txtFldIssueType.delegate = self
        cell.txtFldBuilding.delegate = self
        cell.txtFldFloor.delegate = self
        cell.txtFldRoom.delegate = self
        cell.txtFldDescription.delegate = self
        
        cell.txtFldIssueType.tag = 10
        cell.txtFldBuilding.tag = 20
        
        return cell
    }
    
    
}

extension AddIssueViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageIssue = image
        self.addIssueTblViw.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddIssueViewController : UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10 {
            issueTypeDropDownClick()
            return false
        }
        if textField.tag == 20 {
            buildingDropDownClick()
            return false
        }
        return true
    }
    
}
