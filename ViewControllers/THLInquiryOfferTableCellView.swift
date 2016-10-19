//
//  THLInquiryOfferTableViewCell.swift
//  Hype
//
//  Created by Edgar Li on 9/22/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit

class THLInquiryOfferTableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        self.contentView.backgroundColor = UIColor.black

        self.contentView.addSubview(hostNameLabel)
        self.contentView.addSubview(locationAndDateLabel)
        self.contentView.addSubview(hostImageView)
        
        hostNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right)
            make.bottom.equalTo(self.contentView.snp.centerY)
        }
        
        locationAndDateLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(hostImageView.snp.right)
            make.top.equalTo(self.contentView.snp.centerY)
        }
        
        hostImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.centerY.equalTo(self)
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
    
    lazy var hostImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.dim()
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    

}
