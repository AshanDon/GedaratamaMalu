//
//  Enum.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/8/21.
//

import Foundation

enum HttpStatus : Int {
    
    typealias RawValue = Int
    
    case created,notFound,badRequest,internalServerError
    
    init?(rawValue: Int){
        switch rawValue {
        case 201 : self = .created
        case 404 : self = .notFound
        case 400 : self = .badRequest
        case 500 : self = .internalServerError
        default : return nil
        }
    }
}

enum ButtonType : String {
    case done = "Done"
    case retry = "Retry"
    case ok = "Ok"
    case relaunch = "Relaunch"
}
