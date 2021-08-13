//
//  Payment.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/12/21.
//

import Foundation

struct Payment : Codable{
    let id: Int?
    let type: String?
    let status: Bool?
    let date : String?
    
    init(id : Int,type : String,status : Bool,date : String) {
        self.id = id
        self.type = type
        self.status = status
        self.date = date
    }
    
    enum CodingKeys : String,CodingKey {
        case id = "id"
        case type = "payment_Type"
        case status = "active_Status"
        case date = "c_Date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        type = try values.decode(String.self, forKey: .type)
        status = try values.decode(Bool.self, forKey: .status)
        date = try values.decode(String.self, forKey: .date)
    }
}
