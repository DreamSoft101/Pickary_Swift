//
//  CustomLabel.swift
//  pickary
//
//  Created by Mobile Developer on 12/9/16.
//  Copyright © 2016 Greg. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(_ str:String) {
        
        super.init(frame: CGRect.zero)
        self.text = str
        self.font = UIFont.systemFont(ofSize: kAppTitleLabelFontSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // decode clientName and time if you want
        super.init(coder: aDecoder)
    }
}
