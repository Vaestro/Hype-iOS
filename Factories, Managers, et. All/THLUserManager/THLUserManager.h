//
//  THLUserManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLUser;
@interface THLUserManager : NSObject
@property (nonatomic, readonly) THLUser *currentUser;

- (BOOL)userLoggedIn;

@end
