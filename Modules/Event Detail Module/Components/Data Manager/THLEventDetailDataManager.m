//
//  THLEventDetailDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailDataManager.h"
#import "THLLocationServiceInterface.h"
#import "THLPromotionServiceInterface.h"
#import "THLPromotion.h"
#import "THLPromotionEntity.h"
#import "THLEntityMapper.h"

@implementation THLEventDetailDataManager
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
						  entityMappper:(THLEntityMapper *)entityMapper {
	if (self = [super init]) {
		_locationService = locationService;
		_promotionService = promotionService;
		_entityMapper = entityMapper;
	}
	return self;
}

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address {
	return [_locationService geocodeAddress:address];
}

- (BFTask *)fetchPromotionsForEvent:(THLEvent *)event {
	return [[_promotionService fetchPromotionsForEvent:event] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray<THLPromotion *> *fetchedPromotions = task.result;
		NSArray<THLPromotionEntity *> *mappedPromotions = [_entityMapper mapPromotions:fetchedPromotions];
		return mappedPromotions;
	}];
}

@end
