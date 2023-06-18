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
        let predicate = NSPredicate(format: "location CONTAINS[cd] %@", areaModel.name.replacingOccurrences(of: "區", with: ""))
        if let plantArray = CoreDataManager.shared.fetchDataWithPredicate(entityType: PlantEntity.self, predicate: predicate) {
            
            var array = [PlantUIModel]()
            for plant in plantArray {
                let model = PlantUIModel(no: plant.nid!, name: plant.name!, location: plant.location!, picURL: plant.picURL!)
                array.append(model)
            }
            
            plantModelArray.onNext(array)
            plantModelArray.onCompleted()
        }
    }
    
    func getName() -> String {
        return areaModel.name
    }
    
    func getImageURL() -> URL {
        let urlString = areaModel.picURL.replacingOccurrences(of: "http", with: "https")
        return URL(string: urlString)!
    }
    
    func getIntro() -> String {
        return areaModel.info
    }
}
