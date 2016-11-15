//
//  THLMasterRouter.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import SVProgressHUD

@objc class THLMasterRouter: NSObject, THLWelcomeViewDelegate, THLAccountRegistrationViewControllerDelegate, THLSwiftLoginViewControllerDelegate, THLEventDiscoveryViewControllerDelegate, THLVenueDiscoveryViewControllerDelegate, THLGuestProfileViewControllerDelegate, THLEventDetailsViewControllerDelegate, THLSwiftAdmissionsViewControllerDelegate, THLPartyViewControllerDelegate, THLCheckoutViewControllerDelegate, THLTablePackageControllerDelegate  {


    var window: UIWindow
    var welcomeView: THLWelcomeViewController
    var guestMainTabBarController = UITabBarController()
    
    override init() {
        self.window = UIWindow()
        self.welcomeView = THLWelcomeViewController()

        super.init()
    }
    
    func presentApp(in window: UIWindow) {
        self.window = window
        if THLUserManager.isUserCached() && THLUserManager.isUserProfileValid() {
            self.presentGuestInterface()
        }
        else {
            self.presentWelcomeView()
        }
    }
    
    // MARK: Welcome View Controller
    func presentWelcomeView() {
        self.welcomeView.delegate = self
        let onboardingNavigationController = UINavigationController()
        onboardingNavigationController.addChildViewController(welcomeView)
        self.window.rootViewController = onboardingNavigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: WelcomeViewControllerDelegate
    func welcomeViewWantsToPresentLoginView() {
        let loginView = THLSwiftLoginViewController()
        loginView.delegate = self
        welcomeView.navigationController?.pushViewController(loginView, animated: true)
    }
    
    func welcomeViewDidConnectWithFacebookAndReceivedUserData(userData:[String:AnyObject]) {
        presentAccountRegistrationView(userData:userData)
    }
    
    func welcomeViewDidLoginWithFacebookAndWantsToPresentGuestInterface() {
        presentGuestInterface()
    }
    
    // MARK: Account Registration View Controller
    
    func presentAccountRegistrationView(userData:[String:AnyObject]) {
        let accountRegistrationViewController = THLAccountRegistrationViewController(userData)
        welcomeView.navigationController?.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    // MARK: Account Registration View Controller Delegate
    func accountRegistrationViewDidCompleteRegistration() {
        presentGuestInterface()
    }
    
    // MARK: Login View Controller Delegate
    func loginViewWantsToPresentAccountRegistration() {
        let accountRegistrationViewController = THLAccountRegistrationViewController(nil)
        welcomeView.navigationController?.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    func loginViewDidLoginAndWantsToPresentGuestInterface() {
        presentGuestInterface()
    }
    
    func presentGuestInterface() {
        guestMainTabBarController = UITabBarController()
        let eventDiscoveryView = THLEventDiscoveryViewController(className: "Event")
        let venueDiscoveryView = THLVenueDiscoveryViewController(className: "Location")
        let discoveryNavigationController = UINavigationController()
        eventDiscoveryView.delegate = self
        venueDiscoveryView.delegate = self
        
        discoveryNavigationController.pushViewController(eventDiscoveryView, animated: false)
        
        let guestProfileView = THLGuestProfileViewController()
        guestProfileView.delegate = self
        let profileNavigationController = UINavigationController()
        profileNavigationController.pushViewController(guestProfileView, animated: false)
        
        let conversationsNavigationController = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        let conversationsView = THLChatEntryTableViewController()
        conversationsNavigationController.pushViewController(conversationsView, animated: false)
        conversationsNavigationController.tabBarItem.image = UIImage(named: "message")!
        discoveryNavigationController.tabBarItem.image = UIImage(named: "Home Icon")!
        profileNavigationController.tabBarItem.image = UIImage(named: "Profile Icon")!
        
        let views = [discoveryNavigationController, conversationsNavigationController, profileNavigationController]
        
        guestMainTabBarController.viewControllers = views
        guestMainTabBarController.selectedIndex = 0
        guestMainTabBarController.view.autoresizingMask = (.flexibleHeight)
        
        window.rootViewController = guestMainTabBarController
        window.makeKeyAndVisible()
    }
    
    // MARK: Event Discovery View Controller Delegate
    internal func eventDiscoveryViewWantsToPresentDetailsForEvent(_ event: PFObject, venue: PFObject) {
        let eventDetailView = THLEventDetailsViewController(venue: venue, event: event, guestlistInvite: nil, showNavigationBar: true)
        eventDetailView?.delegate = self
        window.rootViewController!.present(eventDetailView!, animated: true, completion: { _ in })
    }
    
    internal func eventDiscoveryViewWantsToPresentDetailsForAttendingEvent(_ event: PFObject, venue: PFObject, invite: PFObject) {
        let eventDetailView = THLEventDetailsViewController(venue: venue, event: event, guestlistInvite: invite, showNavigationBar: true)
        eventDetailView?.delegate = self
        window.rootViewController!.present(eventDetailView!, animated: true, completion: { _ in })
    }
    
    // MARK: Event Details View Controller Delegate
    public func eventDetailsWantsToPresentAdmissions(forEvent event: PFObject!, venue: PFObject!) {
        let admissionsView = THLSwiftAdmissionsViewController(venue: venue, event: event)
        admissionsView.delegate = self
        let navigationViewController = UINavigationController(rootViewController: admissionsView)
        self.topViewController().present(navigationViewController, animated: true, completion: { _ in })
    }
    
    public func eventDetailsWantsToPresentParty(forEvent guestlistInvite: PFObject!) {
        window.rootViewController!.dismiss(animated: true, completion: {() -> Void in
            let guestlist:PFObject = guestlistInvite.value(forKey: "Guestlist") as! PFObject
            let admissionOption:PFObject = guestlist.value(forKey: "admissionType") as! PFObject
            let admissionType:Int = admissionOption.value(forKey: "type") as! Int

//            let inquiry:PFObject = guestlist.value(forKey: "Inquiry") as! PFObject
//            let inquiryConnectedStatus:Int = inquiry.value(forKey: "connected") as! Int

//            if admissionType == 2 {
//                if inquiryConnectedStatus == 1 {
//                    self.presentPartyMenu(forConnect: guestlistInvite)
//                }
//                else {
//                    self.presentOffers(forInquiry: guestlistInvite)
//                }
//            }
//            else {
                self.presentPartyNavigationControllerforTicket(invite: guestlistInvite)
//            }
        })
        guestMainTabBarController.selectedIndex = 2
    }
    
    // MARK: Admissions View Controller Delegate
    internal func didSelectAdmissionOption(_ admissionOption: PFObject, event: PFObject) {
        let admissionType:Int = admissionOption.value(forKey: "type") as! Int
        if admissionType == 0 {
            let checkoutView = THLCheckoutViewController(event: event, admissionOption: admissionOption, guestlistInvite: nil)
            checkoutView?.delegate = self
            self.topViewController().navigationController!.pushViewController(checkoutView!, animated: true)
        }
        else if admissionType == 1 {
            //        THLReservationRequestViewController *packageDetailsVC = [[THLReservationRequestViewController alloc] initWithEvent:event admissionOption:admissionOption];
            let packageDetailsView = THLTablePackageDetailsViewController(event: event, admissionOption: admissionOption, showActionButton: true)
            packageDetailsView?.delegate = self
            self.topViewController().navigationController!.pushViewController(packageDetailsView!, animated: true)
        }
    }
    
    // MARK: Checkout View Controller
    internal func presentCheckoutViewController(_ event: PFObject, guestlistInvite: THLGuestlistInvite, admissionOption: PFObject) {
        let checkoutView = THLCheckoutViewController(event: event, admissionOption: admissionOption, guestlistInvite: guestlistInvite)
        checkoutView?.delegate = self
        self.topViewController().navigationController!.pushViewController(checkoutView!, animated: true)
    }
    
    // MARK: Checkout View Controller Delegate
    internal func checkoutViewControllerWantsToPresentPaymentViewController() {
        self.presentPaymentViewController(on: topViewController())
    }
    
    internal func checkoutViewControllerDidFinishCheckout(for event: THLEvent, withGuestlistId guestlistId: String) {
        self.presentInvitationViewController(event, guestlistId: guestlistId, currentGuestsPhoneNumbers: [])
    }
    
    public func checkoutViewController(_ checkoutView: THLCheckoutViewController!, didFinishPurchasingForGuestlistInvite guestlistInviteId: String!) {
        
    }
    
    internal func checkoutViewControllerDidFinishTableReservation(forEvent invite: PFObject) {
        self.presentPartyNavigationControllerforTableReservation(invite: invite)
    }
    
    // MARK: PartyInvitationViewController
    
    func presentInvitationViewController(_ event: THLEvent, guestlistId: String, currentGuestsPhoneNumbers: [Any]) {
//        var partyInvitationVC = THLPartyInvitationViewController(event, guestlistId: guestlistId, guests: currentGuestsPhoneNumbers, databaseManager: self.dependencyManager.databaseManager, dataStore: self.dependencyManager.contactsDataStore, viewDataSourceFactory: self.dependencyManager.viewDataSourceFactory, addressBook: self.dependencyManager.addressBook)
//        var invitationNavVC = UINavigationController(rootViewController: partyInvitationVC)
//        partyInvitationVC.delegate = self
//        self.topViewController!.present(invitationNavVC, animated: true, completion: { _ in })
    }
    // MARK: Delegate
    
    func partyInvitationViewControllerDidSkipSendingInvitesAndWants(toShowTicket invite: PFObject) {
        window.rootViewController!.dismiss(animated: true, completion: {() -> Void in
            self.presentPartyNavigationControllerforTicket(invite: invite)
        })
    }
    
    func partyInvitationViewControllerDidSubmitInvitesAndWants(toShowTicket invite: PFObject) {
        window.rootViewController!.dismiss(animated: true, completion: {() -> Void in
            self.presentPartyNavigationControllerforTicket(invite: invite)
        })
    }
    
    // MARK: Payment View Controller
    func presentPaymentViewController(on viewController: UIViewController) {
        if (THLUser.current()?.stripeCustomerId != nil) {
            SVProgressHUD.show()
            PFCloud.callFunction(inBackground: "retrievePaymentInfo", withParameters: nil) {
                (cardInfo, error) in
                SVProgressHUD.dismiss()
                if (error != nil) {
                    
                } else {
                    var paymentView = THLPaymentViewController(paymentInfo: cardInfo as! [[AnyHashable: Any]])
                    paymentView?.hidesBottomBarWhenPushed = true
                    viewController.navigationController!.pushViewController(paymentView!, animated: true)
                }
            }
        }
        else {
            var emptyCardInfoSet = [[AnyHashable: Any]]()
            var paymentView = THLPaymentViewController(paymentInfo: emptyCardInfoSet)
            paymentView?.hidesBottomBarWhenPushed = true
            viewController.navigationController!.pushViewController(paymentView!, animated: true)
        }
    }
    
    // MARK: Party Navigation View Controller Delegate
    internal func presentPartyNavigationControllerforTicket(invite: PFObject) {
        let partyNavVC = UINavigationController()
        let partyNavigationController = THLPartyNavigationController(guestlistInvite: invite)
        partyNavigationController?.eventDetailsVC.delegate = self
        partyNavigationController?.partyVC.delegate = self
        partyNavigationController?.addChildViewController(partyNavigationController!)
        window.rootViewController!.present(partyNavVC, animated: true, completion: { _ in })
        if guestMainTabBarController.selectedIndex != 2 {
            guestMainTabBarController.selectedIndex = 2
        }
    }
    
    internal func presentPartyNavigationControllerforTableReservation(invite: PFObject) {
        let partyNavVC = UINavigationController()
        let partyNavigationController = THLPartyNavigationController(guestlistInvite: invite)
        partyNavigationController?.eventDetailsVC.delegate = self
        //    partyNavigationController.partyVC.delegate = self;
        partyNavVC.addChildViewController(partyNavigationController!)
        if self.topViewController() != guestMainTabBarController {
            guestMainTabBarController.dismiss(animated: true, completion: { _ in })
        }
        window.rootViewController!.present(partyNavVC, animated: true, completion: { _ in })
        if guestMainTabBarController.selectedIndex != 2 {
            guestMainTabBarController.selectedIndex = 2
        }
    }
    
    internal func partyViewControllerWantsToPresentInvitationController(for event: THLEvent!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!) {
        
    }
    
    internal func partyViewControllerWantsToPresentCheckout(forEvent event: PFObject!, with guestlistInvite: THLGuestlistInvite!) {
        
    }
    
    // MARK: Table Package View Controller Delegate
    public func packageControllerWantsToPresentCheckout(forEvent event: PFObject!, andAdmissionOption admissionOption: PFObject!) {
        
    }

    public func didLoadObjects() {
        
    }
    
    internal func didSubmitInquiry(_ inquiry: PFObject) {
        
    }

    internal func didSelectViewInquiry(_ guestlistInvite: PFObject) {
        
    }
    
    internal func didSelectViewEventTicket(_ guestlistInvite: PFObject) {
        
    }

    internal func didSelectViewHostedEvent(_ guestlistInvite: PFObject) {
        
    }

    public func venueDiscoveryViewControllerWantsToPresentDetails(forVenue event: PFObject!) {
        
    }
    
    internal func userProfileViewControllerWantsToLogout() {
        
    }
    
    internal func userProfileViewControllerWantsToPresentPaymentViewController() {
        
    }
    
    
    func topViewController() -> UIViewController {
        return self.topViewController(UIApplication.shared.keyWindow!.rootViewController!)
    }
    
    func topViewController(_ rootViewController: UIViewController) -> UIViewController {
        if rootViewController.presentedViewController == nil {
            return rootViewController
        }
        if type(of: rootViewController.presentedViewController) == UINavigationController.self {
            let navigationController = (rootViewController.presentedViewController as! UINavigationController)
            let lastViewController = navigationController.viewControllers.last!
            return self.topViewController(lastViewController)
        }
        let presentedViewController = (rootViewController.presentedViewController as UIViewController!)
        return self.topViewController(presentedViewController!)
    }

}
