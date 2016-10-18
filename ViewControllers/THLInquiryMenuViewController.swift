//
//  THLInquiryMenuViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/7/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog

class THLInquiryMenuViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var inquiry: PFObject?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Inquiry"

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
        var offer = PFObject(className:"InquiryOffer")
        offer["message"] = "Hello I am host"
        offer["accepted"] = false
        offer["Host"] = THLUser.current()
        offer.saveInBackground {(success, error) in
            if (success) {
                var offers:[PFObject]? = self.inquiry?.value(forKey: "Offers") as? [PFObject]
                if (offers == nil) {
                    offers = [PFObject]()
                    offers?.append(offer)
                } else {
                    offers?.insert(offer, at: 0)
                }
                self.inquiry?["Offers"] = offers
                self.inquiry?.saveInBackground()
            } else {
                // Prepare the popup assets
                let title = "ERROR"
                let message = "There was an issue with creating your inquiry. Please try again later!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
                    print("You canceled the car dialog.")
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
