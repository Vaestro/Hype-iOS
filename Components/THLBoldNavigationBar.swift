//
//  THLBoldNavigationBar.swift
//  Hype
//
//  Created by Edgar Li on 10/18/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

let kNavigationBarIncrease:CGFloat = 20.0

class THLBoldNavigationBar : UINavigationBar {
    var titleLabel: UILabel = UILabel()
    var subtitleLabel = UILabel()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        initialize()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
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


        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let classNamesToReposition = ["_UIBarBackground"]
        for view: UIView in self.subviews {
            let className = NSStringFromClass(view.classForCoder)
            if classNamesToReposition.contains(NSStringFromClass(view.classForCoder)) {
                let bounds = self.bounds
                var frame = view.frame
                frame.origin.y = bounds.origin.y + kNavigationBarIncrease - 20.0
                frame.size.height = bounds.size.height + 20.0
                view.frame = frame
            }
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(subtitleLabel.snp.top)
            make.left.equalTo(self.snp.left).offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
        }
    }

    func initialize() {
        self.transform = CGAffineTransform(translationX: 0, y: -(kNavigationBarIncrease))
    }

    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var amendedSize = super.sizeThatFits(size)
        amendedSize.height += kNavigationBarIncrease
        return amendedSize
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let screenRect = UIScreen.main.bounds
//        return CGSize(width: screenRect.size.width, height: 65)
//    }
}
