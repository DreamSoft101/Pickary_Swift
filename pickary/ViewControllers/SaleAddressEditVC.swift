//
//  SaleAddressEditVC.swift
//  pickary
//
//  Created by Mobile Developer on 11/15/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import MHTextField

class SaleAddressEditVC: UIViewController, UITextFieldDelegate {

    
    private var didSetupConstraints = false
    
    
    //UI
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let streetLabel1: UILabel = {
        
        let label = UILabel()
        
        label.text = "Street Address"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        return label
        
    }()
    
    let streetTextField1: MHTextField = {
        
        let txtField = MHTextField()
        txtField.borderStyle = .none
        txtField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        txtField.placeholder = "Street Address"
        txtField.required = true

        
        return txtField
    }()
    
    let streetLabel2: UILabel = {
        
        let label = UILabel()
        
        label.text = "Street 2 (optional)"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        return label
        
    }()
    
    let streetTextField2: MHTextField = {
        
        let txtField = MHTextField()
        txtField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        txtField.placeholder = "Street 2"
        txtField.borderStyle = .none

        return txtField
    }()

    
    let cityLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        return label
        
    }()
    
    let cityTextField: MHTextField = {
        
        let txtField = MHTextField()
        txtField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        txtField.placeholder = "City"
        txtField.required = true
        txtField.borderStyle = .none

        return txtField
    }()

    
    let stateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "State"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        return label
        
    }()

    let stateTextField: MHTextField = {
        
        let txtField = MHTextField()
        txtField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        txtField.placeholder = "State"
        txtField.borderStyle = .none
        txtField.required = true


        return txtField
    }()

    let zipcodeLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Postal Code"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        return label
        
    }()
    
    let zipcodeTextField: MHTextField = {
        
        let txtField = MHTextField()
        txtField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        txtField.placeholder = "Postal Code"
        txtField.borderStyle = .none
        txtField.keyboardType = .numberPad
        txtField.required = true

        return txtField
    }()

    //
    
    var currentSale: SaleModel! {
        
        willSet {
            
        }
        
        didSet {
            
      
        }
    }

    
    //
    
    
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
            
            
            scrollView.snp.makeConstraints({ (make) in
                
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            })
            
            
            streetLabel1.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)

                make.top.equalTo(scrollView).inset(kLabelVerticalInsets)
            })
            
            streetTextField1.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.top.equalTo(streetLabel1.snp.bottom).offset(kLabelVerticalInsets)
                make.width.equalTo(self.view.frame.size.width - 2*kLabelHorizontalInsets)
//                make.height.equalTo(kHeightOfLineView)
            })
            
//            streetLabel2.snp.makeConstraints({ (make) in
//                
//                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
//                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
//                make.top.equalTo(streetTextField1.snp.bottom).offset(kLabelVerticalInsets)
//            })
//            
//            streetTextField2.snp.makeConstraints({ (make) in
//                
//                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
//                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
//                make.width.equalTo(self.view.frame.size.width - 2*kLabelHorizontalInsets)
//
//                make.top.equalTo(streetLabel2.snp.bottom).offset(kLabelVerticalInsets)
//            })
            
            cityLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)

                make.top.equalTo(streetTextField1.snp.bottom).offset(kLabelVerticalInsets)
            })
            
            cityTextField.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.top.equalTo(cityLabel.snp.bottom).offset(kLabelVerticalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.width.equalTo(self.view.frame.size.width - 2*kLabelHorizontalInsets)

            })
            
            stateLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                
                make.top.equalTo(cityTextField.snp.bottom).offset(kLabelVerticalInsets)
            })
            
            stateTextField.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.top.equalTo(stateLabel.snp.bottom).offset(kLabelVerticalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.width.equalTo(self.view.frame.size.width - 2*kLabelHorizontalInsets)

            })
            
            zipcodeLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                
                make.top.equalTo(stateTextField.snp.bottom).offset(kLabelVerticalInsets)
            })
            
            zipcodeTextField.snp.makeConstraints({ (make) in
                
                make.leading.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.top.equalTo(zipcodeLabel.snp.bottom).offset(kLabelVerticalInsets)
                make.trailing.equalTo(scrollView).inset(kLabelHorizontalInsets)
                make.bottom.equalTo(scrollView).inset(kLabelVerticalInsets)
                make.width.equalTo(self.view.frame.size.width - 2*kLabelHorizontalInsets)

            })
            
            didSetupConstraints = true
            
        }
        
        super.updateViewConstraints()
    }

    // MARK: - Private
    
    private func initialize() {
        
        
        self.title = "Sale Location"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(sender:)))
        
        let superView = self.view
        superView?.backgroundColor = UIColor.white
        
       superView?.addSubview(scrollView)
        
        
        scrollView.addSubview(streetLabel1)
        scrollView.addSubview(streetTextField1)
//        scrollView.addSubview(streetLabel2)
//        scrollView.addSubview(streetTextField2)
        scrollView.addSubview(cityLabel)
        scrollView.addSubview(cityTextField)
        scrollView.addSubview(stateLabel)
        scrollView.addSubview(stateTextField)
        scrollView.addSubview(zipcodeLabel)
        scrollView.addSubview(zipcodeTextField)
        
        
        for subView in scrollView.subviews {
            
            if subView.isKind(of: MHTextField.self) {
                
                let textField = subView as! MHTextField
                
                textField.delegate = self
            }
        }

        view.setNeedsUpdateConstraints()
        
        
    }
    
    // MARK: - Public
    func setCurSale(_ sale: SaleModel) {
        
        self.currentSale = sale
        
        if self.currentSale != nil {
            
            self.showLocationInfo()
        }
    }

    func showLocationInfo() {
        
        if self.currentSale.location != nil {
            
            streetTextField1.text = self.currentSale.locationModel?.street_address
            cityTextField.text = self.currentSale.locationModel?.city
            stateTextField.text = self.currentSale.locationModel?.state
            zipcodeTextField.text = self.currentSale.locationModel?.postal_code
        }
    }

    //Validate
    
    func isValid() ->Bool {
        
        for subView in scrollView.subviews {
            
            if subView.isKind(of: MHTextField.self) {
                
                let textField = subView as! MHTextField
                
                if textField.validate() == false {
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - Actions 
    
    func saveButtonTapped(sender: Any) {
        
        self.currentSale.location = ["street_address":streetTextField1.text!, "city": cityTextField.text!, "state": stateTextField.text!, "postal_code":zipcodeTextField.text!]
        
        print(self.currentSale.location)
        
        if currentSale.title.characters.count != 0 &&
            currentSale.starts_at.characters.count != 0 &&
            currentSale.finishes_at.characters.count != 0 {
        
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNotificationSubmitSaleInfo), object: self.currentSale)
            
            //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSaleOverview), object: self.currentSale)
            let _ = self.navigationController?.popViewController(animated: true)
        }else {
            
            let _ = self.navigationController?.popViewController(animated: true)

            Global.showAlertViewController(title: "Error", message: "You have to add title, date first to create a sale.", target: self)

        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITextField Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
