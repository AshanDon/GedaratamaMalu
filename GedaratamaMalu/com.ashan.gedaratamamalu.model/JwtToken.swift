//
//  JwtToken.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 4/20/21.
//

import Foundation

struct JwtToken : Decodable {
    let jwt : String 
    
    init(jwt : String) {
        self.jwt = jwt
    }
}
