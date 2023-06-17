//
//  AreaInfoViewModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/17.
//

import Foundation
import RxCocoa
import RxSwift

class AreaInfoViewModel: BaseViewModel {
    
    private var areaModel: AreaModel!
    var plantModelArray = PublishSubject<[PlantUIModel]>()
    
    init(model: AreaModel) {
        super.init()
        self.areaModel = model
    }
    
    func fetchData() {
        var predicate = NSPredicate(format: "location CONTAINS %@", areaModel.name)
        if let plantArray = CoreDataManager.shared.fetchDataWithPredicate(entityType: PlantEntity.self, predicate: predicate) {
            
            var array = [PlantUIModel]()
            for plant in plantArray {
                let model = PlantUIModel(no: plant.nid!, name: plant.name!)
                array.append(model)
            }
            
            plantModelArray.onNext(array)
            plantModelArray.onCompleted()
        }
    }
}
