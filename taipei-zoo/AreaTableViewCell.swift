//
//  AreaTableViewCell.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/17.
//

import UIKit

class AreaTableViewCell: UITableViewCell {

    @IBOutlet var areaName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
