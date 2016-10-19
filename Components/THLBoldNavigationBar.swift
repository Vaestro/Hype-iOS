//
//  THLBoldNavigationBar.swift
//  Hype
//
//  Created by Edgar Li on 10/18/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLBoldNavigationBar : UINavigationBar {
    var titleLabel: UILabel = UILabel()
    var subtitleLabel = UILabel()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        titleLabel.font = UIFont(name:"Raleway-Bold",size:20)
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.text = "INQUIRY FOR CLUB"

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.centerY.equalTo(self)
        }
        
    }
    

    
    override func draw(_ rect: CGRect) {
        
    }
}
