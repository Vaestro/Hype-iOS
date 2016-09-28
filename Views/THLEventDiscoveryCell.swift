//
//  THLEventDiscoveryCell.swift
//  Hype
//
//  Created by Edgar Li on 9/22/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SnapKit

class THLEventDiscoveryCell: PFCollectionViewCell {
//    var eventDateLabel: UILabel
//    var venueNameLabel: UILabel
//    var venueNeighborhoodLabel: UILabel
//    var venueImageView: PFImageView
//    var eventTitleLabel: UILabel
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        venueImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.contentView)
        }
        
        let containerView:UIView = UIView()
        
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(venueNameLabel)
        containerView.addSubview(eventTitleLabel)
        containerView.addSubview(venueNeighborhoodLabel)
        containerView.addSubview(eventDateLabel)

        venueNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(containerView)
        }
        
        if (eventTitleLabel.text != nil) {
            eventTitleLabel.snp.makeConstraints { (make) -> Void in
                make.left.right.equalTo(containerView)
                make.top.equalTo(venueNameLabel.snp.lastBaseline).offset(10)
            }
            
            venueNeighborhoodLabel.snp.makeConstraints { (make) -> Void in
                make.left.right.equalTo(containerView)
                make.top.equalTo(eventTitleLabel.snp.lastBaseline).offset(10)
            }
        } else {
            venueNeighborhoodLabel.snp.makeConstraints { (make) -> Void in
                make.left.right.equalTo(containerView)
                make.top.equalTo(venueNameLabel.snp.lastBaseline).offset(10)
            }
        }


        
        eventDateLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(venueNeighborhoodLabel.snp.lastBaseline).offset(10)
            make.bottom.left.right.equalTo(containerView)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    
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
    
    lazy var eventTitleLabel: UILabel = {
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
    
    lazy var venueNeighborhoodLabel: UILabel = {
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
    
    lazy var eventDateLabel: UILabel = {
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
    
    lazy var venueImageView: PFImageView = {
        var imageView = PFImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.dim()
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var eventCategoryLabel: UILabel = {
        var label = UILabel(frame: CGRect(x:10, y:0, width:125, height:30))
        label.font = UIFont(name:"OpenSans-ExtraBold", size:12)
        label.text = "FEATURED EVENT"
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = UIColor.customGoldColor()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
}
