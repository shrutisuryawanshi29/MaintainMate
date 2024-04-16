//
//  CameraTableViewCell.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/6/24.
//

import UIKit
import MaterialTextField

class CameraTableViewCell: UITableViewCell {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var imgViw: UIImageView!
    
    @IBOutlet weak var txtFldIssueType: MFTextField!
    @IBOutlet weak var txtFldBuilding: MFTextField!
    @IBOutlet weak var txtFldFloor: MFTextField!
    @IBOutlet weak var txtFldRoom: MFTextField!
    @IBOutlet weak var txtFldDescription: MFTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Utils.shared.setupTextField(textfield: txtFldIssueType, placeholder: "Issue Type")
        Utils.shared.setupTextField(textfield: txtFldBuilding, placeholder: "Building")
        Utils.shared.setupTextField(textfield: txtFldFloor, placeholder: "Floor")
        Utils.shared.setupTextField(textfield: txtFldRoom, placeholder: "Room No")
        Utils.shared.setupTextField(textfield: txtFldDescription, placeholder: "Description")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
