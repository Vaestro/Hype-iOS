//
//  THLGuestProfileViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/19/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit

@objc protocol THLGuestProfileViewControllerDelegate {
    func didSelectViewInquiry(_ guestlistInvite: PFObject)
    func didSelectViewEventTicket(_ guestlistInvite: PFObject)
    func didSelectViewHostedEvent(_ guestlistInvite: PFObject)

    func userProfileViewControllerWantsToLogout()
    func userProfileViewControllerWantsToPresentPaymentViewController()

}

class THLGuestProfileViewController: UIViewController, THLMyUpcomingEventsViewControllerDelegate, THLUserProfileViewControllerDelegate, THLMyInvitesViewControllerDelegate {
    public func userProfileViewControllerWantsToPresentPaymentViewController() {
        delegate?.userProfileViewControllerWantsToPresentPaymentViewController()
    }

    public func userProfileViewControllerWantsToLogout() {
        delegate?.userProfileViewControllerWantsToLogout()
    }
    
    public func didSelectViewHostedEvent(_ guestlistInvite: PFObject) {
        delegate?.didSelectViewHostedEvent(guestlistInvite)
    }


    internal func didSelectViewEventTicket(_ guestlistInvite: PFObject) {
        delegate?.didSelectViewEventTicket(guestlistInvite)

    }

    internal func didSelectViewInquiry(_ guestlistInvite: PFObject) {
        delegate?.didSelectViewInquiry(guestlistInvite)

    }

    var delegate: THLGuestProfileViewControllerDelegate?

    var pageMenu : CAPSPageMenu?
    var myEventsViewController : THLMyUpcomingEventsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu Icon"), style: .plain, target: self, action: #selector(THLGuestProfileViewController.presentSettings as (THLGuestProfileViewController) -> () -> ()))

        guestImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width:100,height:100))
            make.centerX.equalTo(self.view.snp.centerX);
        }
    
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        myEventsViewController = THLMyUpcomingEventsViewController()
        myEventsViewController?.delegate = self;
        myEventsViewController?.title = "MY EVENTS"
        controllerArray.append(myEventsViewController!)
        
        let controller2 : THLMyInvitesViewController = THLMyInvitesViewController()
        controller2.title = "INVITES"
        controller2.delegate = self;
        controllerArray.append(controller2)
        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 150.0, width: self.view.frame.width, height: self.view.frame.height - 150.0)
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: nil)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    func presentSettings() {
        var navigationConroller = UINavigationController()
        var settingsViewController = THLUserProfileViewController()
        navigationConroller.pushViewController(settingsViewController, animated: false)
        settingsViewController.delegate = self;
        self.present(navigationConroller, animated: true, completion: nil)
        
    }
    
    func presentProfilePicSettings() {
        let vc = THLProfilePicChooserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var guestImageView: THLPersonIconView = {
        var imageView = THLPersonIconView()
        if ((THLUser.current()?.image) != nil) {
            var imageFile:PFFile = THLUser.current()!.image
            var url:NSURL = NSURL(string:imageFile.url!)!
            imageView.image = nil
        } else {
            imageView.image = nil
        }
        self.view.addSubview(imageView)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(THLGuestProfileViewController.presentProfilePicSettings))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
