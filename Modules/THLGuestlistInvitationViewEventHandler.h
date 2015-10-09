//
//  THLGuestlistInvitationViewEventHandler.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLGuestEntity;
@protocol THLGuestlistInvitationView;
@protocol THLGuestlistInvitationViewEventHandler <NSObject>
- (void)view:(id<THLGuestlistInvitationView>)view didAddGuest:(THLGuestEntity *)guest;
- (void)view:(id<THLGuestlistInvitationView>)view didRemoveGuest:(THLGuestEntity *)guest;
@end
