//
//  ImageGalleryCell.swift
//  pickary
//
//  Created by Mobile Developer on 12/23/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit
import SnapKit

class ImageGalleryCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView()
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
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    func setupViews(){
        
       contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    // MARK: -Confirguration
    
    func configureCell(_ image: UIImage) {
        
        imageView.image = image
    }
    
    
}
