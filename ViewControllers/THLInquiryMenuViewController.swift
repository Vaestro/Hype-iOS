//
//  THLInquiryMenuViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLInquiryMenuViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var inquiry: PFObject?
    var guestlist: PFObject?
    var event: PFObject?
    var location: PFObject?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        self.guestlist = inquiry.value(forKey: "Guestlist") as! PFObject?
        self.event = inquiry.value(forKey: "event") as! PFObject?
        self.location = inquiry.value(forKey: "location") as! PFObject?

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = location?.value(forKey: "name") as? String

        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 : UIViewController = UIViewController()
        controller1.view.backgroundColor = UIColor.orange
        controller1.title = "PENDING"
        controllerArray.append(controller1)
        
        let connectButton = UIButton(frame: CGRect(x: 0.0,y: 0.0,width:100.0,height:50.0))
        connectButton.titleLabel?.text = "CONNECT"
        connectButton.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        connectButton.backgroundColor = UIColor.black
        controller1.view.addSubview(connectButton)
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: 500)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: nil)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    func handleConnect() {
        var interestedPromoters:[PFObject]? = self.inquiry?.value(forKey: "interestedPromoters") as? [PFObject]
        if (interestedPromoters == nil) {
            interestedPromoters = [PFObject]()
            interestedPromoters?.append(THLUser.current()!)
        } else {
            interestedPromoters?.insert(THLUser.current()!, at: 0)
        }
        self.inquiry?["interestedPromoters"] = interestedPromoters
        self.inquiry?.saveInBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
