//
//  ProfileType.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/24/21.
//

import Foundation

struct ProfileType : Codable {
    
    let id : Int
    let type : String
    let status : Bool
    let date : Date
    
    init(id : Int, type : String, status : Bool, date : Date) {
        self.id = id
        self.type = type
        self.status = status
        self.date = date
    }
}
