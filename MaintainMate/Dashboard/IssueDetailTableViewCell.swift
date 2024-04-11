//
//  IssueDetailTableViewCell.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 4/9/24.
//

import UIKit
import MaterialTextField

class IssueDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViw: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblIssueType: UILabel!
    @IBOutlet weak var lblIssueId: UILabel!
    @IBOutlet weak var lblBuildingName: UILabel!
    @IBOutlet weak var lblFloorRoom: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtFldIssueStatus: MFTextField!
    @IBOutlet weak var viwStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        Utils.shared.cornerRadius(view: imgViw)
        Utils.shared.cornerRadius(view: bgView)
        Utils.shared.cornerRadius(view: viwStatus, radius: 8.0)
        bgView.dropShadow(shadowOpacity: 0.3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
