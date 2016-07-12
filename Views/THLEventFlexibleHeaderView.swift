
//  THLEventFlexibleHeaderView.swift
//  Hype
//
//  Created by Edgar Li on 7/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar

class THLEventFlexibleHeaderView : BLKFlexibleHeightBar {
    // MARK:- Init
    var dateLabel: UILabel
    var titleLabel: UILabel
    var minimumTitleLabel: UILabel
    var dismissButton: UIButton
    var swipeView: SwipeView
    var images: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        dateLabel = UILabel()
        titleLabel = UILabel()
        minimumTitleLabel = UILabel()
        dismissButton = UIButton()
        swipeView = SwipeView()
        images = ["1", "2","3","4","5"]
        super.init(frame: frame)
        self.behaviorDefiner = SquareCashStyleBehaviorDefiner()
        self.minimumBarHeight = 65;
        self.userInteractionEnabled = true;
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        swipeView.pagingEnabled = true
    }
    
}