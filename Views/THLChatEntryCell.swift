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
    var titleLabel: UILabel!
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
        typeLabel.textAlignment = .left
        typeLabel.textColor = UIColor.white
        //contentView.addSubview(typeLabel)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name:"OpenSans-Light", size: 16)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.customGoldColor()
        dateLabel.font = UIFont(name:"OpenSans-Light", size:12)
        contentView.addSubview(dateLabel)
        
        msgLabel = UILabel()
        msgLabel.textAlignment = .left
        msgLabel.textColor = UIColor.white
        msgLabel.font = UIFont(name:"OpenSans-Light", size:12)
        msgLabel.numberOfLines = 1
        
        contentView.addSubview(msgLabel)
        
        let image = UIImage(named: "default_profile_image")
        userImage = PFImageView(image: image!)
        userImage.contentMode = UIViewContentMode.scaleAspectFit
        
        contentView.addSubview(userImage)
        
        let cImage = UIImage(named: "new_icon")
        newImage = PFImageView(image: cImage!)
        newImage.contentMode = UIViewContentMode.scaleAspectFit
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
        
        
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(userImage.snp.right).offset(5)
            make.right.equalTo(dateLabel.snp.left).offset(5)
            make.topMargin.equalTo(4);
        }
        
        msgLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(userImage.snp.right).offset(5)
            make.right.equalTo(dateLabel.snp.left).offset(5)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        
        
        userImage.snp.makeConstraints{ (make) -> Void in
            
            make.height.equalTo(contentView.snp.height).multipliedBy(0.8)
            make.width.equalTo(userImage.snp.height)
            make.centerY.equalTo(contentView)
            make.leftMargin.equalTo(5)
            
        }
        
        dateLabel.snp.makeConstraints{ (make) -> Void in
            make.topMargin.equalTo(5);
            make.rightMargin.equalTo(5)
        }
        
        newImage.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(contentView)
            make.rightMargin.equalTo(5)
            
        }
    }
    
    
    
}
