//
//  THLGuestFlowDependencyManager.h
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>


@class THLEventDetailWireframe;
@class THLEventDiscoveryWireframe;
@class THLPromotionSelectionWireframe;
@class THLGuestlistInvitationWireframe;
@class THLGuestlistReviewWireframe;

@protocol THLGuestFlowDependencyManager <NSObject>
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLPromotionSelectionWireframe *)newPromotionSelectionWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
@end
