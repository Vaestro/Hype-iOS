//
//  THLPartyViewController.h
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
@class THLEvent;
@class THLGuestlistInvite;

@protocol THLPartyViewControllerDelegate <NSObject>
- (void)partyViewControllerWantsToPresentInvitationControllerFor:(THLEvent *)event guestlistId:(NSString *)guestlistId currentGuestsPhoneNumbers:(NSArray *)currentGuestsPhoneNumbers;
- (void)partyViewControllerWantsToPresentCheckoutForEvent:(PFObject *)event withGuestlistInvite:(THLGuestlistInvite *)guestlistInvite;
@end

@interface THLPartyViewController : PFQueryCollectionViewController
@property (nonatomic, weak) id<THLPartyViewControllerDelegate> delegate;

- (instancetype)initWithClassName:(NSString *)className guestlist:(PFObject *)guestlist usersInvite:(PFObject *)usersInvite;
@end
