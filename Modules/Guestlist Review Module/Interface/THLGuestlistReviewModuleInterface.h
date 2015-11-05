//
//  THLGuestlistReviewModuleInterface.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistReviewModuleDelegate.h"
@class THLGuestlistInviteEntity;
@class THLGuestlistEntity;
@protocol THLGuestlistReviewModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistReviewModuleDelegate> moduleDelegate;

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller;

@end
