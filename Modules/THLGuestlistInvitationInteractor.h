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
@protocol THLViewDataSourceFactoryInterface;

@protocol THLGuestlistInvitationInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSString *)guestlistId error:(NSError *)error;
@end


@interface THLGuestlistInvitationInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistInvitationInteractorDelegate> delegate;
@property (nonatomic, copy) NSString *guestlistId;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistInvitationDataManager *dataManager;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLSearchViewDataSource *)getDataSource;
- (void)addGuest:(THLGuestEntity *)guest;
- (void)removeGuest:(THLGuestEntity *)guest;
- (void)commitChangesToGuestlist;
@end
