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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_button"), style: .plain, target: self, action: #selector(THLInquiryMenuViewController.dismiss as (THLInquiryMenuViewController) -> () -> ()))
        
        let superview = self.view!

        let connectButton = UIButton()
        connectButton.titleLabel?.text = "CONNECT"
        connectButton.titleLabel?.textColor = UIColor.black
        connectButton.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        connectButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(connectButton)
    
        connectButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.center.equalTo(superview.snp.center)
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
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
                let title = "SUCCESS"
                let message = "Your offer was submitted!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
                    print("You canceled the car dialog.")
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
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
