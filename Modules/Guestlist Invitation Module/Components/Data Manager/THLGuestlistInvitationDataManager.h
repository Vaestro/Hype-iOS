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
@class THLPromotionEntity;
@class THLUser;
@protocol THLGuestlistServiceInterface;
@protocol THLPromotionServiceInterface;

@interface THLGuestlistInvitationDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) APAddressBook *addressBook;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook;


- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId;
- (BFTask *)submitGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers;
- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers;
- (void)loadContacts;

@end
