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
    
    func getPlantData(completion: @escaping (Result<[PlantModel], Error>) -> Void) {
        
        var plantDataArray: [PlantModel] = [PlantModel]()
        var maxDataCount: Int = 0
        var isNext = true
        
        while(isNext) {
            // 組合 API
            var components = URLComponents()
            components.scheme = "https"
            components.host = "data.taipei"
            components.path = "/api/v1/dataset/f18de02f-b6c9-47c0-8cda-50efad621c14"
            
            // 建立查詢參數
            let scopeItem = URLQueryItem(name: "scope", value: "resourceAquire")
            let resourceItem = URLQueryItem(name: "resource_id", value: "f18de02f-b6c9-47c0-8cda-50efad621c14")
            let offsetItem = URLQueryItem(name: "offset", value: "\(plantDataArray.count)")
            
            // 建立伺服器請求
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if error != nil {
                    completion(.failure(error!))
                }
                
                if let data = data {
                    do {
                        // 將 json 轉為 UserModel
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(PlantResultModel.self, from: data)
                        maxDataCount = model.result.count
                        plantDataArray += model.result.results
                        
                        isNext = plantDataArray.count < maxDataCount
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                }
                
            }.resume()
        }
        completion(.success(plantDataArray))
    }
}
