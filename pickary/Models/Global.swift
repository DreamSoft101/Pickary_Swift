//
//  Global.swift
//  pickary
//
//  Created by Mobile Developer on 11/2/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SVProgressHUD


extension Array where Element: Equatable {
    
    //Remove first collection element that is equal to the given object
    
    mutating func remove(object: Element) {
        
        if let index = index(of: object) {
            
            remove(at: index)
        }
    }
}


class Global: NSObject {
    
    static func getDateStringFromDate (_ date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        
        return dateFormatter.string(from: date)
        
    }

    static func getUsefulDateString ( dateString: String) ->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateObject = dateFormatter.date(from: dateString)

        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        return  dateFormatter.string(from: dateObject!)

    }
    
    static func getDateFromString (_ string: String) ->Date {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        
        let dateObj = dateFormatter.date(from: string)
        
        return dateObj!
    }
    
//    static func getToday() -> Date {
//        
//        let dateFormatter = DateFormatter()
//        
//        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
//        
//    
//        
//    }
    
    // Show alert 
    static func showAlertViewController(title:String , message: String, target: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        target.navigationController?.present(alertController, animated: true, completion: nil)
        
    }

    // Show Progres
    
    static func showWithStatus(status: String) {
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        SVProgressHUD.show(withStatus: status)
        
    }
    
    static func show() {
        
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        SVProgressHUD.show()

    }
    
    static func hideProgress() {
        
        SVProgressHUD.dismiss()
    }
    
    static func getSortedArray( _ resultArray:[SaleModel]) ->([SaleModel], [SaleModel]){
       
        let array = resultArray
                
        var futureSales:[SaleModel]  = [], pastSales:[SaleModel] = []
        
        for idx in array {
            
            if (idx.finishDate >= Date()) {
                
                futureSales.append(idx)
            }else {
                
                pastSales.append(idx)
            }
        }
        
        futureSales.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending})
        pastSales.sort(by: { $0.startDate.compare($1.startDate) == .orderedDescending})
        
        var newArray = [SaleModel]()
        
        newArray.append(contentsOf: futureSales)
        newArray.append(contentsOf: pastSales)
        
        
        return (futureSales, pastSales)
        
    }
}
