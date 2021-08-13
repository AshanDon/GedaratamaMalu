//
//  JwtToken.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/20/21.
//

import Foundation

struct JwtToken : Decodable {
    let jwt : String
    let userName : String
    let password : String
    
    init(jwt : String,userName : String,password : String) {
        self.jwt = jwt
        self.userName = userName
        self.password = password
    }
}
