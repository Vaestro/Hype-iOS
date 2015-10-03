//
//  THLGuestlistInvitationInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLGuestlistInvitationDataManager;
@class THLUserEntity;
@class THLGuestlistInvitationInteractor;

@protocol THLGuestlistInvitationInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didGetInvitableUsers:(NSArray<THLUserEntity *> *)users error:(NSError *)error;
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSString *)guestlistId error:(NSError *)error;
@end


@interface THLGuestlistInvitationInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistInvitationInteractorDelegate> delegate;
@property (nonatomic, copy) NSString *guestlistId;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistInvitationDataManager *dataManager;
- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager;

- (void)getInvitableUsers;
- (BOOL)isGuestInvited:(THLUserEntity *)guest;
- (BOOL)canAddGuest:(THLUserEntity *)guest;
- (BOOL)canRemoveGuest:(THLUserEntity *)guest;
- (void)addGuest:(THLUserEntity *)guest;
- (void)removeGuest:(THLUserEntity *)guest;
- (void)commitChangesToGuestlist;
@end
