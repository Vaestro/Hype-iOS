//
//  THLGuestlistInvitationInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLGuestlistInvitationDataManager;
@class THLGuestlistInvitationInteractor;
@class APAddressBook;
@class THLSearchViewDataSource;
@class THLGuestEntity;
@class THLPromotionEntity;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLGuestlistInvitationInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSError *)error;
@end


@interface THLGuestlistInvitationInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistInvitationInteractorDelegate> delegate;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistInvitationDataManager *dataManager;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLSearchViewDataSource *)getDataSource;
- (void)loadGuestlist:(NSString *)guestlistId withCurrentGuests:(NSArray<THLGuestEntity *> *)currentGuests;
- (void)addGuest:(THLGuestEntity *)guest;
- (void)removeGuest:(THLGuestEntity *)guest;
- (void)commitChangesToGuestlist;
@end
