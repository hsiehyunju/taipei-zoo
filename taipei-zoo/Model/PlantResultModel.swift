//
//  PlantResultModel.swift
//  taipei-zoo
//
//  Created by hsiehyunju on 2023/6/16.
//

import Foundation

struct PlantResultModel: Codable {
    let result: PlantSearchModel
}

struct PlantSearchModel: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [PlantModel]
}
