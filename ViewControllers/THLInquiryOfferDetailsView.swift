//
//  THLInquiryOfferDetailsView.swift
//  Hype
//
//  Created by Edgar Li on 10/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import SnapKit
import PopupDialog

@objc protocol THLInquiryOfferDetailsViewDelegate {
    func didAcceptInquiryOffer()
}

class THLInquiryOfferDetailsView: UIViewController {
    var delegate: THLInquiryOfferDetailsViewDelegate?
    
    var inquiryOffer: PFObject
    var inquiry: PFObject

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject, offer: PFObject) {
        self.inquiryOffer = offer
        self.inquiry = inquiry
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        let offerMessageLabel = UILabel()
        offerMessageLabel.text = inquiryOffer.value(forKey: "message") as? String
        offerMessageLabel.textColor = UIColor.white
        superview.addSubview(offerMessageLabel)
        offerMessageLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(superview)
        }
        
        let button = UIButton()
        button.setTitle("CONNECT", for: .normal)
        button.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.black
        superview.addSubview(button)
        button.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.bottom.equalTo(superview.snp.bottom).offset(-20)
            make.centerX.equalTo(superview.snp.centerX)
        }
        // Do any additional setup after loading the view.
    }
    
    func handleConnect() {
        inquiryOffer["accepted"] = true
        inquiry["connected"] = true
        inquiryOffer.saveInBackground()
        inquiry.saveInBackground{(success, error) in
            if (success) {
                let title = "SUCCESS"
                let message = "You are now connected with this host!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
                    let hostId = (self.inquiryOffer["Host"] as! THLUser).objectId
                    THLChatSocketManager.sharedInstance.createChatRoom(hostId: hostId!)
                    self.delegate?.didAcceptInquiryOffer()
                }
                
                popup.addButton(buttonOne)
                
                // Present dialog
                self.present(popup, animated: true, completion: nil)
            } else {
                // Prepare the popup assets
                let title = "ERROR"
                let message = "There was an issue with connecting you with the host. Please try again later!"
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message)
                
                // Create buttons
                let buttonOne = CancelButton(title: "OK") {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
