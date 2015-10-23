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

@interface THLEventDetailWireframe : NSObject
@property (nonatomic, readonly) id<THLEventDetailModuleInterface> moduleInterface;
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLLocationServiceInterface> locationService;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
