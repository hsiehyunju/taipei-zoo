//
//  AppDelegate.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController.init()
        appCoordinator = AppCoordinator(navcontroller: navigationController)
        appCoordinator!.start()
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        TaipeiZooService.shared.getAreaData { result in
            do {
                let item = try result.get()
                CoreDataManager.shared.saveAreaToCoreData(areaArray: item.result.results)
            } catch {
            }
        }
        
        TaipeiZooService.shared.fetchPlantData(offset: 0)

        return true
    }
    
}
