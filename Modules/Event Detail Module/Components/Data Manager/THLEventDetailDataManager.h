//
//  THLEventDetailDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLEvent;
@class THLEntityMapper;
@protocol THLLocationServiceInterface;
@protocol THLPromotionServiceInterface;

@interface THLEventDetailDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLLocationServiceInterface> locationService;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
						  entityMappper:(THLEntityMapper *)entityMapper;

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address;
- (BFTask *)fetchPromotionsForEvent:(THLEvent *)event;
@end
