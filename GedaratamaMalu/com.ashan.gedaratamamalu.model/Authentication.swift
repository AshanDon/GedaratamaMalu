//
//  Authentication.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/13/21.
//

import Foundation

struct Authentication : Codable {
    var userName : String
    var password : String
    
    init(userName : String,password : String) {
        self.userName = userName
        self.password = password
    }
}
