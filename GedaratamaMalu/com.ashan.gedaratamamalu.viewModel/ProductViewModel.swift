//
//  ProductViewModel.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 5/9/21.
//

import Foundation
import Alamofire

@objc protocol ProductDelegate{
    @objc optional func getProductList(productList : [AnyObject])
    @objc optional func getAvailableProductStock(_ qty : Int)
    @objc optional func getProductImage(_ imageData : NSData)
}

class ProductViewModel{
    
    fileprivate let token : String
    fileprivate let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    public var delegate : ProductDelegate!
    
    public init(_ jwt_Token : String) {
        self.token = jwt_Token
    }
    
    private func getHTTPHeaders() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: token)
        ]
        return headers
    }
    
    public func getAllProductDetails(){
        
        var url : String {
            return "\(baseURL)/product/all"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(getError.localizedDescription)
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        let decodeData = try JSONDecoder().decode([Product].self, from: data)
                        strongeSelf.delegate.getProductList?(productList: decodeData as [AnyObject])
                    } catch let decodeException {
                        print(decodeException.localizedDescription)
                    }
                   }
    }
    
    
    public func getStockByProductId(_ id : Int){
        var url : String {
            return "\(baseURL)/batch/stock/\(id)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(print(getError.localizedDescription))
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Int]
                        
                        if let qty = jsonObject["Qty"]{
                            strongeSelf.delegate.getAvailableProductStock?(qty)
                        }
                    } catch let jSException {
                        print(jSException.localizedDescription)
                    }
                    
                   }
    }
    
    public func productAdvanceSearch(_ name : String){
        
        var url : String {
            return "\(baseURL)/product/search"
        }
        
        let param : Parameters  = [
            "name" : name
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(print(getError.localizedDescription))
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        let decodeData = try JSONDecoder().decode([Product].self, from: data)
                        strongeSelf.delegate.getProductList?(productList: decodeData as [AnyObject])
                    } catch let decodeException {
                        print(decodeException.localizedDescription)
                    }
                   }
    }
    
    
    public func getProductImage(ProductCode code : Int){
        var url : String {
            return "\(baseURL)/product_image/\(code)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders()).responseJSON { [weak self] (response) in
                    guard let strongeSelf = self else { return }
                    
                    if let getError = response.error {
                        print(print(getError.localizedDescription))
                    }
                    
                    guard let data = response.data else { return }
                    
                    do{
                        let decodeData = try JSONDecoder().decode(String.self, from: data)
                        if let url = URL(string: decodeData){
                            let data : NSData = try NSData(contentsOf: url, options: [])
                            strongeSelf.delegate.getProductImage?(data)
                        }
                    } catch let decodeException {
                        print(decodeException.localizedDescription)
                    }
                   }
    }
    
    func getAllProductByCID(CategoryId id : Int){
        
        var url : String {
            return "\(baseURL)/product/find/Cate_id/\(id)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: getHTTPHeaders())
            .responseJSON { [weak self] (resJson) in
                
                guard let strongeSelf = self else { return }
                
                if let error = resJson.error {
                    print(error.localizedDescription)
                }
                
                guard let data = resJson.data else { return }
                
                do{
                    let list = try JSONDecoder().decode([Product].self, from: data)
                    strongeSelf.delegate.getProductList?(productList: list as [AnyObject])
                } catch let decoderExp {
                    print(decoderExp.localizedDescription)
                }
            }
    }
}
