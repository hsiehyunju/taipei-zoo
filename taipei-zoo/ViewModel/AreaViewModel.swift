//
//  AreaViewModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/16.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class AreaViewModel: BaseViewModel {
    
    let dataChangesSubject = PublishSubject<Void>()
    var items = PublishSubject<[AreaModel]>()
    
    override init() {
        super.init()
        
        // 註冊資料更新
        CoreDataManager.shared.fetchedAreaResultsController.delegate = self
        dataChangesSubject
            .subscribe(onNext: {
                print("資料更新")
                self.fetchData()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData() {
        if let areaArray = CoreDataManager.shared.fetchAllData(entityType: AreaEntity.self) {
            var array = [AreaModel]()
            for area in areaArray {
                var model = AreaModel(id: Int(area.nid!)!, importdate: Importdate(date: "", timezoneType: 0, timezone: ""), no: area.no!, category: area.category!, name: area.name!, picURL: area.picURL!, info: area.info!, memo: "", geo: "", URL: area.url!)
                array.append(model)
            }
            items.onNext(array)
            items.onCompleted()
        }
    }
}

extension AreaViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataChangesSubject.onNext(())
    }
}
