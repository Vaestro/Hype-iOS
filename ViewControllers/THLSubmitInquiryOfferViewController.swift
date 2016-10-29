//
//  THLSubmitInquiryOfferViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import PopupDialog

class THLSubmitInquiryOfferViewController: UIViewController {
    
    var inquiry: PFObject?
    var messageTextField: UITextField?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        
        self.messageTextField = UITextField()

        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        messageTextField?.backgroundColor = UIColor.gray
        superview.addSubview(messageTextField!)
        
        messageTextField?.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(superview.snp.left).offset(50)
            make.right.equalTo(superview.snp.right).offset(-50)
            make.height.equalTo(300)
            make.center.equalTo(superview.snp.center)
        }
        
        let submitButton = UIButton()
        submitButton.titleLabel?.text = "CONNECT"
        submitButton.titleLabel?.textColor = UIColor.black
        submitButton.addTarget(self, action: #selector(submitOffer  ), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.bottom.equalTo(superview.snp.bottom).offset(-50)
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submitOffer() {
        var offer = PFObject(className:"InquiryOffer")
        offer["message"] = self.messageTextField?.text
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
