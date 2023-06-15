//
//  AreaResultModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/15.
//

import Foundation

struct AreaResultModel: Codable {
    let result: AreaSearchModel
}

struct AreaSearchModel: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [AreaModel]
}
