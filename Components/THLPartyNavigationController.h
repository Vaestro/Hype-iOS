//
//  THLPartyNavigationController.h
//  Hype
//
//  Created by Edgar Li on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "THLPartyViewController.h"
#import "THLEventDetailsViewController.h"
#import "RKSwipeBetweenViewControllers.h"

@class PFObject;
//@protocol THLPartyNavigationControllerDelegate <NSObject>
//- (void)partyNavigationControllerWantsToPresentInvitationControllerFor:(THLEvent *)event guestlistId:(NSString *)guestlistId currentGuestsPhoneNumbers:(NSArray *)currentGuestsPhoneNumbers;
//- (void)partyNavigationControllerWantsToPresentCheckoutForEvent:(PFObject *)event withGuestlistInvite:(THLGuestlistInvite *)guestlistInvite;
//@end

@interface THLPartyNavigationController : RKSwipeBetweenViewControllers
//@property (nonatomic, weak) id<THLPartyNavigationControllerDelegate> delegate;

@property (nonatomic, strong) THLPartyViewController *partyVC;
@property (nonatomic, strong) THLEventDetailsViewController *eventDetailsVC;

- (id)initWithGuestlistInvite:(PFObject *)guestlistInvite;
@end
