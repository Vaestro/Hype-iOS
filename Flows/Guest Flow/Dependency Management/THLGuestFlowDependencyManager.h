//
//  THLGuestFlowDependencyManager.h
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class THLMessageListWireframe;
@class THLEventDiscoveryWireframe;
@class THLDashboardWireframe;
@class THLUserProfileWireframe;
@class THLEventDetailWireframe;
@class THLGuestlistInvitationWireframe;
@class THLGuestlistReviewWireframe;
@class THLPerkStoreWireframe;
@class THLPerkDetailWireframe;

@protocol THLGuestFlowDependencyManager <NSObject>
//- (THLMessageListWireframe *)newMessageListWireframe;
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLDashboardWireframe *)newDashboardWireframe;
- (THLUserProfileWireframe *)newUserProfileWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
- (THLPerkStoreWireframe *)newPerkStoreWireframe;
- (THLPerkDetailWireframe *)newPerkDetailWireframe;
@end
