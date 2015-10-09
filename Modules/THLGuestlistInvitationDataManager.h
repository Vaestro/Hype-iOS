//
//  THLGuestlistInvitationDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;
@class THLDataStore;
@class APAddressBook;
@protocol THLGuestlistServiceInterface;

@interface THLGuestlistInvitationDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) APAddressBook *addressBook;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook;


- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId;
- (void)loadContacts;

@end
