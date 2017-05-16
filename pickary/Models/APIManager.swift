//
//  APIManager.swift
//  pickary
//
//  Created by Dan on 10/20/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    static let BASEURL = "https://pickary.herokuapp.com/v1/"
    static let UUID    = "f5847379-b183-4936-a69a-327280551549"
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    
    static func getSaleListPickary(completionHandler: @escaping CompletionHandler) {
        let url = BASEURL + "companies/\(UUID)/estate_sales"
        
        var resultArray = [SaleModel]()
        
        Alamofire.request(url).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                print("get salelist ok!")
                
                appDel.gSaleListArray.removeAll()
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let json_data = JSON as! [[String: Any]]
                    
                    for item in json_data {
                        let aSale = SaleModel()
                        
                        if let id = item["id"] as? String {
                            print("id : \(id)")
                            aSale.id = id
                        }
                        if let company = item["company"] as? String {
                            print("company : \(company)")
                            aSale.company = company
                        }
                        if let title = item["title"] as? String {
                            print("title : \(title)")
                            aSale.title = title
                        }
                        if let starts_at = item["starts_at"] as? String {
                            print("starts_at : \(starts_at)")
                            aSale.starts_at = starts_at
                        }
                        if let finishes_at = item["finishes_at"] as? String {
                            print("finishes_at : \(finishes_at)")
                            aSale.finishes_at = finishes_at
                        }
                        if let description = item["description"] as? String {
                            print("description : \(description)")
                            aSale.descriptions = description
                        }
                        if let location = item["location"] as? Parameters {
                            
                            print("location : \(location)")
                            
                            aSale.location = location
                        }
                        
                        
                        resultArray.append(aSale)
                        
                    }
                    
                    appDel.gSaleListArray.append(contentsOf: resultArray)
                    
                    completionHandler(true)
                }
                
            case .failure(let error):
                print("get salelist failed: \(error)")
                completionHandler(false)
            }
        }
    }
    
    static func addSalePickary(params: Parameters, completionHandler: @escaping CompletionHandler) {
        let url = BASEURL + "companies/\(UUID)/estate_sales"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                print("add a sale ok!")
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    completionHandler(true)
                }
                
            case .failure(let error):
                print("add a sale failed: \(error)")
                completionHandler(false)
            }
        }
    }
    
    static func updateExistingSale(params: Parameters, completionHandler: @escaping CompletionHandler) {
        
        //https://pickary.herokuapp.com/v1/estate_sales/5fcc7836-093f-4a5d-8a36-75c8ab792613
        //'{"title":"Estate Sale 3","description":"great sale!","starts_at":"2015-01-31 9:00","finishes_at":"2016-11-30 21:00"}'
        
        let url = BASEURL + "estate_sales/\(params["id"]!)"
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("add a sale ok!")
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    completionHandler(true)
                }
                
            case .failure(let error):
                print("add a sale failed: \(error)")
                completionHandler(false)
            }

        }
    }
}

