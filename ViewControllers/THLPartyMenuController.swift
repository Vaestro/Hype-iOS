//
//  THLPartyMenuController.swift
//  Hype
//
//  Created by Edgar Li on 10/25/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//


import UIKit
import SwiftMessages
import PopupDialog

protocol THLPartyMenuControllerDelegate {
    func didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(_ guestlistInvite: PFObject)
    func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!)
}

class THLPartyMenuController: UIViewController, THLConnectedHostViewControllerDelegate, THLInquiryOffersViewControllerDelegate, THLGuestlistTableViewControllerDelegate, THLInquiryOfferDetailsViewDelegate {
    internal func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!) {
        self.delegate?.guestlistTableViewWantsToPresentInvitationController(for: event, guestlistId: guestlistId, currentGuestsPhoneNumbers: currentGuestsPhoneNumbers)
        
    }
    
    internal func didAcceptInquiryOffer() {
        self.delegate?.didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(guestlistInvite)
    }
    
    internal func didSelectInquiryOffer(inquiry:PFObject, offer:PFObject) {
        let inquiryOfferDetailsView = THLInquiryOfferDetailsView(inquiry: inquiry, offer: offer)
        inquiryOfferDetailsView.delegate = self
        self.navigationController?.pushViewController(inquiryOfferDetailsView, animated: true)
    }
    
    
    var delegate : THLPartyMenuControllerDelegate?
    var pageMenu : CAPSPageMenu?
    var guestlistInvite : PFObject
    var guestlist : PFObject
    var inquiry : PFObject
    var acceptedInquiryOffer : PFObject?
    var venue : PFObject?
    var event : PFObject?
    var popup:PopupDialog
    var inviteMessage:MessageView
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(guestlistInvite: PFObject) {
        self.guestlistInvite = guestlistInvite
        self.guestlist = guestlistInvite.value(forKey: "Guestlist") as! PFObject
        self.inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
        self.event = inquiry.value(forKey: "Event") as! PFObject?
        
        self.acceptedInquiryOffer = inquiry.value(forKey: "AcceptedOffer") as! PFObject?
        self.venue = acceptedInquiryOffer?.value(forKey: "Venue") as! PFObject?
        if (acceptedInquiryOffer?.value(forKey: "Event") as! PFObject?) != nil {
            self.event = acceptedInquiryOffer?.value(forKey: "Event") as! PFObject?
        }
        self.inviteMessage = MessageView.viewFromNib(layout: .CardView)
        
        let title = "HYPE CONNECT"
        let message = "Hype Connect allows you to connect with hosts at multiple venues every night where you can take advantage of some of the perks of going with a host like VIP walk-in, complimentary drinks, etc."
        let image = UIImage(named: "hype_connect_promo")
        
        // Create the dialog
        self.popup = PopupDialog(title: title, message: message, image: image)
        super.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel_button"), style: .plain, target: self, action: #selector(THLPartyMenuController.dismiss as (THLPartyMenuController) -> () -> ()))
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        if ((inquiry.value(forKey: "connected") as! Bool) == true) {
            let controller1 : THLConnectedHostViewController = THLConnectedHostViewController(inquiry: inquiry)
            controller1.title = "HOST"
            controller1.delegate = self
            controllerArray.append(controller1)
            
            let controller2 : THLEventDetailsViewController = THLEventDetailsViewController(venue: venue, event: event, guestlistInvite: nil, showNavigationBar: false)
            controller2.title = "EVENT"
            controllerArray.append(controller2)
            
            let guestlistId:String = guestlist.objectId!
            let controller3 : THLGuestlistTableViewController = THLGuestlistTableViewController(guestlistId: guestlistId, event:event!)
            controller3.delegate = self
            controller3.title = "PARTY"
            controllerArray.append(controller3)
        } else {
            let controller1 : THLInquiryOffersViewController = THLInquiryOffersViewController(guestlistInvite: guestlistInvite)
            controller1.title = "INQUIRY"
            controller1.delegate = self
            controllerArray.append(controller1)
            
            let guestlistId:String = guestlist.objectId!
            let controller3 : THLGuestlistTableViewController = THLGuestlistTableViewController(guestlistId: guestlistId, event:event!)
            controller3.delegate = self
            controller3.title = "PARTY"
            controllerArray.append(controller3)
        }
        
        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.black),
            .viewBackgroundColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor.white),
            .selectionIndicatorColor(UIColor.white),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.white),
            .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
        
        let guestlistInviteStatus = guestlistInvite.value(forKey: "response") as! Int
        if guestlistInviteStatus != 1 {
            // Create buttons
            let buttonOne = CancelButton(title: "CANCEL") {
                var config = SwiftMessages.Config()
                config.presentationStyle = .bottom
                config.duration = .forever
                SwiftMessages.show(config: config, view: self.inviteMessage)
            }
            
            let buttonTwo = DefaultButton(title: "LET'S GO") {
                self.handleHypeConnectOption()
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo])
            // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
            // files in the main bundle first, so you can easily copy them into your project and make changes.
            
            
            // Theme message elements with the warning style.
            inviteMessage.configureTheme(.warning)
            
            // Add a drop shadow.
            inviteMessage.configureDropShadow()
            
            
            // Set message title, body, and icon. Here, we're overriding the default warning
            // image with an emoji character.
            let iconText = ["🎉", "👯", "🎊"].sm_random()!
            inviteMessage.configureContent(title: "Pending Invite", body: "Please let your party know that you will be attending", iconText: iconText)
            inviteMessage.button?.setTitle("GO", for: .normal)
            inviteMessage.buttonTapHandler = { _ in self.handleAcceptInvite() }
            // Show the message.
            var config = SwiftMessages.Config()
            config.presentationStyle = .bottom
            config.duration = .forever
            SwiftMessages.show(config: config, view: inviteMessage)
        }
        
    }
    
    func handleAcceptInvite() {
        // Prepare the popup assets
        SwiftMessages.hide()
        self.present(popup, animated: true, completion: nil)
    }
    
    func handleHypeConnectOption() {
        if(THLUser.current()?.value(forKey: "image") == nil){
            let vc = THLProfilePicChooserViewController()
            vc.messageView.text = "Please add a profile picture that clearly shows your face so that your Hype host can locate you at the venue!"
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guestlistInvite["response"] = 1
            guestlistInvite.saveInBackground{(success, error) in
                if (success) {
                    self.popup.dismiss()
                    self.showAcceptedInviteMessage()
                }
            }
        }
    }
    
    func showAcceptedInviteMessage() {
        let title = "SUCCESS"
        let message = "You have accepted your invite!"
        
        // Create the dialog
        let successPopup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = CancelButton(title: "OK") {}
        successPopup.addButton(buttonOne)
        
        self.present(successPopup, animated: true, completion: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = ""
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""
    }
    
    func dismiss() {
        let guestlistInviteStatus = guestlistInvite.value(forKey: "response") as! Int
        if guestlistInviteStatus != 1 {
            SwiftMessages.hide()
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func openMessageView(ctrl: THLChatViewController) {
        self.navigationController?.pushViewController(ctrl, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
