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
        
        subtitleLabel.font = UIFont(name:"Raleway-Bold",size:16)
        subtitleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = UIColor.gray

        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(self.snp.left).offset(10)
        }
        
        
    }
    

    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var screenRect = UIScreen.main.bounds
        return CGSize(width: screenRect.size.width, height: 65)
    }
}
