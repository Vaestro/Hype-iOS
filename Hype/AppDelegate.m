//
//  AppDelegate.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/20/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PFFacebookUtils.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import "Branch.h"
#import <Stripe/Stripe.h>
#import "THLDependencyManager.h"
#import "THLMasterWireframe.h"
#import "THLAppearanceUtils.h"
#import "Intercom/intercom.h"
#import <Harpy/Harpy.h>
#import "THLAppearanceConstants.h"

#if DEBUG
static NSString *applicationId = @"5t3F1S3wKnVGIKHob1Qj0Je3sygnFiwqAu6PP400";
static NSString *clientKeyId = @"xn4Mces2HcFCQYXF2VRj4W1Ot0zIBELl6fHKLGPk";
static NSString *stripePublishableKey = @"pk_test_cGZ7E1Im6VPKQHYUXIkR6sEe";
static NSString *mixpanelToken = @"aa573c8ee35b386bff7635df03bdbf18";

#else
static NSString *stripePublishableKey = @"pk_live_H8u89AfEDonln00iEUB0kKtZ";
static NSString *mixpanelToken = @"2946053341530a84c490a107bd3e5fff";
static NSString *applicationId = @"D0AnOPXqqfz7bfE70WvdlE8dK7Qj1kxgf4rPm8rX";
static NSString *clientKeyId = @"deljp8TeDlGAvlNeN58H7K3e3qJkQbDujkv3rpjq";
#endif

@interface AppDelegate (){
    BOOL firstLaunch;
}
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLDependencyManager *dependencyManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    #if DEBUG
        [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = applicationId;
            configuration.clientKey = clientKeyId;
            configuration.server = @"https://powerful-tundra-19716.herokuapp.com/parse/";
//           configuration.server = @"https://51770b13.ngrok.io/parse/";
            configuration.localDatastoreEnabled = YES;
        }]];
//    #else
//        // Initialize Parse.
//        [Parse enableLocalDatastore];
//        [Parse setApplicationId:applicationId
//                  clientKey:clientKeyId];
//    #endif
    
    // Track app open
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    
    //Initialize Intercom
    [Intercom setApiKey:@"ios_sdk-3899f433e0b112fe8daff2cc4f8bfdff18fad071" forAppId:@"eixn8wsn"];
    [Intercom enableLogging];
    
    //Stripe
    [Stripe setDefaultPublishableKey:stripePublishableKey];
    [[STPPaymentConfiguration sharedConfiguration] setSmsAutofillDisabled:YES];
    [[STPTheme defaultTheme] setPrimaryBackgroundColor:kTHLNUIPrimaryBackgroundColor];
    [[STPTheme defaultTheme] setSecondaryBackgroundColor:kTHLNUISecondaryBackgroundColor];
    [[STPTheme defaultTheme] setPrimaryForegroundColor:kTHLNUIPrimaryFontColor];
    [[STPTheme defaultTheme] setSecondaryForegroundColor:kTHLNUIAccentColor];

    [[STPTheme defaultTheme] setAccentColor:kTHLNUIAccentColor];
    
    // [Optional] Track statistics around application opens.
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:(launchOptions)];
    
    [Fabric with:@[[Digits class], [Crashlytics class]]];

    [Mixpanel sharedInstanceWithToken:mixpanelToken];
    
	[THLAppearanceUtils applyStyles];

	_dependencyManager = [[THLDependencyManager alloc] init];
	_masterWireframe = [_dependencyManager masterWireframe];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_masterWireframe presentAppInWindow:self.window];
	
    // Set the App ID for Harpy
//    [[Harpy sharedInstance] setAppID:@"com.hypelist.hype"];
    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    // (Optional) Set the App Name for your app
    [[Harpy sharedInstance] setAppName:@"Hype"];
    // (Optional) Set the Alert Type for your app
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeForce];
    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
    
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationPayload) {
        [_masterWireframe handlePushNotification:notificationPayload];
    } else{
//        NSLog(@"app did not recieve notification");
    }
    
    // Initialize Branch
    Branch *branch = [Branch getInstance];
    
    //    This will allow the Branch SDK to pass the user’s Mixpanel Distinct ID to our servers. Branch will then pass that Distinct ID to Mixpanel when logging any event.
    [[Branch getInstance] setRequestMetadataKey:@"$mixpanel_distinct_id" value:[Mixpanel sharedInstance].distinctId];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        // params are the deep linked params associated with the link that the user clicked before showing up.
        if ([params[BRANCH_INIT_KEY_CLICKED_BRANCH_LINK] boolValue]) {
            [[Mixpanel sharedInstance] track:@"install" properties:params];
        }
    }];
    
//	return [[FBSDKApplicationDelegate sharedInstance] application:application
//									didFinishLaunchingWithOptions:launchOptions];
    return true;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
     
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:deviceToken];
    
    [Intercom setDeviceToken:deviceToken];
    [_masterWireframe applicationDidRegisterForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code != 3010) {
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    //register to receive notifications
//    [application registerForRemoteNotifications];
//}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[_masterWireframe handlePushNotification:userInfo] continueWithBlock:^id(BFTask *task) {
        if (completionHandler) {
            UIBackgroundFetchResult result = (!task.faulted) ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultFailed;
            completionHandler(result);
        }
        return nil;
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Clear badge and update installation, required for auto-incrementing badges.
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    // Clears out all notifications from Notification Center.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    
    [FBSDKAppEvents activateApp];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Perform check for new version of your app
     Useful if user returns to you app from background after being sent tot he App Store,
     but doesn't update their app before coming back to your app.
     
     ONLY USE THIS IF YOU ARE USING *HarpyAlertTypeForce*
     
     Also, performs version check on first launch.
     */
    [[Harpy sharedInstance] checkVersion];
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
    
    NSLog(@"%@", url);
    
    [[Branch getInstance] handleDeepLink:url];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}

#pragma mark - ()




@end
