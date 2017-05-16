//
//  CreateSaleVC.swift
//  pickary
//
//  Created by Dan on 10/20/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class CreateSaleVC: UIViewController {
    
    //UI
    
    let tempLabel = UILabel()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Sale Name"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        return label
    }()
    
    
    let startDateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Start Date"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        return label

    }()
    let finishDateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "End Date"
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        label.textColor = UIColor.black
        return label
    }()
    
    let lineView1 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let lineView2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()

    let lineView3 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let tapGesture: UITapGestureRecognizer = {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
        gesture.numberOfTapsRequired = 1
        return gesture
    }()


    let titleTxtField = UITextField()
    let startDateTxtField = UITextField()
    let finishDateTxtField = UITextField()
    
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnTapped))
    
    //
    
    private var didSetupConstraints = false

    
    var currentSale: SaleModel! {
        
        willSet {
            
        }
        
        didSet {
            
            titleTxtField.text = currentSale.title
            startDateTxtField.text = currentSale.starts_at
            finishDateTxtField.text = currentSale.finishes_at
        }
    }
    
    var saleArray: [SaleModel] = []
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var aSale = SaleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initialize()
        
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            nameLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(10)
                make.top.equalToSuperview().inset(100)
            })
            
            lineView1.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview().inset(10)
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.height.equalTo(1)
            })

            lineView2.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview().inset(10)
                make.top.equalTo(lineView1.snp.bottom).offset(50)
                make.height.equalTo(1)
            })
            
            startDateLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(20)
                make.top.equalTo(lineView2.snp.bottom).offset(8)
            })
            
            startDateTxtField.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(startDateLabel.snp.centerY)
            })

            titleTxtField.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(nameLabel.snp.centerY)
                make.width.equalTo(startDateTxtField.snp.width)
                make.height.equalTo(startDateTxtField.snp.height)
            })

            lineView3.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview().inset(10)
                make.top.equalTo(startDateLabel.snp.bottom).offset(8)
                make.height.equalTo(1)
            })
            
            finishDateLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(20)
                make.top.equalTo(lineView3.snp.bottom).offset(8)
            })

            finishDateTxtField.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(finishDateLabel.snp.centerY)
            })

            didSetupConstraints = true

        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Private
    
    private func initialize() {
        
        
        self.title = "Sale Info"
        
        let superView = self.view
        superView?.backgroundColor = UIColor.white
        
        superView?.addSubview(tempLabel)
        superView?.addSubview(nameLabel)
        superView?.addSubview(lineView1)
        superView?.addSubview(titleTxtField)
        
        superView?.addSubview(lineView2)
        superView?.addSubview(startDateLabel)
        superView?.addSubview(startDateTxtField)
        
        superView?.addSubview(lineView3)
        superView?.addSubview(finishDateLabel)
        
        superView?.addSubview(finishDateTxtField)

        
        
        self.view.isUserInteractionEnabled = true
        titleTxtField.delegate = self
        startDateTxtField.delegate = self
        finishDateTxtField.delegate = self
        titleTxtField.backgroundColor = UIColor.lightText
        startDateTxtField.placeholder = Global.getDateStringFromDate(Date())
        finishDateTxtField.placeholder = Global.getDateStringFromDate(Date())
        self.view.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.saleArray  = appDel.gSaleListArray

        
    }

    //Make the sure if the sale is existing one.
    
    private func saleIfExist() ->Bool {
        
        for sale in self.saleArray {
            
            if self.currentSale.id == sale.id {
                
            }
        }
        
        
        return true
    }
    
    // MARK: - Actions
    
    func saveBtnTapped(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        if titleTxtField.text == "" || startDateTxtField.text == "" || finishDateTxtField.text == "" {
            appDel.showAlert(title: "Alert", message: "Please enter the empty field!", vc: self)
            return
        }
        
        aSale.company = "acme"
        aSale.id = "ca6601aa-4dc6-4832-a35f-aa5a942664b5"
        
        aSale.title = titleTxtField.text!
        aSale.starts_at = startDateTxtField.text!
        aSale.finishes_at = finishDateTxtField.text!
        
        addSaleToAPI()

    }
    
    
    func onBackgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        startDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    func handleFinishDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        finishDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    func addSaleToAPI() {
        
        Global.show()
        let parameters : Parameters = ["id": aSale.id,
                                       "company": aSale.company,
                                       "title": aSale.title,
                                       "starts_at": aSale.starts_at,
                                       "finishes_at": aSale.finishes_at]
        
        APIManager.addSalePickary(params: parameters) { (success) in
            
            Global.hideProgress()
            if success {
                
                self.appDel.gSaleListArray.append(self.aSale)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSales), object: nil)
                let _ = self.navigationController?.popViewController(animated: true)

                
                
            }
            else {
                self.appDel.showAlert(title: "Fail", message: "failed to add a sale", vc: self)
            }
        }
    }
    
    //MARK: - Public
    
    
    
}

extension CreateSaleVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTxtField {
            startDateTxtField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField != titleTxtField {
            
            if textField == startDateTxtField {
                
                let datePickerView: UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(CreateSaleVC.handleStartDatePicker(_:)), for: UIControlEvents.valueChanged)

            }else if textField == finishDateTxtField {
                
                let datePickerView: UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(CreateSaleVC.handleFinishDatePicker(_:)), for: UIControlEvents.valueChanged)
            }
            
            
        }
        

    }
}
