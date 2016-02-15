//
//  THLDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestFlowDependencyManager.h"
#import "THLHostFlowDependencyManager.h"

@class THLMasterWireframe;
@class THLLoginWireframe;
@class THLFacebookPictureWireframe;
@class THLNumberVerificationWireframe;
@class THLGuestFlowWireframe;
@class THLHostFlowWireframe;
//@class THLMessageListWireframe;
@class THLEventDiscoveryWireframe;
@class THLDashboardWireframe;
@class THLHostDashboardWireframe;
@class THLUserProfileWireframe;
@class THLEventDetailWireframe;
@class THLEventHostingWireframe;
@class THLGuestlistWireframe;
@class THLGuestlistInvitationWireframe;
@class THLGuestlistReviewWireframe;
@class THLPopupNotificationWireframe;
@class THLUserManager;
@class THLPerkStoreWireframe;
@class THLPerkDetailWireframe;
@class THLWaitlistPresenter;

/**
 *  Manages all dependenies for the app.
 */
@interface THLDependencyManager : NSObject
<
THLGuestFlowDependencyManager,
THLHostFlowDependencyManager
>
@property (nonatomic, readonly, strong) THLMasterWireframe *masterWireframe;

- (THLLoginWireframe *)newLoginWireframe;
- (THLFacebookPictureWireframe *)newFacebookPictureWireframe;
- (THLNumberVerificationWireframe *)newNumberVerificationWireframe;
- (THLGuestFlowWireframe *)newGuestFlowWireframe;
- (THLHostFlowWireframe *)newHostFlowWireframe;
//- (THLMessageListWireframe *)newMessageListWireframe;
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLDashboardWireframe *)newDashboardWireframe;
- (THLHostDashboardWireframe *)newHostDashboardWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLUserProfileWireframe *)newUserProfileWireframe;
- (THLEventHostingWireframe *)newEventHostingWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
- (THLPopupNotificationWireframe *)newPopupNotificationWireframe;
- (THLPerkStoreWireframe *)newPerkStoreWireframe;
- (THLPerkDetailWireframe *)newPerkDetailWireframe;
- (THLUserManager *)userManager;
- (THLWaitlistPresenter *)newWaitlistPresenter;
@end
