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
#import <Optimizely/Optimizely.h>

//#import <Stripe/Stripe.h>

#import "THLDependencyManager.h"
#import "THLMasterWireframe.h"
#import "THLAppearanceUtils.h"

#if DEBUG
static NSString *applicationId = @"5t3F1S3wKnVGIKHob1Qj0Je3sygnFiwqAu6PP400";
static NSString *clientKeyId = @"xn4Mces2HcFCQYXF2VRj4W1Ot0zIBELl6fHKLGPk";
#else
static NSString *applicationId = @"D0AnOPXqqfz7bfE70WvdlE8dK7Qj1kxgf4rPm8rX";
static NSString *clientKeyId = @"deljp8TeDlGAvlNeN58H7K3e3qJkQbDujkv3rpjq";
#endif

@interface AppDelegate ()
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLDependencyManager *dependencyManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	// Initialize Parse.
    [Parse enableLocalDatastore];
	[Parse setApplicationId:applicationId
				  clientKey:clientKeyId];

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
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
    
//    TODO: Add Stripe class with:  [STPAPIClient class]
    [Fabric with:@[[Digits class], [Optimizely class], [Crashlytics class]]];

    [Optimizely startOptimizelyWithAPIToken:@"AANLIOMBQFi_hFw1wzxiRVDv6GfuC4rH~4568187528" launchOptions:launchOptions];

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
    
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.deviceToken = @"";
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [[currentInstallation saveInBackground] continueWithBlock:^id(BFTask *task) {
        
        return nil;
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

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
	[FBSDKAppEvents activateApp];   
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														  openURL:url
												sourceApplication:sourceApplication
													   annotation:annotation];
}

@end
