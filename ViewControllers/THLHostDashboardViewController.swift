//
//  THLHostDashboardViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

class THLHostDashboardViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 : THLAvailableInquiriesViewController = THLAvailableInquiriesViewController()
        controller1.title = "INQUIRIES"
        controllerArray.append(controller1)
        
        let controller2 : UIViewController = UIViewController()
        controller2.view.backgroundColor = UIColor.orange
        controller2.title = "PENDING"
        controllerArray.append(controller2)
        
        let controller3 : UIViewController = UIViewController()
        controller3.view.backgroundColor = UIColor.gray
        controller3.title = "CONNECTED"
        controllerArray.append(controller3)
        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 50.0, width: self.view.frame.width, height: 500)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: nil)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
