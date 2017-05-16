//
//  SaleAdditionalDirectionVC.swift
//  pickary
//
//  Created by Mobile Developer on 11/16/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class SaleAdditionalDirectionVC: UIViewController, UITextViewDelegate {

    private var didSetupConstraints = false

    let descriptionTextView: UITextView = {
       
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)

//        textView.backgroundColor = UIColor.groupTableViewBackground
        
        return textView
    }()
    
    var toolBar:UIToolbar!
    
    var currentSale: SaleModel! {
        
        willSet {
            
        }
        
        didSet {
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            descriptionTextView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)
                make.top.equalToSuperview().inset(kLabelVerticalInsets)
                make.height.greaterThanOrEqualTo(200)
            })
            
            didSetupConstraints = true
            
        }
        
        super.updateViewConstraints()
    }

    // MARK: - Private
    
    private func initialize() {
        
        
        self.title = "Additional Directions"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(sender:)))
        
        let superView = self.view
        superView?.backgroundColor = UIColor.white
        
        superView?.addSubview(descriptionTextView)
        
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        // set style
        toolBar.barStyle = .default
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let barButtonItems = [ flexBarButton, doneBarButton ]
        
        toolBar.items = barButtonItems;
//        descriptionTextView.inputAccessoryView = toolBar
        
        view.setNeedsUpdateConstraints()
        
    }
    
    // MARK: - Public
    func setCurSale(_ sale: SaleModel) {
        
        self.currentSale = sale
    }


    // MARK: - Actions
    
    
    func saveButtonTapped(sender: Any) {
        
        Global.showWithStatus(status: "Updating...")
        
        let parameters : Parameters = ["id": currentSale.id,
                                       "company": currentSale.company,
                                       "description": currentSale.description,
                                       "title": currentSale.title,
                                       "starts_at": currentSale.starts_at,
                                       "finishes_at": currentSale.finishes_at
                                       ]
        
        APIManager.updateExistingSale(params: parameters) { (success) in
            
            Global.hideProgress()
            if success {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSales), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSaleOverview), object: self.currentSale)
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func done() {
        
        descriptionTextView.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
