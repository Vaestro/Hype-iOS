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

@protocol THLPartyViewControllerDelegate <NSObject>
- (void)partyViewControllerWantsToPresentInvitationControllerFor:(THLEvent *)event guestlistId:(NSString *)guestlistId;
- (void)partyViewControllerWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo;
@end

@interface THLPartyViewController : PFQueryCollectionViewController
@property (nonatomic, weak) id<THLPartyViewControllerDelegate> delegate;

- (instancetype)initWithClassName:(NSString *)className guestlist:(PFObject *)guestlist usersInvite:(PFObject *)usersInvite;
@end
