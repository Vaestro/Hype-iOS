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
    
    func openMessageView(ctrl: THLChatViewController)
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
        let hostName:String = host.value(forKey: "firstName") as! String
        offerMessageLabel.text = "Communicate with \(hostName) and let them know when you will be able to meet them at the venue. Once you arrive, please check-in with \(hostName) to receive your credits."
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
        
        listenHandlerForChatRoom()
    }
    
    func handleMessageAction() {
        if checkForInquiryOwner() {
            THLChatSocketManager.sharedInstance.getSpecificChatRoom(hostId: self.host.objectId!, guestId: (THLUser.current()?.objectId)!)
        } else {
            // Prepare the popup assets
            let title = "OOPS"
            let message = "Only the creator of your party can message the host!"
            
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
    
    func checkForInquiryOwner() -> Bool {
        let inquiryOwner:PFObject = inquiry.value(forKey:"Sender") as! PFObject
        let currentUser = THLUser.current()
        return inquiryOwner.objectId == currentUser!.objectId
    }
    
    func listenHandlerForChatRoom() {
        THLChatSocketManager.sharedInstance.socket.on("send specific room") { (dataArray, socketAck) -> Void in
            let chatRoomDict = dataArray[0] as! NSDictionary
            var chatRoomId = chatRoomDict["room"]
            let resultController = THLChatViewController()
            resultController.chatMateId = self.host.objectId
            resultController.chatRoomId = chatRoomId as! String?
            resultController.chatMateName = "Host"
            self.delegate?.openMessageView(ctrl: resultController)
            
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
