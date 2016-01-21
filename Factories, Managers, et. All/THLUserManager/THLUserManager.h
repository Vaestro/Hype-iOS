//
//  THLUserManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLUser;
@class BFTask;

@interface THLUserManager : NSObject
@property (nonatomic, readonly) THLUser *currentUser;

+ (BOOL)userLoggedIn;
+ (BOOL)userIsGuest;
+ (BOOL)userIsHost;
+ (BOOL)isUserCached;
+ (void) logCrashlyticsUser;
+ (void)logUserOut;
+ (BOOL)isUserVerified;
+ (BFTask *)makeCurrentInstallation;
//- (BFTask *)checkUserSessionValidity;

@end
