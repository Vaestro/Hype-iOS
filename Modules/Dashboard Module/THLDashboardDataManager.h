//
//  THLDashboardDataManager.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUser;
@class THLEntityMapper;
@class THLDataStore;

@protocol THLGuestlistServiceInterface;

@interface THLDashboardDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                          entityMappper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore;

- (BFTask *)fetchGuestlistInvitesForUser;
@end
