//
//  SaleModel.swift
//  pickary
//
//  Created by Dan on 10/20/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import Foundation
import Alamofire

class SaleModel: NSObject {
    
    var id = ""
    var company = ""
    var title = ""
    var starts_at = ""
    var startDate: Date {
        
        get {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
            let dateObject = dateFormatter.date(from: starts_at)
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateObject!
        }
        
        set (newValue){
            
            
        }
    }
    var finishes_at = ""
    var finishDate: Date {
        
        get {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
            let dateObject = dateFormatter.date(from: finishes_at)
            return dateObject!
        }
        
        set (newValue){
            
            
        }

    }
    
    var location: Parameters?
    var locationModel : LocationModel? {
        
        set (newValue){
         
        }
        
        get {
            
            return LocationModel(location)
        }
    }
    var descriptions = ""
}
