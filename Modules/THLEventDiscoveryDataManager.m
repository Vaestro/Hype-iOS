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

- (DTTimePeriod *)eventDisplayPeriod {
	return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek amount:1 startingAt:[NSDate date]];
}

@end
