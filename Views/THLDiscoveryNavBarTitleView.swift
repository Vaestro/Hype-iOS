//
//  THLDiscoveryNavBarTitleView.swift
//  Hype
//
//  Created by Edgar Li on 7/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

public class THLDiscoveryNavBarTitleView: UIView {
    // MARK:- Init
    public var eventButton: UIButton
    public var venueButton: UIButton

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame:CGRect) {
        eventButton = UIButton.init(frame: CGRectMake(0, 0, 70, 20))
        venueButton = UIButton.init(frame: CGRectMake(70, 0, 70, 20))

        super.init(frame: CGRectMake(0,0,140,20))
    }
    
    // MARK:- UIView
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        eventButton.setTitle("EVENTS", forState: .Normal)
        eventButton.setTitleColor(UIColor.customGoldColor(), forState: UIControlState.Selected)
        eventButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)

        eventButton.titleLabel!.font = UIFont.init(name: "OpenSans-Semibold", size: 14.0)
        eventButton.titleLabel!.textAlignment = .Center
        eventButton.selected = true
        
        venueButton.setTitle("VENUES", forState: .Normal)
        venueButton.setTitleColor(UIColor.customGoldColor(), forState: UIControlState.Selected)
        venueButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)

        venueButton.titleLabel!.font = UIFont.init(name: "Raleway-Bold", size: 14.0)
        venueButton.titleLabel!.textAlignment = .Center
        venueButton.selected = false

        self.addSubview(eventButton)
        self.addSubview(venueButton)
    }
}
