//
//  THLGuestlistInvitationDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;
@protocol THLGuestlistServiceInterface;

@interface THLGuestlistInvitationDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService;

- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId;

@end
