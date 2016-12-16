//
//  THLMasterRouter.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

import SVProgressHUD
import Bolts
import Branch
import Parse

@objc class THLMasterRouter: NSObject, THLWelcomeViewDelegate, THLAccountRegistrationViewControllerDelegate, THLSwiftLoginViewControllerDelegate, THLDiscoveryViewControllerDelegate, THLGuestProfileViewControllerDelegate, THLEventDetailsViewControllerDelegate, THLSwiftAdmissionsViewControllerDelegate, THLPartyViewControllerDelegate, THLCheckoutViewControllerDelegate, THLTablePackageControllerDelegate, EPPickerDelegate, THLInquiryOffersViewControllerDelegate, THLUserProfileViewControllerDelegate, THLAvailableInquiriesViewControllerDelegate, THLInquiryMenuViewControllerDelegate, THLSubmitInquiryOfferViewControllerDelegate, THLPartyMenuControllerDelegate {

    public func partyViewControllerWantsToPresentInvitationController(for event: THLEvent!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!) {
        
    }




    var window: UIWindow
    
    override init() {
        self.window = UIWindow()
        super.init()
    }
    
    func presentApp(in window: UIWindow) {
        self.window = window
        if THLUserManager.isUserCached() && THLUserManager.isUserProfileValid() {
            self.routeLoggedInUser()
        }
        else {
            self.presentWelcomeView()
        }
    }
    
    func routeLoggedInUser() {
        if THLUserManager.userIsHost() {
            self.presentHostInterface()
        } else {
            self.presentGuestInterface()
        }
    }
    
