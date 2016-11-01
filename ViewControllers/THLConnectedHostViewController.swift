//
//  THLConnectedHostViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

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

@objc protocol THLConnectedHostViewControllerDelegate {
    func didAcceptInquiryOffer()
}

class THLConnectedHostViewController: UIViewController {
    var delegate: THLConnectedHostViewControllerDelegate?
    
    var inquiry: PFObject
    var inquiryOffer : PFObject
    var host: PFObject
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inquiry: PFObject) {
        self.inquiry = inquiry
        self.inquiryOffer = inquiry.value(forKey: "AcceptedOffer") as! PFObject
        self.host = inquiryOffer.value(forKey:"Host") as! PFObject
        
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let superview = self.view!
        superview.backgroundColor = UIColor.black
        
        let hostImageView:PFImageView = constructImageView()
        hostImageView.file = host["image"] as! PFFile?
        hostImageView.loadInBackground()
        superview.addSubview(hostImageView)
        
        let offerMessageLabel = constructBodyTitleLabel()
        offerMessageLabel.text = "Communicate with David and let him know when you will be able to meet him at the venue. Once you arrive, please check-in with David to receive your credits."
        superview.addSubview(offerMessageLabel)
        
        let hostNameLabel = constructTitleLabel()
        hostNameLabel.text = host.value(forKey: "firstName") as? String
        superview.addSubview(hostNameLabel)
        
        let hostTypeLabel = constructTitleLabel()
        hostTypeLabel.text = "HYPE CONCIERGE"
        superview.addSubview(hostTypeLabel)
        
        let messageButton = UIButton()
        messageButton.setTitle("MESSAGE", for: .normal)
        messageButton.addTarget(self, action: #selector(handleMessageAction), for: UIControlEvents.touchUpInside)
        messageButton.backgroundColor = UIColor.customGoldColor()
        superview.addSubview(messageButton)
        
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
        
        messageButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.right.equalTo(superview.snp.right).offset(-10)
            make.left.equalTo(hostImageView.snp.right).offset(10)
            make.bottom.equalTo(hostImageView.snp.bottom)
        }
        // Do any additional setup after loading the view.
    }
    
    func handleMessageAction() {

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
        label.numberOfLines = 0
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
