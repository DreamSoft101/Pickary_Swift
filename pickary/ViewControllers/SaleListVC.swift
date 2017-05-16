//
//  SaleListVC.swift
//  pickary
//
//  Created by Dan on 10/20/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SnapKit

class SaleListVC: UIViewController {
    
    @IBOutlet weak var saleListTableView: UITableView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    //UI
    var saleListTblView: UITableView  = {
        
        var tableView = UITableView(frame: .zero, style: .grouped)
        
        return tableView;
    }()
    var bottomView = UIView()
    let newSaleBtn = UIButton(type: UIButtonType.custom)
    
    
    //
    private var didSetupConstraints = false
    var futureSaleList = [SaleModel]()
    var pastSaleList = [SaleModel]()

    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialize()

        view.setNeedsUpdateConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSaleListFromAPI), name: NSNotification.Name(rawValue: kNotificationReloadSales), object: nil)
        getSaleListFromAPI()

    }

    override func viewWillAppear(_ animated: Bool) {
//        saleList = appDel.gSaleListArray
//        saleListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        
        
        if (!didSetupConstraints) {
            
            
            bottomView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(50)
            })

            
            saleListTblView.snp.makeConstraints { (make) in
                
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top)
            }
            
            //            
            
            newSaleBtn.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
        
    }
    
    private func initialize() {
        
        
        self.title = "Sale List"
        
        let superView = self.view
        
        superView?.addSubview(saleListTblView)
        superView?.addSubview(bottomView)
        bottomView.addSubview(newSaleBtn)
        bottomView.backgroundColor = UIColor.gray

        // Register TableView
        saleListTblView.register(SaleListTVCell.self, forCellReuseIdentifier: "SaleListTVCell")

        saleListTblView.rowHeight = UITableViewAutomaticDimension
        saleListTblView.estimatedRowHeight = 44
        saleListTblView.delegate = self
        saleListTblView.dataSource = self
        
        
        newSaleBtn.setTitle("New Sale", for: .normal)
        newSaleBtn.addTarget(self, action: #selector(SaleListVC.goToRegisterSaleVC), for: .touchUpInside)
        
        
    }
    
    
    func getSaleListFromAPI() {
        
        Global.showWithStatus(status: "Loading...")
        APIManager.getSaleListPickary { (success) in
            
            Global.hideProgress()
            if success {
                
                
                self.showSaleList()
                
            }
            else {
                self.appDel.showAlert(title: "Fail", message: "failed to get sale list", vc: self)
            }
        }
    }
    
    //Show Sale List
    
    func showSaleList() {
        
        let newArray = Global.getSortedArray(self.appDel.gSaleListArray)
        self.futureSaleList = newArray.0
        self.pastSaleList = newArray.1
        self.saleListTblView.reloadData()
    }
    
    // Actions
    @IBAction func onNewSale(_ sender: UIBarButtonItem) {
        let saleOverviewVC = SaleOverviewVC()
        
        
        self.navigationController?.pushViewController(saleOverviewVC, animated: true)
    }

    @objc private func goToRegisterSaleVC(sender: UIButton) {
        
        let saleOverviewVC = SaleOverviewVC()
        saleOverviewVC.isCreateMode = true
        saleOverviewVC.setCurrentSale(nil)
        self.navigationController?.pushViewController(saleOverviewVC, animated: true)
    }

}

extension SaleListVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.futureSaleList.count
        case 1:
            return self.pastSaleList.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        
        if indexPath.section == 0 {
            
            let _cell = tableView.dequeueReusableCell(withIdentifier: "SaleListTVCell", for: indexPath) as! SaleListTVCell
            _cell.titleLabel.text = futureSaleList[indexPath.row].title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
            let dateObject = dateFormatter.date(from: futureSaleList[indexPath.row].starts_at)
            dateFormatter.dateFormat = "MM/dd/yy"
            _cell.startDateLabel.text = dateFormatter.string(from: dateObject!)
            
            //Make sure the constraints have been added to this cell, since it may have just been created from scratch
            
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell
            
        }else {
            
            let _cell = tableView.dequeueReusableCell(withIdentifier: "SaleListTVCell", for: indexPath) as! SaleListTVCell
            _cell.titleLabel.text = pastSaleList[indexPath.row].title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm"
            let dateObject = dateFormatter.date(from: pastSaleList[indexPath.row].starts_at)
            dateFormatter.dateFormat = "MM/dd/yy"
            _cell.startDateLabel.text = dateFormatter.string(from: dateObject!)
            
            //Make sure the constraints have been added to this cell, since it may have just been created from scratch
            
            _cell.setNeedsUpdateConstraints()
            _cell.updateConstraintsIfNeeded()
            cell = _cell

        }
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        var sale: SaleModel!

        if indexPath.section == 0 {
            
            sale = futureSaleList[indexPath.row]
        }else {
            sale = pastSaleList[indexPath.row]
        }
        
        let saleOverviewVC = SaleOverviewVC()
        saleOverviewVC.setCurrentSale(sale)     
        saleOverviewVC.isCreateMode = false

        
        self.navigationController?.pushViewController(saleOverviewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Upcoming/Current Sales"
            
        case 1:
            return "Past Sales"
        default:
            break
        }
        
        return ""
    }
}

