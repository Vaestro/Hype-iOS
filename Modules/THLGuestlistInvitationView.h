//
//  THLGuestlistInvitationView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLGuestEntity;
@class THLSearchViewDataSource;
@protocol THLGuestlistInvitationViewEventHandler;

@protocol THLGuestlistInvitationView <NSObject>
@property (nonatomic, weak) id<THLGuestlistInvitationViewEventHandler> eventHandler;
@property (nonatomic, strong) NSSet<THLGuestEntity *> *existingGuests;
@property (nonatomic, strong) THLSearchViewDataSource *dataSource;
@end
