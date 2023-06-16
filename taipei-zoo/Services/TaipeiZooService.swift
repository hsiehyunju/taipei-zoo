//
//  TaipeiZooService.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/16.
//

import Foundation
import RxSwift

class TaipeiZooService {
    
    static let shared: TaipeiZooService = TaipeiZooService()
    
    let disposeBag = DisposeBag()
    
    func getAreaData(completion: @escaping (Result<AreaResultModel, Error>) -> Void) {
        
        let serviceURL = URL(string: "https://data.taipei/api/v1/dataset/5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a?scope=resourceAquire")
        var request = URLRequest(url: serviceURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(AreaResultModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchPlantData(offset: Int) {
        
        // 組合 API
        var components = URLComponents()
        components.scheme = "https"
        components.host = "data.taipei"
        components.path = "/api/v1/dataset/f18de02f-b6c9-47c0-8cda-50efad621c14"
        
        // 建立查詢參數
        let scopeItem = URLQueryItem(name: "scope", value: "resourceAquire")
        let resourceItem = URLQueryItem(name: "resource_id", value: "f18de02f-b6c9-47c0-8cda-50efad621c14")
        let offsetItem = URLQueryItem(name: "offset", value: "\(offset)")
        components.queryItems = [scopeItem, resourceItem, offsetItem]
        
        // 建立伺服器請求
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.rx.data(request: request)
            .subscribe(onNext: { data in
                print("Data Task Success with count: \(data.count)")
                
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(PlantResultModel.self, from: data)
                    CoreDataManager.shared.savePlantToCoreData(plantArray: model.result.results)
                    
                    let limit = model.result.limit
                    let offset = model.result.offset
                    
                    if ((limit + offset) < model.result.count) {
                        self.fetchPlantData(offset: limit + offset)
                    }
                } catch let error {
                    print("Convert error: \(error)")
                }
                
            }, onError: { error in
                print("Data Task Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
