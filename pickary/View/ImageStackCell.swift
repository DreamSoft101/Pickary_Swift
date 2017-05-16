//
//  ImageStackCell.swift
//  pickary
//
//  Created by Mobile Developer on 12/23/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit

@objc protocol ImageStackCellDelegate {
    
    func removeCurrentPhoto(_ row: NSInteger)
    
}
class ImageStackCell: UICollectionViewCell {
    
    var currentRow: NSInteger!
    lazy var imageView = UIImageView()
    lazy var closeButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        return button
    }()
    
    var delegate: ImageStackCellDelegate?
    
    var didSetupConstraints = false;
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        isAccessibilityElement = true
        accessibilityLabel = "Photo"
        
        setupViews()
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setupViews()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            imageView.snp.makeConstraints { (make) in
                
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            closeButton.snp.makeConstraints({ (make) in
                
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(20)
            })
                        
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
        contentView.addSubview(imageView)
        contentView.addSubview(closeButton)
        
        imageView.image = UIImage(named: "placeholder")
        closeButton.contentMode = .scaleAspectFill
        closeButton.isHidden = true
        closeButton.addTarget(self, action: #selector(closeButtonTapped(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    // MARK: -Confirguration
    
    func configureCell(_ image: UIImage?, row: NSInteger) {
        
        closeButton.isHidden = false
        currentRow = row
        if imageView.image != nil {
            
            imageView.image = nil
        }
        
        if let image = image {
            
            imageView.image = image

        }else {
            
            imageView.image = UIImage(named: "placeholder")
            closeButton.isHidden = true


        }
    }

    func closeButtonTapped(sender: UIButton?) {
     
        delegate?.removeCurrentPhoto(currentRow)
    }
}
