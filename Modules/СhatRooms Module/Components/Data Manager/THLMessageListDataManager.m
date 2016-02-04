//
//  THLMessageListDataManager.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListDataManager.h"

@implementation THLMessageListDataManager

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

//- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
//    WEAKSELF();
//    STRONGSELF();
//    return [[_eventService fetchEventsFrom:startDate to:endDate] continueWithSuccessBlock:^id(BFTask *task) {
//        THLDataStoreDomain *domain = [SSELF domainForEventsFrom:startDate to:endDate];
//        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapEvents:task.result]];
//        [SSELF.dataStore refreshDomain:domain withEntities:entities andDeleteEntities:YES];
//        return [BFTask taskWithResult:nil];
//    }];
//}
//
//- (THLDataStoreDomain *)domainForEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
//    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
//        THLEventEntity *eventEntity = (THLEventEntity *)entity;
//        return ([eventEntity.date isLaterThanOrEqualTo:startDate] &&
//                [eventEntity.date isEarlierThanOrEqualTo:endDate]);
//    }];
//    return domain;
//}

@end
