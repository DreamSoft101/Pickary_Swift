//
//  SaleListTVCell.swift
//  pickary
//
//  Created by Dan on 10/20/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SnapKit

class SaleListTVCell: UITableViewCell {
    
    
    var didSetupConstraints = false;
    
    let titleLabel : UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        return label

    }()
    let startDateLabel : UILabel = {
    
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        return label
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
                
                make.leading.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            
            
            startDateLabel.snp.makeConstraints { (make) in
                
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }

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
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        
        startDateLabel.lineBreakMode = .byTruncatingTail
        startDateLabel.numberOfLines = 1
        startDateLabel.textAlignment = .left
        startDateLabel.textColor = UIColor.black
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(startDateLabel)
    }
    
    func refreshLayout(){
        
       
    }
    
    private func initialize(){
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        titleLabel.textColor = UIColor.blue
        startDateLabel.textColor = UIColor.black

    }

}
