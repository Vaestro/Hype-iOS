//
//  THLGuestProfileViewController.swift
//  Hype
//
//  Created by Edgar Li on 10/19/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol THLGuestProfileViewControllerDelegate {
    func didSelectViewInquiry(_ guestlistInvite: PFObject)
    func didSelectViewEventTicket(_ guestlistInvite: PFObject)
    func didSelectViewHostedEvent(_ guestlistInvite: PFObject)
    func didSelectViewTableReservation(_ guestlistInvite: PFObject)
    func didSelectViewInquiryMenuView(_ inquiry: PFObject)

    func userProfileViewControllerWantsToLogout()
    func userProfileViewControllerWantsToPresentPaymentViewController()

}

class THLGuestProfileViewController: UIViewController, THLMyUpcomingEventsViewControllerDelegate, THLUserProfileViewControllerDelegate, THLMyInvitesViewControllerDelegate, THLHostUpcomingEventsViewControllerDelegate, THLPendingInquiryOffersViewControllerDelegate {
    internal func didSelectViewInquiryMenuView(_ inquiry: PFObject) {
        self.delegate?.didSelectViewInquiryMenuView(inquiry)
    }

    internal func didSelectViewTableReservation(_ guestlistInvite: PFObject) {
        self.delegate?.didSelectViewTableReservation(guestlistInvite)
    }

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(THLGuestProfileViewController.presentSettings as (THLGuestProfileViewController) -> () -> ()))

        guestImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width:100,height:100))
            make.centerX.equalTo(self.view.snp.centerX);
        }
    
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        if THLUser.current()?.type == THLUserType.host {
            let myEventsViewController = THLHostUpcomingEventsViewController()
            myEventsViewController.delegate = self;
            myEventsViewController.title = "MY EVENTS"
            controllerArray.append(myEventsViewController)
            
            
            let controller2 : THLPendingInquiryOffersViewController = THLPendingInquiryOffersViewController()
            controller2.title = "PENDING"
            controller2.delegate = self;
            controllerArray.append(controller2)
        } else {
            let myEventsViewController = THLMyUpcomingEventsViewController()
            myEventsViewController.delegate = self;
            myEventsViewController.title = "MY EVENTS"
            controllerArray.append(myEventsViewController)
            
            let controller2 : THLMyInvitesViewController = THLMyInvitesViewController()
            controller2.title = "INVITES"
            controller2.delegate = self;
            controllerArray.append(controller2)
        }
        

        
        // Initialize scroll menu
        let rect = CGRect(x: 0.0, y: 150.0, width: self.view.frame.width, height: self.view.frame.height - 150.0)
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.black),
            .viewBackgroundColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor.customGoldColor()),
            .selectionIndicatorColor(UIColor.customGoldColor()),
            .menuMargin(20.0),
            .menuHeight(40.0),
            .selectedMenuItemLabelColor(UIColor.customGoldColor()),
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
    
    override func viewDidLayoutSubviews() {
        guestImageView.layer.cornerRadius = guestImageView.frame.size.width/2.0

    }
    
    func presentSettings() {
        let navigationConroller = UINavigationController()
        let settingsViewController = THLUserProfileViewController()
        navigationConroller.pushViewController(settingsViewController, animated: false)
        settingsViewController.delegate = self;
        self.present(navigationConroller, animated: true, completion: nil)
        
    }
    

    func presentProfilePicSettings() {
        let vc = THLProfilePicChooserViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var guestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor.black;
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        if ((THLUser.current()?.image) != nil) {
            let imageFile = THLUser.current()?.image as PFFile!
            let url = URL(string: imageFile!.url as String!)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "default_profile_image")!.withRenderingMode(.alwaysOriginal)
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
