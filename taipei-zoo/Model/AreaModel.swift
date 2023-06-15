//
//  AreaModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/15.
//

import Foundation

struct AreaModel: Codable {
    let id: Int
    let importdate: Importdate
    let no: String
    let category: String
    let name: String
    let picURL: String
    let info: String
    let memo: String
    let geo: String
    let URL: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case importdate = "_importdate"
        case no = "e_no"
        case category = "e_category"
        case name = "e_name"
        case picURL = "e_pic_url"
        case info = "e_info"
        case memo = "e_memo"
        case geo = "e_geo"
        case URL = "e_url"
    }
}

struct Importdate: Codable {
    let date: String
    let timezoneType: Int
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}
