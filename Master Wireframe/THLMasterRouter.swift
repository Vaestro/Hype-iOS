//
//  THLMasterRouter.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

@objc class THLMasterRouter: NSObject, THLWelcomeViewDelegate, THLSwiftLoginViewControllerDelegate {
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
    
    // Welcome View Controller
    func presentWelcomeView() {
        self.welcomeView.delegate = self
        let onboardingNavigationController = UINavigationController()
        onboardingNavigationController.addChildViewController(welcomeView)
        self.window.rootViewController = onboardingNavigationController
        window.makeKeyAndVisible()
    }
    
    //WelcomeViewController Delegate
    func welcomeViewWantsToPresentLoginView() {
        let loginView = THLSwiftLoginViewController()
        loginView.delegate = self
        welcomeView.navigationController?.pushViewController(loginView, animated: true)
    }
    
    func welcomeViewDidConnectWithFacebookAndReceivedUserData(userData:[String:AnyObject]) {
        presentAccountRegistrationView(userData:userData)
    }
    
    func welcomeViewDidLoginWithFacebookAndWantsToPresentGuestInterface() {
        
    }
    
    //Account Registration View Controller
    
    func presentAccountRegistrationView(userData:[String:AnyObject]) {
        let accountRegistrationViewController = THLAccountRegistrationViewController(userData)
        welcomeView.navigationController?.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    //Login View Controller Delegate
    func loginViewWantsToPresentAccountRegistration() {
        let accountRegistrationViewController = THLAccountRegistrationViewController(nil)
        welcomeView.navigationController?.pushViewController(accountRegistrationViewController, animated: true)
    }
    
    func didLogin() {
        
    }
}
