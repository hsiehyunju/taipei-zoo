//
//  AppCoordinator.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/16.
//

import Foundation
import UIKit

class AppCoordinator {
    
    var parentCoordinator: AppCoordinator?
    var children: [AppCoordinator] = []
    var navigationController: UINavigationController
    
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    init(navcontroller: UINavigationController) {
        self.navigationController = navcontroller
    }
    
    func start() {
        
    }
    
}
