//
//  THLPromotionSelectionDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventEntity;
@class BFTask;
@class THLEntityMapper;
@protocol THLPromotionServiceInterface;

@interface THLPromotionSelectionDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;
- (instancetype)initWithEntityMapper:(THLEntityMapper *)entityMapper
					promotionService:(id<THLPromotionServiceInterface>)promotionService;

//- (BFTask *)getPromotionsForEvent:(THLEventEntity *)eventEntity;
@end
