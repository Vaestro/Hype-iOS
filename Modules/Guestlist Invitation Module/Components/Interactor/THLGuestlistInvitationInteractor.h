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
@class THLEventEntity;
@class THLGuestlistInviteEntity;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLGuestlistInvitationInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSError *)error;
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didSubmitInitialGuestlist:(THLGuestlistInviteEntity *)guestlistInvite withError:(NSError *)error;
@end


@interface THLGuestlistInvitationInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistInvitationInteractorDelegate> delegate;
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) NSArray *currentGuests;


#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistInvitationDataManager *dataManager;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLSearchViewDataSource *)getDataSource;
- (void)loadGuestlist:(NSString *)guestlistId withCurrentGuests:(NSArray *)currentGuests;
- (void)addGuest:(THLGuestEntity *)guest;
- (void)removeGuest:(THLGuestEntity *)guest;
- (void)commitChangesToGuestlist;
@end
