//
//  THLPromotionSelectionInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionSelectionInteractor.h"
#import "THLPromotionSelectionDataManager.h"

@implementation THLPromotionSelectionInteractor
- (instancetype)initWithDataManager:(THLPromotionSelectionDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
	}
	return self;
}

- (void)getPromotionsForEvent:(THLEventEntity *)eventEntity {
	[[_dataManager getPromotionsForEvent:eventEntity] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		[_delegate interactor:self didGetPromotions:task.result forEvent:eventEntity error:task.error];
		return nil;
	}];
}


@end
