//
//  AppDelegate.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/20/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PFFacebookUtils.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <Optimizely/Optimizely.h>
#import "Branch.h"
#import <Stripe/Stripe.h>
#import "THLDependencyManager.h"
#import "THLMasterWireframe.h"
#import "THLAppearanceUtils.h"
#import "Intercom/intercom.h"
#import "Mixpanel.h"

//Logging framework
#import "CocoaLumberjack.h"
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define MIXPANEL_TOKEN @"2946053341530a84c490a107bd3e5fff"

#if DEBUG
static NSString *applicationId = @"5t3F1S3wKnVGIKHob1Qj0Je3sygnFiwqAu6PP400";
static NSString *clientKeyId = @"xn4Mces2HcFCQYXF2VRj4W1Ot0zIBELl6fHKLGPk";
#else
static NSString *applicationId = @"D0AnOPXqqfz7bfE70WvdlE8dK7Qj1kxgf4rPm8rX";
static NSString *clientKeyId = @"deljp8TeDlGAvlNeN58H7K3e3qJkQbDujkv3rpjq";
#endif

@interface AppDelegate (){
    BOOL firstLaunch;
}
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLDependencyManager *dependencyManager;
@property (nonatomic, strong) MBProgressHUD *hud;

- (BOOL)shouldProceedToMainInterface:(PFUser *)user;
- (BOOL)handleActionURL:(NSURL *)url;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// Initialize Parse.
    [Parse enableLocalDatastore];
	[Parse setApplicationId:applicationId
				  clientKey:clientKeyId];
    
    // Track app open
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    
    //Initialize Intercom
    [Intercom setApiKey:@"ios_sdk-3899f433e0b112fe8daff2cc4f8bfdff18fad071" forAppId:@"eixn8wsn"];
    [Intercom enableLogging];
    [Intercom setPreviewPosition:ICMPreviewPositionTopLeft];
    
    //Stripe
    [Stripe setDefaultPublishableKey:@"pk_test_cGZ7E1Im6VPKQHYUXIkR6sEe"];
    
    //Configuring Lumberjack logging framework
    setenv("XcodeColors", "YES", 0);
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
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

    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:mixpanel.distinctId];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
	[THLAppearanceUtils applyStyles];

	_dependencyManager = [[THLDependencyManager alloc] init];
	_masterWireframe = [_dependencyManager masterWireframe];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_masterWireframe presentAppInWindow:self.window];
	
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationPayload) {
        NSLog(@"app recieved notification from remote%@", notificationPayload);
        [_masterWireframe handlePushNotification:notificationPayload];
    } else{
        NSLog(@"app did not recieve notification");
    }
    
    // Initialize Branch
    Branch *branch = [Branch getInstance];
    //#warning Remove for launch
//    Branch *branch = [Branch getTestInstance];
    
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        // params are the deep linked params associated with the link that the user clicked before showing up.
        NSLog(@"deep link data: %@", [params description]);
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
