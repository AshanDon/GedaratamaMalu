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
    func getOrderDetailInfo(OrderDetails list : [OrderDetails])
    func getAllPendingOrders(List list : [Order])
    func updateActiveStatus(Updated result : Bool)
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
        
        var orderDetailsList = [OrderDetails]()
        
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
                    let details = OrderDetails(id: 0, discount: 0, qty: productInfo.qty!, unitPrice: Int(productInfo.unitprice!), order: orderInfo, product: productInfo)
                    
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
    
    
    fileprivate func saveOrderDetails(OrderDetailList list : [OrderDetails],Order details : Order){
        
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
    
    func getOrderInfoById(_ orderId : Int){
        
        var url : String {
            return "\(baseURL)/order/\(orderId)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders)
            .responseJSON { [weak self] (response) in
                    
                guard let strongeSelf = self else { return }
                
                if let getError = response.error {
                    print(getError.localizedDescription)
                    strongeSelf.delegate.showResponseCode(HttpCode: 500)
                }
                
                guard let data = response.data else { return }
                
                do{
                    let orderInfo = try JSONDecoder().decode(Order.self, from: data)
                    
                    strongeSelf.delegate.getOrderInfo(Order: orderInfo)
                    
                }catch let jsonDecodeExp {
                    print(jsonDecodeExp.localizedDescription)
                }
                
        }.resume()
    }
    
    public func getOrderDetailsByOID(OrderID id : Int) {
        
        var url : String {
            return "\(baseURL)/order_details/\(id)"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders)
            .responseJSON { [weak self] (response) in
                
                guard let strongeSelf = self else { return }
                
                if let getError = response.error {
                    print(getError.localizedDescription)
                    strongeSelf.delegate.showResponseCode(HttpCode: 500)
                }
                
                guard let data = response.data else { return }
                
                do{
                    let orderDetailList = try JSONDecoder().decode([OrderDetails].self, from: data)
                    strongeSelf.delegate.getOrderDetailInfo(OrderDetails: orderDetailList)
                } catch let decodeExp {
                    print(decodeExp.localizedDescription)
                }
            }.resume()
    }
    
    func getAllPendingOrderByProfileId(ProfileId id : Int){
        
        let parameter : Parameters = [
            "pro_id" : id
        ]
        
        var url : String {
            return "\(baseURL)/pending_order"
        }
        
        AF.request(url,
                   method: .get,
                   parameters: parameter,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders)
            .responseJSON { [weak self] (resJson) in
                
                guard let strongeSelf = self else { return }
                
                if let getError = resJson.error {
                    print(getError.localizedDescription)
                    strongeSelf.delegate.showResponseCode(HttpCode: 500)
                }
                
                guard let data = resJson.data else { return }
                
                do{
                    let orderList = try JSONDecoder().decode([Order].self, from: data)
                    strongeSelf.delegate.getAllPendingOrders(List: orderList)
                } catch let decoderExp {
                    print(decoderExp.localizedDescription)
                }
                
            }.resume()
    }
    
    func updateActivityStatusByOID(Order_Id id : Int){
        
        var url : String {
            return "\(baseURL)/order/activity"
        }
        
        let param : Parameters = [
            "o_id" : id
        ]
        
        AF.request(url,
                   method: .put,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: httpHeaders)
            .responseJSON { [weak self] (resJson) in
                
                guard let strongeSelf = self else { return }
                
                if let error = resJson.error {
                    print(error.localizedDescription)
                    strongeSelf.delegate.showResponseCode(HttpCode: 500)
                }
                
                guard let data = resJson.data else { return }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Bool]
                    let update = result["Result"]!
                    strongeSelf.delegate.updateActiveStatus(Updated: update)
                } catch let decoderExp {
                    print("Decoder Exp :- \(decoderExp.localizedDescription)")
                }
            }
    }
}
