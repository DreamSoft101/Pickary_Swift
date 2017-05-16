//
//  SaleOverviewVC.swift
//  pickary
//
//  Created by Mobile Developer on 11/15/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import Alamofire

enum Tag: Int {
    
    case nameTag = 10, descriptionTag = 11, startDateTag = 12, endDateTag = 13
}

class SaleOverviewVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    let appDel = UIApplication.shared.delegate as! AppDelegate
    var activeField: UITextField?
    var activeTextView: UITextView?
    var tempSale: SaleModel!
    
    var isTextFieldEditing = true

    public var isCreateMode: Bool!
    
    private var didSetupConstraints = false

    var overviewTableView =  UITableView()
    
    var startDatePicker: UIDatePicker = {
       
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        return datePickerView
    }()
    var endDatePicker: UIDatePicker = {
        

        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        return datePickerView

    }()
    
    
    
    var bottomView : UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()

    let pictureBtn: UIButton = {
       
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Pictures", for: .normal)
    
        return button
    }()

    let catalogueBtn: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Catalogue", for: .normal)
        
        return button
    }()
    
    var curSale: SaleModel! {
        
        didSet{
            
//            self.overviewTableView.reloadData()
        }
    }
    
    var toolBar:UIToolbar!
    
    
    
    var tempDateField : UITextField!
    
    ///////////////
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()
        NotificationCenter.default.addObserver(self, selector: #selector(saveSaleInfo), name: NSNotification.Name(rawValue:kNotificationSubmitSaleInfo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSaleInfo(_:)), name: NSNotification.Name(rawValue: kNotificationReloadSaleOverview), object: nil)

        view.setNeedsUpdateConstraints()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        overviewTableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            bottomView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50)
            })

            overviewTableView.snp.makeConstraints({ (make) in
                
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top)
            })
            
            pictureBtn.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.centerY.equalToSuperview()
            })
            
            catalogueBtn.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)
                make.centerY.equalToSuperview()
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    // MARK: - Private
    
    //initialize
    
    private func initialize() {
        
        self.title = "Sale Overview"
        
        let superView = self.view
        
        superView?.addSubview(overviewTableView)
        superView?.addSubview(bottomView)
        bottomView.addSubview(pictureBtn)
        bottomView.addSubview(catalogueBtn)
        
        ///// ***** Register TableView ******//////
        print(String(describing: SaleNameCell.self))
        
        
        overviewTableView.delegate = self
        overviewTableView.dataSource = self
        
        overviewTableView.rowHeight = UITableViewAutomaticDimension
        overviewTableView.estimatedRowHeight = 100

        // Name Cell
        overviewTableView.register(SaleNameCell.self, forCellReuseIdentifier: "SaleNameCell")
        // Direction Title Cell
        overviewTableView.register(SaleDirectionTitleCell.self, forCellReuseIdentifier: String(describing: SaleDirectionTitleCell.self))
         //Direction description Cell
        overviewTableView.register(SaleDirectionDescriptionCell.self, forCellReuseIdentifier: String(describing: SaleDirectionDescriptionCell.self))
        
         //Date Cell
        overviewTableView.register(SaleDateCell.self, forCellReuseIdentifier: String(describing: SaleDateCell.self))
        overviewTableView.separatorStyle = .none

        pictureBtn.addTarget(self, action: #selector(SaleOverviewVC.pictureButtonTapped), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(sender:)))
        
        //Add Tool bar for Textview
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        // set style
        toolBar.barStyle = .default
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let barButtonItems = [cancelButton, flexBarButton, doneBarButton ]
        
        toolBar.items = barButtonItems;

    }
    
    // MARK: - Keyboard notification
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        
        var info = (notification as NSNotification).userInfo!
        
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size, contentInsets = UIEdgeInsets(top: 64, left: 0, bottom: kbSize.height, right: 0)
        
        self.overviewTableView.contentInset = contentInsets
        self.overviewTableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height + toolBar.frame.size.height
        
        if isTextFieldEditing == true {
            let pointInTable = activeField!.superview!.convert(activeField!.frame.origin, to: self.overviewTableView)
            let rectInTable = activeField!.superview!.convert(activeField!.frame, to: self.overviewTableView)
            
            if !aRect.contains(pointInTable) {
                self.self.overviewTableView.scrollRectToVisible(rectInTable, animated: true)
            }
        }else {
            
            let point = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.origin.y + activeTextView!.frame.size.height)
            let pointInTable = activeTextView!.superview!.convert(point, to: self.overviewTableView)
            let rectInTable = activeTextView!.superview!.convert(activeTextView!.frame, to: self.overviewTableView)
            if !aRect.contains(pointInTable) {
                self.self.overviewTableView.scrollRectToVisible(rectInTable, animated: true)
            }
        }
        
        
