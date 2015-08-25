//
//  THLEventDiscoveryDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryDataManager.h"

#import "THLEventDataStore.h"
#import "THLEventFetchServiceInterface.h"
#import "THLEvent.h"


@interface THLEventDiscoveryDataManager()

@end

@implementation THLEventDiscoveryDataManager
- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService {
	if (self = [super init]) {
		_dataStore = dataStore;
		_fetchService = fetchService;
	}
	return self;
}

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	return [[_fetchService fetchEventsStartingOn:startDate endingOn:endDate] continueWithSuccessBlock:^id(BFTask *task) {
		[_dataStore updateWithEntities:task.result inDomain:^BOOL(THLEntity *entity) {
			THLEvent *event = (THLEvent *)entity;
			return ([event.date isLaterThanOrEqualTo:startDate] &&
					[event.date isEarlierThanOrEqualTo:endDate]);
		}];
		return [BFTask taskWithResult:nil];
	}];
}

@end
