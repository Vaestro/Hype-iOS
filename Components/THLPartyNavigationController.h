//
//  THLPartyNavigationController.h
//  Hype
//
//  Created by Edgar Li on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <RKSwipeBetweenViewControllers/RKSwipeBetweenViewControllers.h>
@class PFObject;

@interface THLPartyNavigationController : RKSwipeBetweenViewControllers
- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite;
@end
