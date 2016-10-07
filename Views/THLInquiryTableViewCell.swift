//
//  THLInquiryTableViewCell.swift
//  Hype
//
//  Created by Edgar Li on 10/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit

class THLInquiryTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        let containerView:UIView = UIView()
        self.contentView.addSubview(containerView)
        self.contentView.backgroundColor = UIColor.black
        
        containerView.addSubview(inquirySenderLabel)
        containerView.addSubview(venueNameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(groupSizeLabel)
        
        inquirySenderLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(containerView)
        }
        
        venueNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(containerView)
            make.top.equalTo(inquirySenderLabel.snp.lastBaseline).offset(10)
        }
        
        dateLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(containerView)
            make.top.equalTo(venueNameLabel.snp.lastBaseline).offset(10)
        }

        groupSizeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dateLabel.snp.lastBaseline).offset(10)
            make.bottom.left.right.equalTo(containerView)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    
    lazy var inquirySenderLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var venueNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"Raleway-ExtraBold",size:20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"Raleway-Medium",size:20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var groupSizeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()

}
