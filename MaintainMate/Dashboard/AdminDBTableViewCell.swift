//
//  AdminDBTableViewCell.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/16/24.
//

import UIKit

class AdminDBTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblBuildingName: UILabel!
    @IBOutlet weak var lblOpenIssues: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBg.dropShadow(shadowOpacity: 0.3)
        viewBg.backgroundColor = Colors.shared.primaryDark
        Utils.shared.cornerRadius(view: viewBg, radius: 10)
        
        lblOpenIssues.layer.borderWidth = 2.0
        lblOpenIssues.layer.borderColor = Colors.shared.primaryDark.cgColor
        Utils.shared.cornerRadius(view: lblOpenIssues)
        
        lblOpenIssues.textColor = .white
        lblBuildingName.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
