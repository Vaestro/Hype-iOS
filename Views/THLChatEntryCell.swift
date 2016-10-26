//
//  THLChantEntryCell.swift
//  Hype
//
//  Created by Bilal Shahid on 10/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit

class THLChatEntryCell: UITableViewCell {
    let padding: CGFloat = 5
    var background: UIView!
    var typeLabel: UILabel!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    var userImage : UIImageView!
    var dateLabel: UILabel!

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
        
        let image = UIImage(named: "default_profile_image")
        userImage = UIImageView(image: image!)
        contentView.addSubview(userImage)
        
        
        
        
        
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
           make.bottom.left.right.equalTo(contentView)
           make.bottom.top.bottom.equalTo(contentView);
        }
        
        userImage.snp.makeConstraints{ (make) -> Void in
            
            make.height.equalTo(contentView.frame.size.height/2)
            make.width.width.equalTo((contentView.frame.size.width/6))
            make.centerY.equalTo(contentView)
            make.leftMargin.equalTo(4)
            
        }
        
        dateLabel.snp.makeConstraints{ (make) -> Void in
           
            make.bottom.top.bottom.equalTo(contentView);
            make.rightMargin.equalTo(4)
        }
    }
    
    

}
