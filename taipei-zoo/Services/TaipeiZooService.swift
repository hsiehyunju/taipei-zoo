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
}
