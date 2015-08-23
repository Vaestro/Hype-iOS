//
//  AppDelegate.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/20/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Initialize Parse.
	[Parse setApplicationId:@"D0AnOPXqqfz7bfE70WvdlE8dK7Qj1kxgf4rPm8rX"
				  clientKey:@"deljp8TeDlGAvlNeN58H7K3e3qJkQbDujkv3rpjq"];

	// [Optional] Track statistics around application opens.
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

	return YES;
}
@end
