//
//  THLMasterRouter.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

@objc class THLMasterRouter: NSObject, THLWelcomeViewDelegate, THLAccountRegistrationViewControllerDelegate, THLSwiftLoginViewControllerDelegate, THLEventDiscoveryViewControllerDelegate, THLVenueDiscoveryViewControllerDelegate, THLGuestProfileViewControllerDelegate {

    var window: UIWindow
    var welcomeView: THLWelcomeViewController

    override init() {
        self.window = UIWindow()
        self.welcomeView = THLWelcomeViewController()

        super.init()
    }
    
    func presentApp(in window: UIWindow) {
        self.window = window
        if THLUserManager.isUserCached() && THLUserManager.isUserProfileValid() {
            self.presentWelcomeView()

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
        let guestMainTabBarController = UITabBarController()
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
    }
    
    // MARK: Event Discovery View Controller Delegate
    func eventDiscoveryViewControllerWantsToPresentDetailsForEvent(_ event: PFObject, venue: PFObject) {
        
    }
    
    internal func eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent(_ event: PFObject, venue: PFObject, invite: PFObject) {
        
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

}
