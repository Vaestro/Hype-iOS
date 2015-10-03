//
//  THLGuestlistInvitationViewEventHandler.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUserEntity;
@protocol THLGuestlistInvitationView;
@protocol THLGuestlistInvitationViewEventHandler <NSObject>
- (void)view:(id<THLGuestlistInvitationView>)view didAddGuest:(THLUserEntity *)guest;
- (void)view:(id<THLGuestlistInvitationView>)view didRemoveGuest:(THLUserEntity *)guest;
@end
