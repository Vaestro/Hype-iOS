//
//  THLEventFlowDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>


@class THLEventDetailWireframe;
@class THLEventDiscoveryWireframe;
@class THLPromotionSelectionWireframe;
@class THLGuestlistInvitationWireframe;

@protocol THLEventFlowDependencyManager <NSObject>
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLPromotionSelectionWireframe *)newPromotionSelectionWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
@end
