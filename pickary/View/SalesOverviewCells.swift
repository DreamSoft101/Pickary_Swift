//
//  SalesOverviewCells.swift
//  pickary
//
//  Created by Mobile Developer on 11/15/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SnapKit


class SaleNameCell: UITableViewCell {

    var didSetupConstraints = false;

    var titleLabel :UILabel = {
       
        let label = UILabel()
        
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: kAppTitleLabelFontSize)
        label.text = "Sale Title"
        
        return label
    }()
    
    var saleNameTextField: UITextField = {
       
        let textField = UITextField()
        
        textField.textColor = UIColor.black
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        return textField

    }()
    
    var lineView: UIView = {
       
        let line = UIView()
        
        line.backgroundColor = UIColor.groupTableViewBackground
        
        return line
        
    }()
    
    var currentSale: SaleModel! {
        
        didSet{
            
            print(currentSale.title)
            self.saleNameTextField.text = currentSale.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
        
            titleLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.top.equalToSuperview().inset(kLabelVerticalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)
            })
            
            saleNameTextField.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)

                make.top.equalTo(titleLabel.snp.bottom).offset(kLabelVerticalInsets + 5)
            })
            
            lineView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kOffsetLineView)
                make.trailing.equalToSuperview().inset(kOffsetLineView)
                make.top.equalTo(saleNameTextField.snp.bottom).offset(kSpaceBetweenControls + 5)
                make.bottom.equalToSuperview().inset(0)
                make.height.equalTo(kHeightOfLineView)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(saleNameTextField)
        self.contentView.addSubview(lineView)
       
    }
    
    // MARK: - Public
    
    func setCurrentSale(sale: SaleModel?){
        
        self.currentSale = sale
    }

}

class SaleAddressCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func updateConstraints() {
        
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
    }

}

class SaleDirectionTitleCell: UITableViewCell {
    
    var didSetupConstraints = false;

    var titleLabel: UILabel = {
       
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "Additional Directions"
        label.font = UIFont.boldSystemFont(ofSize: kAppTitleLabelFontSize)
        return label
    }()
    
    var lineView: UIView = {
        
        let line = UIView()
        
        line.backgroundColor = UIColor.groupTableViewBackground
        
        return line
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            titleLabel.snp.makeConstraints { (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)

                make.centerY.equalToSuperview()
            }
            
            lineView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kOffsetLineView)
                make.trailing.equalToSuperview().inset(kOffsetLineView)
                make.bottom.equalToSuperview().inset(0)
                make.height.equalTo(kHeightOfLineView)
            })
            
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lineView)
    }

}

class SaleDirectionDescriptionCell: UITableViewCell {
    
    var currentSale: SaleModel! {
        
        didSet{
            
            self.descriptionTextView.text = currentSale.descriptions
        }
    }

    var didSetupConstraints = false;

    var titleLabel :UILabel = {
        
        let label = UILabel()
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: kAppTitleLabelFontSize)
        label.text = "Description"
        
        return label
    }()
    
    var lineView: UIView = {
        
        let line = UIView()
        
        line.backgroundColor = UIColor.groupTableViewBackground
        
        return line
        
    }()

    var descriptionTextView: UITextView = {
       
        let textView = UITextView()
        
        textView.textColor = UIColor.black
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        
        return textView

    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            titleLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)

                make.top.equalToSuperview().inset(kLabelVerticalInsets)
            })
            
            descriptionTextView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)
                make.height.equalTo(100)
                make.top.equalTo(titleLabel.snp.bottom).offset(kSpaceBetweenControls + 5)
            })
            
            lineView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kOffsetLineView)
                make.trailing.equalToSuperview().inset(kOffsetLineView)
                make.top.equalTo(descriptionTextView.snp.bottom).offset(kSpaceBetweenControls + 5)
                make.bottom.equalToSuperview().inset(0)
                make.height.equalTo(kHeightOfLineView)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
//        descriptionTextView.textContainerInset = UIEdgeInsetsMake(0, -10, 0, 0)
        descriptionTextView.textContainer.lineFragmentPadding = 0
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionTextView)
        self.contentView.addSubview(lineView)
    }
    
    // MARK: - Public
    
    func setCurrentSale(sale: SaleModel?){
        
        self.currentSale = sale
    }


}

class SaleDateCell: UITableViewCell {
    
    var currentSale: SaleModel!

    var didSetupConstraints = false;

    
    var titleLabel :UILabel = {
        
        let label = UILabel()
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: kAppTitleLabelFontSize)
        label.textAlignment = .left
        
        return label
    }()
    
    var lineView: UIView = {
        
        let line = UIView()
        
        line.backgroundColor = UIColor.groupTableViewBackground
        
        return line
        
    }()

    var dateTextField : UITextField = {
        
        let textField = UITextField()
        
        textField.textColor = UIColor.black
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: kAppTextFieldFontSize)
        return textField

    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            titleLabel.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kLabelHorizontalInsets)
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)

                make.top.equalToSuperview().inset(kLabelVerticalInsets)
            })
            
            dateTextField.snp.makeConstraints({ (make) in
                
                make.trailing.equalToSuperview().inset(kLabelHorizontalInsets)
                make.height.equalTo(40)
                make.centerY.equalTo(titleLabel.snp.centerY)
            })

            lineView.snp.makeConstraints({ (make) in
                
                make.leading.equalToSuperview().inset(kOffsetLineView)
                make.trailing.equalToSuperview().inset(kOffsetLineView)
                make.top.equalTo(dateTextField.snp.bottom).offset(kSpaceBetweenControls + 5)
                make.bottom.equalToSuperview().inset(0)
                make.height.equalTo(kHeightOfLineView)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
//        dateTextField.isEnabled = false
        dateTextField.textAlignment = .right
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateTextField)
        self.contentView.addSubview(lineView)

    }
    
    // MARK: - Public
    
    func setCurrentSale(sale: SaleModel){
        
        self.currentSale = sale
    }


    
}
