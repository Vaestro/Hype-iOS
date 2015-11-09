//
//  THLDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestFlowDependencyManager.h"

@class THLMasterWireframe;
@class THLLoginWireframe;
@class THLFacebookPictureWireframe;
@class THLNumberVerificationWireframe;
@class THLGuestFlowWireframe;
@class THLEventDiscoveryWireframe;
@class THLEventDetailWireframe;
@class THLPromotionSelectionWireframe;
@class THLGuestlistInvitationWireframe;
@class THLGuestlistReviewWireframe;
@class THLPopupNotificationWireframe;
/**
 *  Manages all dependenies for the app.
 */
@interface THLDependencyManager : NSObject
<
THLGuestFlowDependencyManager
>
@property (nonatomic, readonly, strong) THLMasterWireframe *masterWireframe;

- (THLLoginWireframe *)newLoginWireframe;
- (THLFacebookPictureWireframe *)newFacebookPictureWireframe;
- (THLNumberVerificationWireframe *)newNumberVerificationWireframe;
- (THLGuestFlowWireframe *)newGuestFlowWireframe;
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLPromotionSelectionWireframe *)newPromotionSelectionWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
- (THLPopupNotificationWireframe *)newPopupNotificationWireframe;
@end
