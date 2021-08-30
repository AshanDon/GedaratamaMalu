//
//  CategoryModelView.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 8/30/21.
//

import Foundation
import Alamofire

protocol CategoryDelegate {
    func getAllCategoris(CategoryList list : [Category])
}

class CategoryModelView {
    
    fileprivate var jwt_Token : String!
    fileprivate let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    var delegate : CategoryDelegate!
    
    fileprivate var httpHeaders : HTTPHeaders {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: jwt_Token)
        ]
        return headers
    }
    
    init(JwtToken token : String) {
        self.jwt_Token = token
    }
    
    
    func getAllCategoris(){
        
        var url : String {
            return "\(baseURL)/category/all"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders)
            .responseJSON { [weak self] (resJson) in
                
                guard let strongeSelf = self else { return }
                
                if let error = resJson.error {
                    print(error.localizedDescription)
                }
                
                guard let data = resJson.data else { return }
                
                do{
                    let list = try JSONDecoder().decode([Category].self, from: data)
                    strongeSelf.delegate.getAllCategoris(CategoryList: list)
                } catch let decoderExp {
                    print(decoderExp.localizedDescription)
                }
            }.resume()
    }
    
}
