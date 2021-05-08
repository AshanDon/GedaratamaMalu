//
//  JwtToken.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/20/21.
//

import Foundation

struct JwtToken : Decodable {
    let jwt : String
    let password : String
    
    init(jwt : String,password : String) {
        self.jwt = jwt
        self.password = password
    }
}
