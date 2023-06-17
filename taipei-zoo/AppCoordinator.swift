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
        toAreaPage()
    }
    
    func toAreaPage() {
        DispatchQueue.main.async {
            // 實例化 Login View Controller
            let areaViewController = self.storyboard.instantiateViewController(withIdentifier: "AreaViewController") as! AreaViewController
            let viewModel = AreaViewModel.init()
            viewModel.coordinator = self
            areaViewController.viewModel = viewModel
            self.navigationController.pushViewController(areaViewController, animated: true)
        }
    }
    
    func toAreaInfoPage(data: AreaModel) {
        DispatchQueue.main.async {
            // 實例化 Login View Controller
            let areaInfoViewController = self.storyboard.instantiateViewController(withIdentifier: "AreaInfoViewController") as! AreaInfoViewController
            let viewModel = AreaInfoViewModel(model: data)
            viewModel.coordinator = self
            areaInfoViewController.viewModel = viewModel
            self.navigationController.pushViewController(areaInfoViewController, animated: true)
        }
    }
}
