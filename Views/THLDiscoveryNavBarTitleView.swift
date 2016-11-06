//
//  THLDiscoveryNavBarTitleView.swift
//  Hype
//
//  Created by Edgar Li on 7/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

open class THLDiscoveryNavBarTitleView: UIView {
    // MARK:- Init
    open var eventButton: UIButton
    open var venueButton: UIButton

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame:CGRect) {

        eventButton = UIButton.init(frame: CGRect.zero)
        venueButton = UIButton.init(frame: CGRect.zero)
        
        super.init(frame: CGRect(x: 0,y: 0,width: 200,height: 20))

        
        eventButton.setTitle("EVENTS", for: UIControlState())
        eventButton.setTitleColor(UIColor.customGoldColor(), for: UIControlState.selected)
        eventButton.setTitleColor(UIColor.gray, for: UIControlState())
        
        eventButton.titleLabel!.font = UIFont.init(name: "Raleway-Bold", size: 20.0)
        eventButton.titleLabel!.textAlignment = .left
        eventButton.isSelected = true
        
        venueButton.setTitle("VENUES", for: UIControlState())
        venueButton.setTitleColor(UIColor.customGoldColor(), for: UIControlState.selected)
        venueButton.setTitleColor(UIColor.gray, for: UIControlState())
        
        venueButton.titleLabel!.font = UIFont.init(name: "Raleway-Bold", size: 20.0)
        venueButton.titleLabel!.textAlignment = .left
        venueButton.isSelected = false
        
        self.addSubview(eventButton)
        self.addSubview(venueButton)
        


    }
    
    // MARK:- UIView
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        eventButton.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        venueButton.frame = CGRect(x: 100, y: 0, width: 100, height: 20)
    }
}
