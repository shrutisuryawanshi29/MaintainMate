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
import FirebaseStorage
import CoreML
import Vision

class AddIssueViewController: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addIssueTblViw: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var imageIssue: UIImage? = nil
    let issueTypeDropDown = DropDown()
    let buildingDropDown = DropDown()
    
    var arrBuildings: [BuildingsModel] = []
    var arrBuildingStr : [String] = []
    
    var activityView : UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var imageURL: URL? = nil
    
    var optionSelected = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        fetchBuildingListFromDb()
        
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
    
    @objc func openCamera(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func initialSetup() {
        self.view.backgroundColor = Colors.shared.background
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        submitBtn.backgroundColor = Colors.shared.primaryLight
        submitBtn.setTitleColor(.white, for: .normal)
        Utils.shared.cornerRadius(view: submitBtn)
        addIssueTblViw.register(UINib(nibName: "CameraTableViewCell", bundle: nil), forCellReuseIdentifier: "CameraTableViewCell")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //show initial popup
            let alert = UIAlertController(title: "We have automated things for you!", message: "Do you want to manually enter the data or auto detect by our application?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "AUTO DETECT", style: .default) {_ in
                self.optionSelected = 1
                
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.allowsEditing = false
                vc.delegate = self
                self.present(vc, animated: true)
            })
            alert.addAction(UIAlertAction(title: "ENTER MANUALLY", style: .cancel) {_ in
                self.optionSelected = 2
                self.activityView.startAnimating()
            })
            self.present(alert, animated: true)
        }
        
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
        activityView.startAnimating()
        if let cell = addIssueTblViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? CameraTableViewCell {
            if cell.txtFldIssueType.text?.isEmpty ?? true {
                self.present(Utils.shared.showError(message: "Select Issue Type"), animated: true)
            } else if cell.txtFldBuilding.text?.isEmpty ?? true {
                self.present(Utils.shared.showError(message: "Select Building"), animated: true)
            } else if cell.txtFldFloor.text?.isEmpty ?? true {
                self.present(Utils.shared.showError(message: "Enter Floor number"), animated: true)
            } else if cell.txtFldRoom.text?.isEmpty ?? true {
                self.present( Utils.shared.showError(message: "Enter Room number"), animated: true)
            } else if cell.txtFldDescription.text?.isEmpty ?? true {
                self.present(Utils.shared.showError(message: "Enter Description"), animated: true)
            } else if self.imageURL == nil {
                self.present(Utils.shared.showError(message: "Capture Image"), animated: true)
            } else {
                var dict =
                ["building_name": cell.txtFldBuilding.text,
                 "description": cell.txtFldDescription.text,
                 "floor": cell.txtFldFloor.text,
                 "issue_type": cell.txtFldIssueType.text,
                 "room": cell.txtFldRoom.text,
                 "timestamp": Utils.shared.getCurrentDate(),
                 "image_url": self.imageURL?.absoluteString,
                 "uid": Auth.auth().currentUser!.uid,
                 "issue_id": Utils.shared.generateRandomIssueID(),
                 "status": "Open",
                ] as [String : Any]
                
                let database = Firestore.firestore()
                var collec = database.collection("issues")
                
                collec.addDocument(data: dict) { error in
                    if error != nil {
                        self.present(Utils.shared.showError(message: error?.localizedDescription ?? ""), animated: true)
                        return
                    }
                    
                    let alert = UIAlertController(title: "Success!!", message: "You have successfully logged the issue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel){_ in
                        self.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                }
                
            }
        }
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
        
        activityView.startAnimating()
        self.imageIssue = image
        self.addIssueTblViw.reloadData()
        
        analyzeImage(image: image)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let storageRef = Storage.storage(url: "gs://maintenancemate-25270.appspot.com").reference()
        let userPhotoRef = storageRef.child(Auth.auth().currentUser!.uid).child("\(Date().ticks).jpg")
        
        userPhotoRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            
            userPhotoRef.downloadURL { url, error in
                self.activityView.stopAnimating()
                guard let imgurl = url else {return }
                self.imageURL = imgurl
            }
        }
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

extension AddIssueViewController {
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 150, height: 150))?
            .getCVPixelBuffer() else {
            return
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try Predictpaper(configuration: config)
            let input = PredictpaperInput(conv2d_3_input: buffer)
            
            let output = try model.prediction(input: input)
            let text = output.IdentityShapedArray

            if text.scalars[0] > text.scalars[1]{
                if let cell = self.addIssueTblViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? CameraTableViewCell {
                    cell.txtFldDescription.text = "Toilet Paper missing"
                }
            }
            else {
                if let cell = self.addIssueTblViw.cellForRow(at: IndexPath(row: 0, section: 0)) as? CameraTableViewCell {
                    cell.txtFldDescription.text = "Damaged Furniture"
                }
            }
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
