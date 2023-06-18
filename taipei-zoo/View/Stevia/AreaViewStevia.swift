//
//  AreaViewStevia.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/18.
//

import UIKit
import Stevia

class AreaViewStevia: UIView {

    let tableView = UITableView()
    
    convenience init() {
        self.init(frame: CGRectZero)
        tableView.register(AreaTableViewCell.self, forCellReuseIdentifier: "AreaTableViewCell")
        
        subviews(self.tableView)
        
        layout(
            0,
            |-tableView-|,
            0
        )
    }
}
