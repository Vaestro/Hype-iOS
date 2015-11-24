//
//  THLEventDetailWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleInterface.h"

@class THLEntityMapper;
@protocol THLLocationServiceInterface;
@protocol THLPromotionServiceInterface;
@protocol THLGuestlistServiceInterface;
@class THLYapDatabaseManager;

@interface THLEventDetailWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLEventDetailModuleInterface> moduleInterface;
@property (nonatomic, readonly) THLYapDatabaseManager *databaseManager;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLLocationServiceInterface> locationService;
@property (nonatomic, readonly, weak) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper
                        databaseManager:(THLYapDatabaseManager *)databaseManager;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
