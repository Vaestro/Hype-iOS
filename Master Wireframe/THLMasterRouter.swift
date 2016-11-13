//
//  THLMasterRouter.swift
//  Hype
//
//  Created by Edgar Li on 11/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

@objc class THLMasterRouter: NSObject, THLWelcomeViewDelegate {
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
    
    func presentWelcomeView() {
        self.welcomeView.delegate = self
        let onboardingNavigationController = UINavigationController()
        onboardingNavigationController.addChildViewController(welcomeView)
        self.window.rootViewController = onboardingNavigationController
        window.makeKeyAndVisible()
    }
    
    func didConnectWithFacebookAndReceivedUserData(userData:[String:AnyObject]) {
        presentAccountRegistrationView(userData:userData)
    }
    
    func presentAccountRegistrationView(userData:[String:AnyObject]) {
        let accountRegistrationViewController = THLAccountRegistrationViewController(userData)
        welcomeView.navigationController?.pushViewController(accountRegistrationViewController, animated: true)
    }
}
