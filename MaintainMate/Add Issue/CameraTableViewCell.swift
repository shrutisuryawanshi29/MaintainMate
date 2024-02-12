//
//  CameraTableViewCell.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/6/24.
//

import UIKit

class CameraTableViewCell: UITableViewCell {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var imgViw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
