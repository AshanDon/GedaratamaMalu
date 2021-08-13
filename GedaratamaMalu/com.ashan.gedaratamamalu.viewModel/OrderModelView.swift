//
//  OrderViewModel.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 7/9/21.
//

import Foundation
import Alamofire

protocol OrderDelegate {
    func showResponseCode(HttpCode code : Int)
    func getOrderInfo(Order info : Order)
}

class OrderModelView{
    
    fileprivate var jwtToken : String!
    fileprivate let baseURL : String = "http://192.168.0.182:8080/malukade/v1"
    
    var delegate : OrderDelegate!
    
    init(JwtToken token : String) {
        self.jwtToken = token
    }
    
    fileprivate var httpHeaders : HTTPHeaders {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json"),
            .authorization(bearerToken: jwtToken)
        ]
        return headers
    }
    
    func saveOrderInfo(Order details : Order,ProductList list : [Product]){
        
        var url : String {
            return "\(baseURL)/order"
        }
        
        guard let stringURL = URL(string: url) else { return }
        
        var urlRequest : URLRequest!
        
        do{
            urlRequest = try URLRequest(url: stringURL, method: .post, headers: httpHeaders)
            urlRequest.httpBody = try JSONEncoder().encode(details)
        } catch let exp {
            print(exp.localizedDescription)
        }
        
        var orderDetailsList = [OrderDetail]()
        
        AF.request(urlRequest).responseJSON { [weak self] (response) in
            
            guard let strongeSelf = self else { return }
            
            if let getError = response.error {
                print(getError.localizedDescription)
                strongeSelf.delegate.showResponseCode(HttpCode: 500)
            }
            
            
            guard let data = response.data else { return }
            
            do{
                let orderInfo = try JSONDecoder().decode(Order.self, from: data)
                
                for productInfo in list {
                    let details = OrderDetail(id: 0, discount: 0, qty: Double(productInfo.qty!), unitPrice: productInfo.unitprice!, order: orderInfo, product: productInfo)
                    
                    orderDetailsList.append(details)
                }
                
                if let resCode = response.response {
                    if resCode.statusCode == 201 {
                        strongeSelf.saveOrderDetails(OrderDetailList: orderDetailsList, Order: orderInfo)
                    } else {
                        strongeSelf.delegate.showResponseCode(HttpCode: 500)
                    }
                }
                
            } catch let decodeExp {
                print(decodeExp.localizedDescription)
            }
        }.resume()
    }
    
    
    fileprivate func saveOrderDetails(OrderDetailList list : [OrderDetail],Order details : Order){
        
        var url : String {
            return "\(baseURL)/order_details"
        }
        
        guard let stringURL = URL(string: url) else { return }
        
        var urlRequest : URLRequest!
        
        do{
            urlRequest = try URLRequest(url: stringURL, method: .post, headers: httpHeaders)
            urlRequest.httpBody = try JSONEncoder().encode(list)
        } catch let exp {
            print("Error :- \(exp.localizedDescription)")
        }
       
        AF.request(urlRequest).responseJSON { [weak self] (response) in
            guard let strongeSelf = self else { return }
            
            if let getError = response.error {
                print(getError.localizedDescription)
                strongeSelf.delegate.showResponseCode(HttpCode: 500)
            }
            
            if let result = response.response {
                if result.statusCode == 201 {
                    strongeSelf.delegate.getOrderInfo(Order: details)
                } else {
                    strongeSelf.delegate.showResponseCode(HttpCode: result.statusCode)
                }
            }
        }.resume()
    }
}
