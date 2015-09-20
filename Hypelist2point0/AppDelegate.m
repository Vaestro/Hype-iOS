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
#import <Crashlytics/Crashlytics.h>
#import <DigitsKit/DigitsKit.h>

#import "THLDependencyManager.h"
#import "THLMasterWireframe.h"


@interface AppDelegate ()
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLDependencyManager *dependencyManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Initialize Parse.
	[Parse setApplicationId:@"D0AnOPXqqfz7bfE70WvdlE8dK7Qj1kxgf4rPm8rX"
				  clientKey:@"deljp8TeDlGAvlNeN58H7K3e3qJkQbDujkv3rpjq"];

	// [Optional] Track statistics around application opens.
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[PFFacebookUtils initializeFacebook];
	[Fabric with:@[[Crashlytics class], [Digits class]]];



	_dependencyManager = [[THLDependencyManager alloc] init];
	_masterWireframe = [_dependencyManager masterWireframe];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_masterWireframe presentAppInWindow:self.window];
	
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[FBSDKAppEvents activateApp];
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