    // MARK: Welcome View Controller
    func presentWelcomeView() {
        let welcomeView = THLWelcomeViewController()
        welcomeView.delegate = self
        let onboardingNavigationController = UINavigationController()
        onboardingNavigationController.addChildViewController(welcomeView)
        self.window.rootViewController = onboardingNavigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: WelcomeViewControllerDelegate
    func welcomeViewWantsToPresentLoginView() {
        let loginView = THLSwiftLoginViewController()
        loginView.delegate = self
        let navigationController = (window.rootViewController as! UINavigationController)
        navigationController.pushViewController(loginView, animated: true)
    }
    
    func welcomeViewDidConnectWithFacebookAndReceivedUserData(userData:[String:AnyObject]) {
        presentAccountRegistrationView(userData:userData)
    }
    
    func welcomeViewDidLoginWithFacebookAndWantsToPresentGuestInterface() {
        self.routeLoggedInUser()
    }
    
    // MARK: Account Registration View Controller
    
    func presentAccountRegistrationView(userData:[String:AnyObject]) {
        let accountRegistrationViewController = THLAccountRegistrationViewController(userData)
        accountRegistrationViewController.delegate = self
        let navigationController = (window.rootViewController as! UINavigationController)
        navigationController.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    // MARK: Account Registration View Controller Delegate
    func accountRegistrationViewDidCompleteRegistration() {
        THLChatSocketManager.sharedInstance.createSupportChatRoom()
        presentGuestInterface()
    
    }
    
    // MARK: Login View Controller Delegate
    func loginViewWantsToPresentAccountRegistration() {
        let accountRegistrationViewController = THLAccountRegistrationViewController(nil)
        accountRegistrationViewController.delegate = self
        let navigationController = (window.rootViewController as! UINavigationController)
        navigationController.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    func loginViewDidLoginAndWantsToPresentGuestInterface() {
        self.routeLoggedInUser()
    }
    
    func presentGuestInterface() {

        // Connect to chat server socket first
        THLChatSocketManager.sharedInstance.establishConnection()
        THLChatSocketManager.sharedInstance.checkAndCreateSupportChat()
        let guestMainTabBarController = UITabBarController()

        let discoveryView = THLDiscoveryViewController()
        discoveryView.delegate = self
//        let discoveryNavigationController = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
//        discoveryNavigationController.pushViewController(discoveryView, animated: false)
        
        let guestProfileView = THLGuestProfileViewController()
        guestProfileView.delegate = self
        let profileNavigationController = UINavigationController()
        profileNavigationController.pushViewController(guestProfileView, animated: false)
        
        let conversationsNavigationController = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        let conversationsView = THLChatEntryTableViewController()
        conversationsNavigationController.pushViewController(conversationsView, animated: false)
        conversationsNavigationController.tabBarItem.image = UIImage(named: "message")!
        discoveryView.tabBarItem.image = UIImage(named: "Home Icon")!
        profileNavigationController.tabBarItem.image = UIImage(named: "Profile Icon")!
        
        let views = [discoveryView, conversationsNavigationController, profileNavigationController]
        
        guestMainTabBarController.viewControllers = views
        guestMainTabBarController.selectedIndex = 0
        guestMainTabBarController.view.autoresizingMask = (.flexibleHeight)
        
        window.rootViewController = guestMainTabBarController
        window.makeKeyAndVisible()
    }
    
    func presentHostInterface() {
        THLChatSocketManager.sharedInstance.establishConnection()
        THLChatSocketManager.sharedInstance.checkAndCreateSupportChat()
        
        let hostTabBarController = UITabBarController()
        let inquiryDiscoveryView = THLAvailableInquiriesViewController()
        inquiryDiscoveryView.delegate = self
        let inquiryDiscoveryNavigationController = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        inquiryDiscoveryNavigationController.addChildViewController(inquiryDiscoveryView)
        
        inquiryDiscoveryNavigationController.tabBarItem.image = UIImage(named: "Home Icon")!

        let guestProfileView = THLGuestProfileViewController()
        guestProfileView.delegate = self
        let profileNavigationController = UINavigationController()
        profileNavigationController.pushViewController(guestProfileView, animated: false)
        profileNavigationController.tabBarItem.image = UIImage(named: "Profile Icon")!

        let conversationsNavigationController = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        let conversationsView = THLChatEntryTableViewController()
        conversationsNavigationController.pushViewController(conversationsView, animated: false)
        conversationsNavigationController.tabBarItem.image = UIImage(named: "message")!
        
        let views = [inquiryDiscoveryNavigationController, conversationsNavigationController, profileNavigationController]
        hostTabBarController.viewControllers = views
        hostTabBarController.selectedIndex = 0
        hostTabBarController.view.autoresizingMask = (.flexibleHeight)
        
        window.rootViewController = hostTabBarController
        window.makeKeyAndVisible()
    }
    
    // MARK: Discovery View Controller Delegate
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
    
    internal func venueDiscoveryViewControllerWantsToPresentDetails(forVenue venue: PFObject!) {
        let eventDetailView = THLEventDetailsViewController(venue: venue, event: nil, guestlistInvite: nil, showNavigationBar: true)
        eventDetailView?.delegate = self
        window.rootViewController!.present(eventDetailView!, animated: true, completion: { _ in })
    }
    
    // MARK: Event Details View Controller Delegate
    public func eventDetailsWantsToPresentAdmissions(forEvent event: PFObject?, venue: PFObject!) {
        let admissionsView = THLSwiftAdmissionsViewController(venue: venue, event: event)
        admissionsView.delegate = self
        let navigationViewController = UINavigationController(rootViewController: admissionsView)
        self.topViewController().present(navigationViewController, animated: true, completion: { _ in })
    }
    
    public func eventDetailsWantsToPresentParty(forEvent guestlistInvite: PFObject!) {
        window.rootViewController!.dismiss(animated: true, completion: {() -> Void in
            let guestlist:PFObject = guestlistInvite.value(forKey: "Guestlist") as! PFObject
            let admissionOption:PFObject = guestlist.value(forKey: "admissionOption") as! PFObject
            let admissionType:Int = admissionOption.value(forKey: "type") as! Int

            if (admissionType == 2) {
                let inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
                if ((inquiry.value(forKey: "connected") as! Bool) == true) {
                    self.presentPartyMenuforConnect(guestlistInvite)
                } else {
                    self.presentInquiryMenu(forInquiry: inquiry)
                }
            } else {
                self.presentPartyNavigationControllerforTicket(invite: guestlistInvite)
            }
        })
        let tabBarController = window.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 2
    }
    
    // MARK: Admissions View Controller Delegate
    internal func didSelectAdmissionOption(_ admissionOption: PFObject, event: PFObject) {
        let admissionType:Int = admissionOption.value(forKey: "type") as! Int
        if admissionType == 0 {
            let checkoutView = THLCheckoutViewController(event: event, admissionOption: admissionOption, guestlistInvite: nil)
            checkoutView?.delegate = self
            let topView = self.topViewController() as! UINavigationController
            topView.pushViewController(checkoutView!, animated: true)
        }
        else if admissionType == 1 {
            //        THLReservationRequestViewController *packageDetailsVC = [[THLReservationRequestViewController alloc] initWithEvent:event admissionOption:admissionOption];
            let packageDetailsView = THLTablePackageDetailsViewController(event: event, admissionOption: admissionOption, showActionButton: true)
            packageDetailsView?.delegate = self
            let topView = self.topViewController() as! UINavigationController
            topView.pushViewController(packageDetailsView!, animated: true)
        }
    }
    
    internal func didSelectHypeConnectForEvent(_ event: PFObject) {
        let contactPickerScene = EPContactsPicker(delegate: self, partyType: .connect, multiSelection:true, subtitleCellType: SubtitleCellValue.phoneNumber, event: event)
        let topView = self.topViewController() as! UINavigationController
        topView.pushViewController(contactPickerScene, animated: true)
    }

    
    // MARK: Checkout View Controller
    internal func presentCheckoutViewController(_ event: PFObject, guestlistInvite: THLGuestlistInvite, admissionOption: PFObject) {
        let checkoutView = THLCheckoutViewController(event: event, admissionOption: admissionOption, guestlistInvite: guestlistInvite)
        checkoutView?.delegate = self
        let topView = topViewController() as! UINavigationController
        topView.pushViewController(checkoutView!, animated: true)
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
        let contactPickerScene = EPContactsPicker(delegate: self, partyType: .generalAdmission, multiSelection:true, subtitleCellType: SubtitleCellValue.phoneNumber, event: event, guestlistId: guestlistId)
        let topView = self.topViewController() as! UINavigationController
        topView.pushViewController(contactPickerScene, animated: true)
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
    
    // MARK: InquiryOffersViewController
    internal func didAcceptInquiryOfferAndWantsToPresentPartyMenuWithInvite(_ guestlistInvite: PFObject) {
        self.presentPartyMenuforConnect(guestlistInvite)
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
                    let paymentView = THLPaymentViewController(paymentInfo: cardInfo as! [[AnyHashable: Any]])
                    paymentView?.hidesBottomBarWhenPushed = true
                    let topView = self.topViewController() as! UINavigationController

                    topView.pushViewController(paymentView!, animated: true)
                }
            }
        }
        else {
            let emptyCardInfoSet = [[AnyHashable: Any]]()
            let paymentView = THLPaymentViewController(paymentInfo: emptyCardInfoSet)
            paymentView?.hidesBottomBarWhenPushed = true
            let topView = self.topViewController() as! UINavigationController
            topView.pushViewController(paymentView!, animated: true)
        }
    }
    
    // MARK: Party Navigation View Controller Delegate
    internal func presentPartyNavigationControllerforTicket(invite: PFObject) {
        let partyNavVC = UINavigationController()
        let partyNavigationController = THLPartyNavigationController(guestlistInvite: invite)
        partyNavigationController?.eventDetailsVC.delegate = self
        partyNavigationController?.partyVC.delegate = self
        partyNavVC.addChildViewController(partyNavigationController!)
        window.rootViewController!.present(partyNavVC, animated: true, completion: { _ in })
        let tabBarController = window.rootViewController as! UITabBarController

        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
    }
    
    internal func presentPartyNavigationControllerforTableReservation(invite: PFObject) {
        let partyNavVC = UINavigationController()
        let partyNavigationController = THLPartyNavigationController(guestlistInvite: invite)
        partyNavigationController?.eventDetailsVC.delegate = self
        //    partyNavigationController.partyVC.delegate = self;
        partyNavVC.addChildViewController(partyNavigationController!)
        
        let tabBarController = window.rootViewController as! UITabBarController

        if self.topViewController() != tabBarController {
            tabBarController.dismiss(animated: true, completion: { _ in })
        }
        window.rootViewController!.present(partyNavVC, animated: true, completion: { _ in })
        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
    }
    
    internal func guestlistTableViewWantsToPresentInvitationController(for event: PFObject!, guestlistId: String!, currentGuestsPhoneNumbers: [Any]!) {
        let contactPickerScene = EPContactsPicker(delegate: self, partyType: .connect, multiSelection:true, subtitleCellType: SubtitleCellValue.phoneNumber, event: event, guestlistId: guestlistId)
        let topView = self.topViewController() as! UINavigationController
        topView.pushViewController(contactPickerScene, animated: true)
    }
    
    internal func partyViewControllerWantsToPresentCheckout(forEvent event: PFObject!, with guestlistInvite: THLGuestlistInvite!) {
        var admissionOptions = (event["admissionOptions"] as! [PFObject])
        var admissionOption: PFObject!
        SVProgressHUD.show()
        for option: PFObject in admissionOptions {
            let genderForOption = option.value(forKey: "gender") as? NSInteger
            if genderForOption == THLUser.current()?.sex.rawValue
            {
                admissionOption = option
            }
        }
        SVProgressHUD.dismiss()
        
        presentCheckoutViewController(event, guestlistInvite: guestlistInvite, admissionOption: admissionOption)
    }
    
    // MARK: Table Package View Controller Delegate
    public func packageControllerWantsToPresentCheckout(forEvent event: PFObject!, andAdmissionOption admissionOption: PFObject!) {
        let checkoutView = THLCheckoutViewController(event: event, admissionOption: admissionOption, guestlistInvite: nil)
        checkoutView?.delegate = self
        let topView = self.topViewController() as! UINavigationController
        topView.pushViewController(checkoutView!, animated: true)
    }

    public func didLoadObjects() {
        
    }
    
    public func epContactPickerDidSubmitInvitesAndWantsToShowEvent() {
        let tabBarController = window.rootViewController as! UITabBarController
        
        if self.topViewController() != tabBarController {
            tabBarController.dismiss(animated: true, completion: { _ in })
        }
        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
    }
    
    public func epContactPicker(_: EPContactsPicker, didSubmitInvitesAndWantsToShowInquiry: PFObject) {
        let tabBarController = window.rootViewController as! UITabBarController
        
        if self.topViewController() != tabBarController {
            tabBarController.dismiss(animated: true, completion: { _ in })
        }
        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
        
        self.presentOffersForInquiryWithGuestlistInvite(guestlistInvite: didSubmitInvitesAndWantsToShowInquiry)
    }
    
    func presentOffersForInquiryWithGuestlistInvite(guestlistInvite: PFObject) {
        let offersView = THLInquiryOffersViewController(guestlistInvite: guestlistInvite)
        offersView.delegate = self
        let navigationVC = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        navigationVC.addChildViewController(offersView)
        window.rootViewController!.present(navigationVC, animated: true, completion: { _ in })
    }

    internal func didSelectViewInquiry(_ guestlistInvite: PFObject) {
        presentPartyMenuforConnect(guestlistInvite)
    }
    
    internal func didSelectViewEventTicket(_ guestlistInvite: PFObject) {
        self.presentPartyNavigationControllerforTicket(invite: guestlistInvite)
    }

    internal func didSelectViewHostedEvent(_ guestlistInvite: PFObject) {
        presentPartyMenuforConnect(guestlistInvite)
    }
    internal func didSelectViewTableReservation(_ guestlistInvite: PFObject) {
        self.presentPartyNavigationControllerforTableReservation(invite: guestlistInvite)
    }
    
    internal func didSelectViewInquiryMenuView(_ inquiry:PFObject) {
        self.presentInquiryMenu(forInquiry: inquiry)
    }
    
    func presentInquiryMenu(forInquiry inquiry:PFObject) {
        let inquiryMenuController = THLInquiryMenuViewController(inquiry:inquiry)
        let navigationController = UINavigationController.init(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        navigationController.setViewControllers([inquiryMenuController], animated: false)
        window.rootViewController!.present(navigationController, animated: true, completion: { _ in })

    }
    internal func presentPartyMenuforConnect(_ invite: PFObject) {
        let partyMenu = THLPartyMenuController(guestlistInvite: invite)
        let navigationVC = UINavigationController(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        navigationVC.addChildViewController(partyMenu)
        partyMenu.delegate = self
        let tabBarController = window.rootViewController as! UITabBarController

        if self.topViewController() != tabBarController {
            tabBarController.dismiss(animated: true, completion: { _ in })
        }
        window.rootViewController!.present(navigationVC, animated: true, completion: { _ in })
        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
    }
    
    public func userProfileViewControllerWantsToLogout() {
        self.logOutUser()
    }
    
    internal func userProfileViewControllerWantsToPresentPaymentViewController() {
        self.presentPaymentViewController(on: topViewController())
    }
    
    
    func topViewController() -> UIViewController {
        return self.topViewController(window.rootViewController!)
    }
    
    func topViewController(_ rootViewController: UIViewController) -> UIViewController {
        if rootViewController.presentedViewController == nil {
            return rootViewController
        }
        if type(of: rootViewController.presentedViewController) == UINavigationController.self {
            let navigationController = (rootViewController.presentedViewController as! UINavigationController)
            let lastViewController = navigationController.visibleViewController!
            return self.topViewController(lastViewController)
        }
        let presentedViewController = (rootViewController.presentedViewController as UIViewController!)
        return self.topViewController(presentedViewController!)
    }
    
    func didWantToPresentInquiryMenuFor(inquiry: PFObject) {
        
        let inquiryMenuController = THLInquiryMenuViewController(inquiry:inquiry)
        inquiryMenuController.delegate = self
        let navigationController = UINavigationController.init(navigationBarClass: THLBoldNavigationBar.self, toolbarClass: nil)
        navigationController.setViewControllers([inquiryMenuController], animated: false)
        window.rootViewController!.present(navigationController, animated: true)
    }
    
    func didWantToPresentSubmitInquiryOfferView(inquiry: PFObject, availableVenues:[String]) {
        
        let submitInquiryView = THLSubmitInquiryOfferViewController(inquiry: inquiry, availableVenues:availableVenues)
        submitInquiryView.delegate = self
        let topView = self.topViewController() as! UINavigationController
        topView.pushViewController(submitInquiryView, animated: true)
    }
    
    internal func didSubmitInquiryOffer() {
        let tabBarController = window.rootViewController as! UITabBarController

        if self.topViewController() != tabBarController {
            tabBarController.dismiss(animated: true, completion: { _ in })
        }
        if tabBarController.selectedIndex != 2 {
            tabBarController.selectedIndex = 2
        }
    }
    
//    func handlePushNotification(_ pushInfo: [AnyHashable: Any]) -> BFTask {
//        if (pushInfo["guestlistInviteId"] as! String) {
//            var guestlistInviteId = pushInfo["guestlistInviteId"]
//            return
//                dependencyManager.guestlistService().fetchGuestlistInvite(withId: guestlistInviteId)
//            BFExecutor.mainThread()
//            var Nullable: Any?
//            do {
//                var invite = task.isResult
//                var popupView = THLPopupNotificationView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH * 0.87, height: SCREEN_HEIGHT * 0.67))
//                popupView.messageLabelText = "\(invite.sender.firstName) has invited you\nto party with friends at\n\(invite.event.location.name)\n\(invite.date!.thl_weekdayString) at \(invite.date!.thl_timeString)"
//                popupView.setImageViewWithURL(URL(string: invite.event.location.image.url)!)
//                popupView.iconURL = URL(string: invite.sender.image.url)!
//                popupView.buttonTitle = "View Invite"
//                popupView.setButtonTarget(self, action: #selector(self.viewInvites), forControlEvents: .touchUpInside)
//                var popup = KLCPopup(contentView: popupView, showType: KLCPopupShowTypeBounceIn, dismissType: KLCPopupDismissTypeBounceOut, maskType: KLCPopupMaskTypeDimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: true)
//                popup.dimmedMaskAlpha = 0.8
//                popup.show()
//                return task
//            }
//        }
//        else {
//            print("Notification was not a guestlistInvite")
//            return BFTask(result: nil)
//        }
//    }
    // MARK: - LogOut Handler

    func logOutUser() {
        THLUserManager.logUserOut()
        Branch.getInstance().logout()
        do {
            try PFObject.unpinAllObjects()
        } catch {
            
        }
        
        FBSDKAccessToken.setCurrent(nil)
        THLChatSocketManager.sharedInstance.closeConnection()
        
        let welcomeView = THLWelcomeViewController()
        window.rootViewController = welcomeView
        //    [_dependencyManager.databaseManager dropDB];
    }
}
