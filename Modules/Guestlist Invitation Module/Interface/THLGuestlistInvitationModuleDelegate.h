//
//  THLGuestlistInvitationModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLGuestlistInviteEntity;
@class THLGuestlistEntity;
@protocol THLGuestlistInvitationModuleInterface;
@protocol THLGuestlistInvitationModuleDelegate <NSObject>
//- (void)guestlistInvitationModule:(id<THLGuestlistInvitationModuleInterface>)module userDidCommitChangesToGuestlist:(NSString *)guestlistId;
- (void)dismissGuestlistInvitationWireframe;
- (void)dismissWireframeAndPresentGuestlistReviewWireframeFor:(THLGuestlistInviteEntity *)guestlistInvite guestlist:(THLGuestlistEntity *)guestlist;
@end
