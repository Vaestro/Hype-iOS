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
        self.contentView.addSubview(locationAndDateLabel)
        self.contentView.addSubview(hostImageView)
        
        hostNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.bottom.equalTo(self.contentView.snp.centerY)
        }
        
        locationAndDateLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.top.equalTo(self.contentView.snp.centerY)
        }
        
        hostImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }

    
    lazy var hostNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Regular",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var locationAndDateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var hostImageView: PFImageView = {
        var imageView = PFImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.dim()
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    

}
