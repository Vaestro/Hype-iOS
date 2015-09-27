//
//  THLEventDiscoveryDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryDataManager.h"

#import "THLDataStore.h"
#import "THLEventServiceInterface.h"
#import "THLEventEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"

@interface THLEventDiscoveryDataManager()

@end

@implementation THLEventDiscoveryDataManager
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
					 entityMapper:(THLEntityMapper *)entityMapper
					 eventService:(id<THLEventServiceInterface>)eventService {
	if (self = [super init]) {
		_dataStore = dataStore;
		_entityMapper = entityMapper;
		_eventService = eventService;
	}
	return self;
}

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	return [[_eventService fetchEventsFrom:startDate to:endDate] continueWithSuccessBlock:^id(BFTask *task) {
		THLDataStoreDomain *domain = [self domainForEventsFrom:startDate to:endDate];
		NSSet *entities = [NSSet setWithArray:[_entityMapper mapEvents:task.result]];
		[_dataStore refreshDomain:domain withEntities:entities];
		return [BFTask taskWithResult:nil];
	}];
}

- (THLDataStoreDomain *)domainForEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
		THLEventEntity *eventEntity = (THLEventEntity *)entity;
		return ([eventEntity.date isLaterThanOrEqualTo:startDate] &&
				[eventEntity.date isEarlierThanOrEqualTo:endDate]);
	}];
	return domain;
}
@end
