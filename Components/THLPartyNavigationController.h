//
//  THLPartyNavigationController.h
//  Hype
//
//  Created by Edgar Li on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <RKSwipeBetweenViewControllers/RKSwipeBetweenViewControllers.h>
#import "THLPartyViewController.h"
#import "THLEventDetailsViewController.h"

@class PFObject;

@interface THLPartyNavigationController : RKSwipeBetweenViewControllers
@property (nonatomic, strong) THLPartyViewController *partyVC;
@property (nonatomic, strong) THLEventDetailsViewController *eventDetailsVC;

- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite;
@end
