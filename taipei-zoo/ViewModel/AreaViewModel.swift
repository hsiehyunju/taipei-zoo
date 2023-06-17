//
//  AreaViewModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/16.
//

import Foundation
import RxSwift
import RxCocoa

class AreaViewModel {
    
    var items = PublishSubject<[AreaModel]>()
    
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
