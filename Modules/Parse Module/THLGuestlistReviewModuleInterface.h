//
//  THLGuestlistReviewModuleInterface.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistReviewModuleDelegate.h"

@class THLGuestlistEntity;
@protocol THLGuestlistReviewModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistReviewModuleDelegate> moduleDelegate;

- (void)presentGuestlistReviewModuleForGuestlist:(THLGuestlistEntity *)guestlistEntity forReviewer:(NSString *)reviewer inController:(UIViewController *)controller;

@end
