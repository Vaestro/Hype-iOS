//
//  AppDelegate.swift
//  Hype
//
//  Created by Edgar Li on 11/16/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
import Stripe
import ParseFacebookUtilsV4
import Mixpanel
import Branch
import AVFoundation

#if DEBUG
    let stripePublishableKey = "pk_test_cGZ7E1Im6VPKQHYUXIkR6sEe"
    let mixpanelToken = "aa573c8ee35b386bff7635df03bdbf18"
#else
    let stripePublishableKey = "pk_live_H8u89AfEDonln00iEUB0kKtZ"
    let mixpanelToken = "2946053341530a84c490a107bd3e5fff"
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.server = "https://powerful-tundra-19716.herokuapp.com/parse/" // '/' important after 'parse'
            configuration.applicationId = "5t3F1S3wKnVGIKHob1Qj0Je3sygnFiwqAu6PP400"
            configuration.clientKey = "xn4Mces2HcFCQYXF2VRj4W1Ot0zIBELl6fHKLGPk"
            configuration.isLocalDatastoreEnabled = true
        }))
        
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        if (application.applicationIconBadgeNumber != 0) {
            application.applicationIconBadgeNumber = 0
            PFInstallation.current()?.saveInBackground()
        }
        
        Stripe.setDefaultPublishableKey(stripePublishableKey)
        STPPaymentConfiguration.shared().smsAutofillDisabled = true
        STPTheme.default().primaryBackgroundColor = UIColor.black
        STPTheme.default().secondaryBackgroundColor = UIColor.black
        STPTheme.default().primaryForegroundColor = UIColor.white
        STPTheme.default().secondaryForegroundColor = UIColor.customGoldColor()
        STPTheme.default().accentColor = UIColor.customGoldColor()
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        Mixpanel.initialize(token: mixpanelToken)
        
        let branch = Branch.getInstance()
        branch?.setRequestMetadataKey("$mixpanel_distinct_id", value: Mixpanel.mainInstance().distinctId as NSObject!)
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {
            (params, error) -> Void in
            if error == nil {
                Mixpanel.mainInstance().track(event: "install")
            }
        })
        
        

        THLAppearanceUtils.applyStyles()
        
        let masterRouter = THLMasterRouter()
        masterRouter.presentApp(in: window!)

        return true
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let currentInstallation = PFInstallation.current()
        currentInstallation?.setDeviceTokenFrom(deviceToken as Data)
        currentInstallation?.saveInBackground()
        // This sends the deviceToken to Mixpanel
        let mixpanel = Mixpanel.mainInstance()
        mixpanel.people.addPushDeviceToken(deviceToken as Data)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        PFPush.handle(userInfo)
        if application.applicationState == .inactive {
            // The application was just brought from the background to the foreground,
            // so we consider the app as having been "opened by a push notification."
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
        Branch.getInstance().handlePushNotification(userInfo)

    }

    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        //handle the actions
        if (identifier == "declineAction") {
            
        }
        else if (identifier == "answerAction") {
            
        }

    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Clear badge and update installation, required for auto-incrementing badges.
        if application.applicationIconBadgeNumber != 0 {
            application.applicationIconBadgeNumber = 0
            PFInstallation.current()?.saveInBackground()
        }
        // Clears out all notifications from Notification Center.
        UIApplication.shared.cancelAllLocalNotifications()
        application.applicationIconBadgeNumber = 1
        application.applicationIconBadgeNumber = 0
        FBSDKAppEvents.activateApp()

    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().handleDeepLink(url)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let handledByBranch:Bool = Branch.getInstance().continue(userActivity)
        
        return handledByBranch
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
