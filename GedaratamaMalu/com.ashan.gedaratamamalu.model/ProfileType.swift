//
//  ProfileType.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/24/21.
//

import Foundation

struct ProfileType : Codable {

    let id : Int?
    let type : String?
    let status : Bool?
    let date : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case status = "status"
        case date = "date"
    }

    init(id : Int,type : String,status : Bool,date : String) {
        self.id = id
        self.type = type
        self.status = status
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
}
