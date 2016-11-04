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
import Parse
import ParseUI

@objc protocol THLInquiryOfferDetailsViewDelegate {
    func didAcceptInquiryOffer()
}

class THLInquiryOfferDetailsView: UIViewController {
    var delegate: THLInquiryOfferDetailsViewDelegate?
    
    var inquiryOffer: PFObject
    var inquiry: PFObject
    var host: PFObject
    var venue: PFObject
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject, offer: PFObject) {
        self.inquiryOffer = offer
        self.inquiry = inquiry
        self.host = inquiryOffer.value(forKey:"Host") as! PFObject
        self.venue = inquiryOffer.value(forKey:"Venue") as! PFObject

        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = ""
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        let hostImageView:PFImageView = constructImageView()
        hostImageView.file = host["image"] as! PFFile?
        hostImageView.loadInBackground()
        superview.addSubview(hostImageView)
        
        let venueImageView:PFImageView = constructImageView()
        venueImageView.file = venue["image"] as! PFFile?
        venueImageView.loadInBackground()
        superview.addSubview(venueImageView)
        
        let offerMessageLabel = constructBodyLabel()
        offerMessageLabel.text = inquiryOffer.value(forKey: "message") as? String
        superview.addSubview(offerMessageLabel)
        
        let hostNameLabel = constructTitleLabel()
        hostNameLabel.text = host.value(forKey: "firstName") as? String
        superview.addSubview(hostNameLabel)
        
        let hostTypeLabel = constructTitleLabel()
        hostTypeLabel.text = "HYPE CONCIERGE"
        superview.addSubview(hostTypeLabel)
        
        let venueTitleLabel = constructBodyTitleLabel()
        venueTitleLabel.text = "VENUE"
        superview.addSubview(venueTitleLabel)
        
        let venueNameLabel = constructBodyLabel()
        venueNameLabel.text = venue.value(forKey: "name") as? String
        superview.addSubview(venueNameLabel)
        
        let dateTitleLabel = constructBodyTitleLabel()
        dateTitleLabel.text = "DATE"
        superview.addSubview(dateTitleLabel)
        
        let dateTimeLabel = constructBodyLabel()
        let date = inquiryOffer.value(forKey: "date") as? Date
        dateTimeLabel.text = (date! as NSDate).thl_weekdayString
        superview.addSubview(dateTimeLabel)
        
        let button = UIButton()
        button.setTitle("CONNECT", for: .normal)
        button.addTarget(self, action: #selector(handleConnect), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(button)
        
        hostImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(superview.snp.top).offset(10)
            make.left.equalTo(superview.snp.left).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        hostNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(superview.snp.top).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.left.equalTo(hostImageView.snp.right).offset(10)
        }
        
        hostTypeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hostNameLabel.snp.bottom)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.left.equalTo(hostImageView.snp.right).offset(10)
        }
        
        offerMessageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(hostImageView.snp.bottom).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.left.equalTo(superview.snp.left).offset(10)
        }
        
        venueImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(offerMessageLabel.snp.bottom).offset(10)
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)

            make.height.equalTo(100)
        }
        
        venueTitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(venueImageView.snp.bottom).offset(10)
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.centerX).offset(-10)
        }
        
        venueNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(venueTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(superview.snp.left).offset(10)
            make.right.equalTo(superview.snp.centerX).offset(-10)
        }
        
        dateTitleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(venueImageView.snp.bottom).offset(10)
            make.left.equalTo(superview.snp.centerX).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
        }
        
        dateTimeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(superview.snp.centerX).offset(10)
            make.right.equalTo(superview.snp.right).offset(-10)
        }
        
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
        inquiry["AcceptedOffer"] = inquiryOffer
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
    
    func constructTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name:"OpenSans-Bold",size:20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }

    func constructBodyTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name:"OpenSans-Bold",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }
    
    func constructBodyLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name:"OpenSans-Light",size:16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.gray
        return label
    }
    
    func constructImageView() -> PFImageView {
        let imageView = PFImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
