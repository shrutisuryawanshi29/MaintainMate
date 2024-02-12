//
//  DashboardTableViewCell.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/2/24.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var statusViw: UIView!
    @IBOutlet weak var viewBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
