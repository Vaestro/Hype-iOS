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
@class THLPromotionEntity;
@class THLUser;
@protocol THLGuestlistServiceInterface;
@protocol THLPromotionServiceInterface;

@interface THLGuestlistInvitationDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) APAddressBook *addressBook;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                               promotion:(id<THLPromotionServiceInterface>)promotionService
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook;


- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId;
- (BFTask *)submitGuestlistForPromotion:(THLPromotionEntity *)promotion forOwner:(THLUser *)owner;
- (void)loadContacts;

@end
