//
//  THLChooseHostDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLChooseHostDataManager.h"
#import "THLParseModule.h"
#import "THLParseEventService.h"
#import "NSArray+LinqExtensions.h"

@implementation THLChooseHostDataManager
- (instancetype)initWithEventService:(THLParseEventService *)eventService {
	if (self = [super init]) {
		_eventService = eventService;
	}
	return self;
}

- (BFTask *)getPromotionsForEvent:(THLEvent *)event {
	THLParseEvent *remoteEvent = [THLParseEvent unmap:event];
	return [[_eventService fetchPromotionsForEvent:remoteEvent] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray *remotePromotions = task.result;
		return [remotePromotions linq_select:^id(THLParsePromotion *promotion) {
			return [promotion map];
		}];
	}];
}

@end
