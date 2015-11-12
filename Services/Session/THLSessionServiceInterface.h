//
//  THLSessionServiceInterface.h
//  Hypelist2point0
//
//  Created by Paul Dariye on 10/14/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;

@protocol THLSessionServiceInterface <NSObject>

//- (BFTask *)checkUserSessionValidity;
- (BOOL)isUserCached;
- (void) logCrashlyticsUser;
- (void)logUserOut;
- (BFTask *)makeCurrentInstallation;
@end