//
//  CoreDataManager.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/16.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZooDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveAreaToCoreData(areaArray: [AreaModel]) {
        
        let context = persistentContainer.viewContext
        context.perform {
            for area in areaArray {
                
                // 創建一個 Fetch Request，用於檢查資料是否已存在
                let fetchRequest: NSFetchRequest<AreaEntity> = AreaEntity.fetchRequest()
                // 根據 name 判斷是否已存在
                fetchRequest.predicate = NSPredicate(format: "name == %@", area.name)
                
                do {
                    let items = try context.fetch(fetchRequest)
                    
                    if let item = items.first {
                        print("資料已存在：\(item.name!)")
                    } else {
                        let areaEntity = AreaEntity(context: context)
                        areaEntity.nid = String(area.no)
                        areaEntity.category = area.category
                        areaEntity.info = area.info
                        areaEntity.name = area.name
                        areaEntity.no = area.no
                        areaEntity.picURL = area.picURL
                        areaEntity.url = area.URL
                    }
                } catch let error {
                    fatalError("無法檢查或儲存資料：\(error)")
                }
            }
            
            do {
                try context.save()
            } catch {
                fatalError("無法保存 Core Data 的資料：\(error)")
            }
        }
    }
    
    func savePlantToCoreData(plantArray: [PlantModel]) {
        
        let context = persistentContainer.viewContext
        context.perform {
            for plant in plantArray {
                
                // 創建一個 Fetch Request，用於檢查資料是否已存在
                let fetchRequest: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
                // 根據 name 判斷是否已存在
                fetchRequest.predicate = NSPredicate(format: "name == %@", plant.fNameCh)
                
                do {
                    let items = try context.fetch(fetchRequest)
                    
                    if let item = items.first {
                        print("資料已存在：\(item.name) - \(item.nid)")
                    } else {
                        let plantEntity = PlantEntity(context: context)
                        plantEntity.nid = String(plant.id)
                        plantEntity.name = plant.fNameCh
                        plantEntity.location = plant.fLocation
                    }
                } catch let error {
                    fatalError("無法檢查或儲存資料：\(error)")
                }
            }
            
            do {
                try context.save()
            } catch {
                fatalError("無法保存 Core Data 的資料：\(error)")
            }
        }
    }
    
    func fetchAllData<T: NSManagedObject>(entityType: T.Type) -> [T]? {
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("獲取資料失敗\(error)")
            return nil
        }
    }
    
    func fetchDataWithPredicate<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate) -> [T]? {
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("獲取資料失敗\(error)")
            return nil
        }
    }
    
    lazy var fetchedAreaResultsController: NSFetchedResultsController<AreaEntity> = {
        let request: NSFetchRequest<AreaEntity> = AreaEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "no", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext:CoreDataManager.shared.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    lazy var fetchedPlantResultsController: NSFetchedResultsController<PlantEntity> = {
        let request: NSFetchRequest<PlantEntity> = PlantEntity.fetchRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext:CoreDataManager.shared.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
}
