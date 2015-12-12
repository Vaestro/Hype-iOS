//
//  THLGuestlistInvitationWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistInvitationModuleInterface.h"

@protocol THLGuestlistServiceInterface;
@protocol THLPromotionServiceInterface;
@class THLEntityMapper;
@class APAddressBook;
@class THLDataStore;
@protocol THLViewDataSourceFactoryInterface;

@interface THLGuestlistInvitationWireframe : NSObject
@property (nonatomic, readonly) id<THLGuestlistInvitationModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
@property (nonatomic, readonly) APAddressBook *addressBook;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLDataStore *dataStore2;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
				   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
							 addressBook:(APAddressBook *)addressBook
							   dataStore:(THLDataStore *)dataStore
                              dataStore2:(THLDataStore *)dataStore2;

- (void)presentInterfaceInController:(UIViewController *)controller;
- (void)dismissInterface;
@end
