//
//  THLDiscoveryViewController.swift
//  Hype
//
//  Created by Edgar Li on 11/17/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol THLDiscoveryViewControllerDelegate {
    func eventDiscoveryViewWantsToPresentDetailsForAttendingEvent(_ event: PFObject, venue: PFObject, invite: PFObject)
    func eventDiscoveryViewWantsToPresentDetailsForEvent(_ event: PFObject, venue: PFObject)
    func venueDiscoveryViewControllerWantsToPresentDetails(forVenue event: PFObject!)
}

class THLDiscoveryViewController: UIViewController, THLEventDiscoveryViewControllerDelegate, THLVenueDiscoveryViewControllerDelegate {
    internal func eventDiscoveryViewWantsToPresentDetailsForAttendingEvent(_ event: PFObject, venue: PFObject, invite: PFObject) {
        self.delegate?.eventDiscoveryViewWantsToPresentDetailsForAttendingEvent(event, venue: venue, invite: invite)
    }

    internal func eventDiscoveryViewWantsToPresentDetailsForEvent(_ event: PFObject, venue: PFObject) {
        self.delegate?.eventDiscoveryViewWantsToPresentDetailsForEvent(event, venue: venue)
    }

    internal func venueDiscoveryViewControllerWantsToPresentDetails(forVenue venue: PFObject!) {
        self.delegate?.venueDiscoveryViewControllerWantsToPresentDetails(forVenue: venue)
    }

    
    var delegate: THLDiscoveryViewControllerDelegate?
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
//        (self.navigationController?.navigationBar as! THLBoldNavigationBar).titleLabel.text = "WHAT'S HYPE IN NEW YORK"
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let eventDiscoveryView = THLEventDiscoveryViewController(className: "Event")
        eventDiscoveryView.delegate = self;
        eventDiscoveryView.title = "EVENTS"
        controllerArray.append(eventDiscoveryView)
        
        let venueDiscoveryView = THLVenueDiscoveryViewController(className: "Location")
        venueDiscoveryView.title = "VENUES"
        venueDiscoveryView.delegate = self;
    
        controllerArray.append(venueDiscoveryView)
        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.black),
            .viewBackgroundColor(UIColor.black),
            .selectionIndicatorColor(UIColor.lightGray),
            .addBottomMenuHairline(false),
            .menuItemFont(UIFont(name: "Raleway-Bold", size: 20.0)!),
            .menuHeight(80.0),
            .selectionIndicatorHeight(0.0),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.customGoldColor())
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
