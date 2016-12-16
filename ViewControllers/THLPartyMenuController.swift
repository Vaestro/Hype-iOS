//
//  THLPartyMenuController.swift
//  Hype
//
//  Created by Edgar Li on 10/25/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//


import UIKit

protocol THLPartyMenuControllerDelegate {
    func didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(_ guestlistInvite: PFObject)
    func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!)
}

class THLPartyMenuController: UIViewController, THLConnectedHostViewControllerDelegate, THLInquiryOffersViewControllerDelegate, THLGuestlistTableViewControllerDelegate {
    internal func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!) {
        self.delegate?.guestlistTableViewWantsToPresentInvitationController(for: event, guestlistId: guestlistId, currentGuestsPhoneNumbers: currentGuestsPhoneNumbers)

    }

    internal func didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(_ guestlistInvite: PFObject) {
        self.delegate?.didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(guestlistInvite)
    }
    
    internal func didAcceptInquiryOffer() {
        
    }
    var delegate : THLPartyMenuControllerDelegate?
    var pageMenu : CAPSPageMenu?
    var guestlistInvite : PFObject
    var guestlist : PFObject
    var inquiry : PFObject
    var acceptedInquiryOffer : PFObject?
    var venue : PFObject?
    var event : PFObject?
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = ""
        (self.navigationController?.navigationBar as! THLBoldNavigationBar).subtitleLabel.text = ""
    }
    
    func dismiss() {
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
