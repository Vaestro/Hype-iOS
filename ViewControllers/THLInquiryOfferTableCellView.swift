//
//  THLInquiryOfferTableViewCell.swift
//  Hype
//
//  Created by Edgar Li on 9/22/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit
import ParseUI

class THLInquiryOfferTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor.black

        self.contentView.addSubview(hostNameLabel)
        self.contentView.addSubview(dateTimeLabel)
        self.contentView.addSubview(eventTitleLabel)
        self.contentView.addSubview(messagePreviewLabel)

        self.contentView.addSubview(hostImageView)
        
        hostNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)

            make.top.equalTo(self.contentView.snp.top).offset(10)
        }
        
        eventTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.top.equalTo(self.hostNameLabel.snp.lastBaseline)
        }
        
        dateTimeLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.top.equalTo(self.eventTitleLabel.snp.lastBaseline)
        }
        
        messagePreviewLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        
        hostImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }

    
    lazy var hostNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Bold",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var eventTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Bold",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var dateTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Regular",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var messagePreviewLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var hostImageView: PFImageView = {
        var imageView = PFImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    

}
