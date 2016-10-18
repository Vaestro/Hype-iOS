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
        contentView.addSubview(background)
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.white
        contentView.addSubview(nameLabel)
        
        typeLabel = UILabel(frame: CGRect.zero)
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.white
        contentView.addSubview(typeLabel)
        
        priceLabel = UILabel(frame: CGRect.zero)
        priceLabel.textAlignment = .center
        priceLabel.textColor = UIColor.white
        contentView.addSubview(priceLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.frame = CGRect(x: 0, y: padding, width:frame.width, height: frame.height - 2 * padding)
        typeLabel.frame = CGRect(x: padding, y: (frame.height - 25)/2, width: 40, height: 25)
        priceLabel.frame = CGRect(x: frame.width - 100, y: padding, width: 100, height: frame.height - 2 * padding)
        nameLabel.frame = CGRect(x: typeLabel.frame.maxX + 10, y: 0, width: frame.width - priceLabel.frame.width - (typeLabel.frame.maxX + 10), height: frame.height)
    }
    
    

}
