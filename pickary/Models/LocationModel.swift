//
//  LocationModel.swift
//  pickary
//
//  Created by Mobile Developer on 12/9/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import Alamofire

class LocationModel: NSObject {
    //"street_address”:”1212 N Hoyne", "city”:”Chicago", "state”:"IL", "postal_code”:"60622"
    var street_address = ""
    var city = ""
    var state = ""
    var postal_code = ""
    
    var data: Parameters {
       
        get {
            
            return ["street_address":street_address, "city": city, "state": state, "postal_code":postal_code] as Parameters
        }
        
        set (newValue){
            
            
        }
        
    }
    
    init(_ dictionary: Parameters?) {

        super.init()
        self.street_address = dictionary?["street_address"] as! String
        self.city = dictionary?["city"] as! String
        self.state = dictionary?["state"] as! String
        self.postal_code = dictionary?["postal_code"] as! String
        
    }

}
