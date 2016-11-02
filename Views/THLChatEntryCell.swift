//
//  THLChantEntryCell.swift
//  Hype
//
//  Created by Bilal Shahid on 10/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit
import ParseUI

class THLChatEntryCell: UITableViewCell {
    let padding: CGFloat = 5
    var background: UIView!
    var typeLabel: UILabel!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var userImage : PFImageView!
    var dateLabel: UILabel!
    var msgLabel: UILabel!
    var newImage : PFImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        background = UIView(frame: CGRect.zero)
        background.alpha = 1.0
        //contentView.addSubview(background)
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.white
        //contentView.addSubview(nameLabel)
        
        typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.white
        //contentView.addSubview(typeLabel)
        
        priceLabel = UILabel()
        priceLabel.textAlignment = .center
        priceLabel.textColor = UIColor.white
        priceLabel.font = UIFont(name:"OpenSans-Light", size: 16)
        contentView.addSubview(priceLabel)
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.customGoldColor()
        dateLabel.font = UIFont(name:"OpenSans-Light", size:12)
        contentView.addSubview(dateLabel)
        
        msgLabel = UILabel()
        msgLabel.textAlignment = .center
        msgLabel.textColor = UIColor.white
        msgLabel.font = UIFont(name:"OpenSans-Light", size:12)
        msgLabel.numberOfLines = 1
        
        contentView.addSubview(msgLabel)
        
        let image = UIImage(named: "default_profile_image")
        userImage = PFImageView(image: image!)
        userImage.contentMode = UIViewContentMode.scaleAspectFill
        
        contentView.addSubview(userImage)
        
        let cImage = UIImage(named: "checked_box")
        newImage = PFImageView(image: cImage!)
        newImage.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(newImage)
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
       
        priceLabel.snp.makeConstraints { (make) -> Void in
           make.left.right.equalTo(contentView)
           make.topMargin.equalTo(4);
        }
        
        msgLabel.snp.makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(contentView);
            make.bottom.top.bottom.equalTo(contentView);
            make.width.lessThanOrEqualTo(175)
            make.topMargin.equalTo(4);
        }
        
       
        
        userImage.snp.makeConstraints{ (make) -> Void in
            
            make.height.equalTo(contentView.frame.size.height/3)
            make.width.width.equalTo((contentView.frame.size.width/6))
            make.centerY.equalTo(contentView)
            make.leftMargin.equalTo(4)
            
        }
        
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.topMargin.equalTo(5);
            make.rightMargin.equalTo(4)
        }
        
        newImage.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.rightMargin.equalTo(8)
            
        }
    }
    
    

}
