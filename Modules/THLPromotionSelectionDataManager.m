//
//  THLPromotionSelectionDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionSelectionDataManager.h"

#import "THLPromotionServiceInterface.h"
#import "THLEntityMapper.h"
#import "THLEventEntity.h"
#import "THLEvent.h"

@implementation THLPromotionSelectionDataManager
- (instancetype)initWithEntityMapper:(THLEntityMapper *)entityMapper
					promotionService:(id<THLPromotionServiceInterface>)promotionService {
	if (self = [super init]) {
		_entityMapper = entityMapper;
		_promotionService = promotionService;
	}
	return self;
}

- (BFTask *)getPromotionsForEvent:(THLEventEntity *)eventEntity {
	THLEvent *parseEvent = [THLEvent objectWithoutDataWithObjectId:eventEntity.objectId];
	return [[_promotionService fetchPromotionsForEvent:parseEvent] continueWithSuccessBlock:^id(BFTask *task) {
		return [_entityMapper mapPromotions:task.result];
	}];
}

@end
