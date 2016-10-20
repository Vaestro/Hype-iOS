//
//  THLGuestProfileViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/19/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLGuestProfileViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var myEventsViewController : THLMyEventsViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guestImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width:100,height:100))
            make.centerX.equalTo(self.view.snp.centerX);
        }
    
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        myEventsViewController = THLMyEventsViewController.init(className: "GuestlistInvite")
        myEventsViewController?.title = "TICKETS"
        controllerArray.append(myEventsViewController!)
        
        let controller2 : UIViewController = UIViewController()
        controller2.view.backgroundColor = UIColor.orange
        controller2.title = "INVITES"
        controllerArray.append(controller2)
        
        let controller3 : UIViewController = UIViewController()
        controller3.view.backgroundColor = UIColor.gray
        controller3.title = "PAST"
        controllerArray.append(controller3)
        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 150.0, width: self.view.frame.width, height: self.view.frame.height - 150.0)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: nil)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    lazy var guestImageView: THLPersonIconView = {
        var imageView = THLPersonIconView()
        if ((THLUser.current()?.image) != nil) {
            var imageFile:PFFile = THLUser.current()!.image
            var url:NSURL = NSURL(string:imageFile.url!)!
            imageView.image = nil
        } else {
            imageView.image = nil
        }
        self.view.addSubview(imageView)
        return imageView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
