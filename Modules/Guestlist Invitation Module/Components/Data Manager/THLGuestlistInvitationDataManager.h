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
@class THLEntityMapper;
@class THLEventEntity;
@class THLUser;
@protocol THLGuestlistServiceInterface;
@protocol THLEventServiceInterface;

@interface THLGuestlistInvitationDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLDataStore *dataStore2;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) APAddressBook *addressBook;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook
                dataStore2:(THLDataStore *)dataStore2;


- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId;
- (BFTask *)submitGuestlistForEvent:(THLEventEntity *)eventEntity withInvites:(NSArray *)guestPhoneNumbers;
- (BFTask *)getOwnerInviteForEvent:(THLEventEntity *)eventEntity;
- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forEvent:(THLEventEntity *)eventEntity;
- (void)loadContacts;

@end
