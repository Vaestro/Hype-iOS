//
//  THLDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestFlowDependencyManager.h"
#import "THLYapDatabaseManager.h"

@class THLMasterWireframe;
@class THLLoginWireframe;
@class THLFacebookPictureWireframe;
@class THLNumberVerificationWireframe;
@class THLGuestFlowWireframe;
@class THLEventDiscoveryWireframe;
@class THLDashboardWireframe;
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
- (THLDashboardWireframe *)newDashboardWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
- (THLUserProfileWireframe *)newUserProfileWireframe;
- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe;
- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe;
- (THLPopupNotificationWireframe *)newPopupNotificationWireframe;
- (THLPerkStoreWireframe *)newPerkStoreWireframe;
- (THLPerkDetailWireframe *)newPerkDetailWireframe;
- (THLUserManager *)userManager;
- (THLYapDatabaseManager *)databaseManager;
@end
