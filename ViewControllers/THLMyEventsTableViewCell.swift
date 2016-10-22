//
//  THLMyEventsTableViewCell.swift
//  Hype
//
//  Created by Edgar Li on 10/21/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit
import ParseUI

class THLMyEventsTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor.black
        
        self.contentView.addSubview(eventTitleLabel)
        self.contentView.addSubview(dateTimeLabel)
        self.contentView.addSubview(venueImageView)
        
        eventTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(venueImageView.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)

            make.top.equalTo(self.venueImageView.snp.top)
        }
        
        dateTimeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(venueImageView.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(10)

            make.top.equalTo(self.eventTitleLabel.snp.bottom)
        }
        
        venueImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    
    
    lazy var eventTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Bold",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var dateTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Regular",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var eventStatusLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var venueImageView: PFImageView = {
        var imageView = PFImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    
}