//        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(curve)), animations: {
//            
//            self.overviewTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardTop * 0.6, 0)
//            
//        }) { (finished) in
//            
//        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        let contentInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.overviewTableView.contentInset = contentInsets
        self.overviewTableView.scrollIndicatorInsets = contentInsets
    }

    // Submit Sale Info
    
    func saveSaleInfo() {
        
        if self.isCreateMode == true {
            
            if self.curSale != nil {
                
                if curSale.title.characters.count != 0 &&
                    curSale.starts_at.characters.count != 0 &&
                    curSale.finishes_at.characters.count != 0 {
                    
                    Global.show()
                    var parameters : Parameters = [
                        
                        "title": curSale.title,
                        "starts_at": curSale.starts_at,
                        "finishes_at": curSale.finishes_at,
                        "description": curSale.descriptions]
                    
                    if self.curSale.location != nil {
                        
                        parameters["location"] = self.curSale.location
                        
                    }else {
                        
                        
                    }
                    
                    APIManager.addSalePickary(params: parameters) { (success) in
                        
                        Global.hideProgress()
                        if success {
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSales), object: nil)
                            let _ = self.navigationController?.popViewController(animated: true)
                            
                        }
                        else {
                            self.appDel.showAlert(title: "Fail", message: "failed to add a sale", vc: self)
                        }
                    }
                    
                }else {
                    
                    Global.showAlertViewController(title: "Error", message: "Please input the blank fields.", target: self)
                    
                }
                
            }else {
                
                Global.showAlertViewController(title: "Error", message: "Please input all fields.", target: self)
            }
            
            
            
            
        }else {
            
            Global.showWithStatus(status: "Updating...")
            
            //        let par: Parameters = ["street_address":"1212 N Hoyne", "city":"Chicago", "state":"IL", "postal_code":"60622"]
            var parameters : Parameters = ["id": curSale.id,
                                           "company": curSale.company,
                                           "description": curSale.descriptions,
                                           "title": curSale.title,
                                           "starts_at": curSale.starts_at,
                                           "finishes_at": curSale.finishes_at
            ]
            
            if self.curSale.location != nil {
                
                parameters["location"] = self.curSale.location
            }else {
                
                
            }
            
            APIManager.updateExistingSale(params: parameters) { (success) in
                
                Global.hideProgress()
                
                if success {
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSales), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationReloadSaleOverview), object: self.curSale)
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    
    // MARK: - Actions
    
    func done() {
        
        
        if self.activeField?.tag == Tag.startDateTag.rawValue {
            
            self.handleStartDatePicker(startDatePicker)
            
        }else if self.activeField?.tag == Tag.endDateTag.rawValue {
            
           self.handleFinishDatePicker(endDatePicker)
        }
        self.view.endEditing(true)

        self.overviewTableView.reloadData()
        
    }
    
    func cancelClick() {
        
        self.view.endEditing(true)
    }
    
    func saveButtonTapped(sender: Any) {
        
        
        self.view.endEditing(true)
        
        self.saveSaleInfo()
    }
    
    @objc private func pictureButtonTapped(sender: UIButton?){
        
        let cameraVC = CameraViewController()
        
        
        let nav = UINavigationController(rootViewController: cameraVC)
        nav.isNavigationBarHidden = true
        
        self.navigationController?.present(nav, animated: true, completion: { 
            
        })
        
    }
    
    func handleStartDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        print(dateFormatter.string(from: sender.date))
        
        if self.curSale.finishes_at.characters.count != 0 {
            
            if sender.date > Global.getDateFromString(self.curSale.finishes_at) {
                
                Global.showAlertViewController(title: "Error", message: "The End Date occurs before the Start Date.", target: self)
                
                return
            }
            
        }
        self.curSale.starts_at = dateFormatter.string(from: sender.date)

    }
    
    func handleFinishDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
        
        
        if self.curSale.starts_at.characters.count != 0 {
            
            if sender.date < Global.getDateFromString(self.curSale.starts_at) {
                
                Global.showAlertViewController(title: "Error", message: "The End Date occurs before the Start Date.", target: self)
                
                return
            }

        }
        
        self.curSale.finishes_at = dateFormatter.string(from: sender.date)
        
       
    }

    // MARK: - Public
    func setCurrentSale(_ sale: SaleModel?) {
        
        self.curSale = sale
        
        if self.curSale == nil {
            
            tempSale = SaleModel()
        }

        self.overviewTableView.reloadData()

        
    }
    
    func reloadSaleInfo(_ notification: Notification) {
        
        if let sale = notification.object as? SaleModel {
            
            self.curSale = sale
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
    
    func goSaleDescriptionVC() {
        
        
        if self.curSale == nil {
            
            self.curSale = SaleModel()
        }

        let vc = SaleAdditionalDirectionVC()
        vc.setCurSale(curSale)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        self.activeField = textField
        self.isTextFieldEditing = true
        
        if self.curSale == nil {
            
            self.curSale = SaleModel()
        }

        if textField.tag == Tag.startDateTag.rawValue {
            
            if textField.text?.characters.count != 0 {
                
                let date = Global.getDateFromString(textField.text!)
                
                startDatePicker.setDate(date, animated: true)
            }
            textField.inputView = startDatePicker
            textField.inputAccessoryView = self.toolBar
            
        }else if textField.tag == Tag.endDateTag.rawValue {
            
            if textField.text?.characters.count != 0 {
                
                let date = Global.getDateFromString(textField.text!)
                
                endDatePicker.setDate(date, animated: true)
            }
            textField.inputView = endDatePicker
            textField.inputAccessoryView = self.toolBar
        }
        
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.activeField = nil
        if self.curSale == nil {
            
            self.curSale = SaleModel()
        }
        
        switch textField.tag {
        case Tag.nameTag.rawValue:
            self.curSale.title = textField.text!
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - UITextView Delegate
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.activeTextView = textView
        self.isTextFieldEditing = false
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.activeTextView = nil
        if self.curSale == nil {
            
            self.curSale = SaleModel()
        }
        
        if textView.tag == Tag.descriptionTag.rawValue {
            
            self.curSale.descriptions = textView.text!
        }
        
    }

}

extension SaleOverviewVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        
        
        switch indexPath.row {
        case 0:
            
            let _cell = tableView.dequeueReusableCell(withIdentifier: "SaleNameCell", for: indexPath) as! SaleNameCell
            
            if self.curSale != nil {
                _cell.setCurrentSale(sale: self.curSale)
            }
            _cell.saleNameTextField.tag = Tag.nameTag.rawValue
            _cell.saleNameTextField.delegate = self
            _cell.saleNameTextField.placeholder = "Name"
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            break
        case 1:
            let _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaleNameCell.self), for: indexPath) as! SaleNameCell
            _cell.titleLabel.text = "Location"
            _cell.saleNameTextField.isEnabled = false
            _cell.saleNameTextField.placeholder = "Location"

            _cell.saleNameTextField.font = UIFont.systemFont(ofSize: 13)

            if self.curSale != nil {
                
                if self.curSale.location != nil {
                    
                    var address = ""
                    
                    if self.curSale.locationModel?.street_address.characters.count != 0 {
                        
                        address = (self.curSale.locationModel?.street_address)!
                    }
                    
                    if self.curSale.locationModel?.city.characters.count != 0 {
                        
                        address = address.appending(", \((self.curSale.locationModel?.city)!)")
                    }
                    
                    if self.curSale.locationModel?.state.characters.count != 0 {
                        
                        address = address.appending(", \((self.curSale.locationModel?.state)!)")
                    }
                    
                    if self.curSale.locationModel?.postal_code.characters.count != 0 {
                        
                        address = address.appending(", \((self.curSale.locationModel?.postal_code)!)")
                    }
                    
                    
                    _cell.saleNameTextField.text = address
                }

            }
            
            _cell.lineView.isHidden = true;
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            
            break
        case 2:
            let _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaleDirectionTitleCell.self), for: indexPath) as! SaleDirectionTitleCell
            _cell.accessoryType = .disclosureIndicator
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            break
        case 3:
            let _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaleDirectionDescriptionCell.self), for: indexPath) as! SaleDirectionDescriptionCell
            if self.curSale != nil {
                
                _cell.setCurrentSale(sale: self.curSale)
            }
            _cell.descriptionTextView.tag = Tag.descriptionTag.rawValue
            _cell.descriptionTextView.delegate = self
            _cell.descriptionTextView.inputAccessoryView = self.toolBar
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell

            break
        case 4:
            let _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaleDateCell.self), for: indexPath) as! SaleDateCell
            _cell.titleLabel.text = "Start Date"
            
            if self.curSale != nil {
                
                _cell.dateTextField.text = self.curSale.starts_at
                
            }else {
                
            }
            _cell.dateTextField.tag = Tag.startDateTag.rawValue
            _cell.dateTextField.placeholder = Global.getDateStringFromDate(Date())
            _cell.dateTextField.delegate = self

            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            break
        case 5:
            let _cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaleDateCell.self), for: indexPath) as! SaleDateCell
            
            _cell.titleLabel.text = "End Date"
            
            if self.curSale != nil {
                
              _cell.dateTextField.text = self.curSale.finishes_at
            }else {
                
            }
            _cell.dateTextField.tag = Tag.endDateTag.rawValue
            _cell.dateTextField.delegate = self
            _cell.dateTextField.placeholder = Global.getDateStringFromDate(Date())
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            
            break
        case 1:
            
            if self.curSale == nil {
                
                self.curSale = SaleModel()
            }

            let vc = SaleAddressEditVC()
            vc.setCurSale(self.curSale)
            self.navigationController?.pushViewController(vc, animated: true)

            break
        case 2:
            
            self.goSaleDescriptionVC()

            break
        case 3:

            break
        case 4:
            
            break
        case 5:
            
            break
        default:
            break
            
            
        }

        
    }
}

