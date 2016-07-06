//
//  THLEventNavBarTitleView.swift
//  Hype
//
//  Created by Edgar Li on 7/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import ReactiveCocoa

class THLEventNavBarTitleView: UIView {

    var venueName: String?
    var date: NSDate?
    var dateLabel: UILabel
    var locationLabel: UILabel
    
    // MARK:- Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(venueName: String?, date: NSDate?) {
        self.locationLabel = UILabel.init(frame: CGRectMake(0, 0, 200, 20))
        self.dateLabel = UILabel.init(frame: CGRectMake(0, 20, 200, 20))
        
        super.init(frame: CGRectMake(0, 0, 200, 40))

        self.venueName = venueName
        self.date = date

    }

    // MARK:- UIView

    override func layoutSubviews() {
        super.layoutSubviews()
        
        locationLabel.text = venueName?.uppercaseString
        locationLabel.font = UIFont.init(name: "OpenSans-Semibold", size: 14.0)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = .Center
        locationLabel.adjustsFontSizeToFitWidth = true
        
        dateLabel.text = date?.thl_formattedDate()
        dateLabel.font = UIFont.init(name: "Raleway-Bold", size: 14.0)
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.textAlignment = .Center
        dateLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(locationLabel)
        self.addSubview(dateLabel)
    }
}
