//
//  Product.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 1/16/21.
//

import Foundation

struct Product : Codable {
    
    var productId : Int
    var productImage : String
    var catogaryName : String
    var productName : String
    var description : String
    var productPrice : Double
    var productQty : Int = 1
    
    init(productId :Int,productImage :String,catogaryName :String,productName :String,description :String,productPrice :Double,productQty :Int) {
        self.productId = productId
        self.productImage = productImage
        self.catogaryName = catogaryName
        self.productName = productName
        self.description = description
        self.productPrice = productPrice
        self.productQty = productQty
    }
}
