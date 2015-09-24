//
//  THLChooseHostInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLChooseHostInteractor.h"
#import "THLChooseHostDataManager.h"

@implementation THLChooseHostInteractor
- (instancetype)initWithDataManager:(THLChooseHostDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
	}
	return self;
}

- (void)findPromotionsForEvent:(THLEvent *)event {
	[[_dataManager getPromotionsForEvent:event] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		[_delegate interactor:self didFindPromotions:task.result forEvent:event error:task.error];
		return nil;
	}];
}


@end
