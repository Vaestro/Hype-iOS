//
//  THLMessageListDataManager.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListDataManager.h"
#import "THLPubNubManager.h"
#import "THLDataStoreDomain.h"
#import "THLMessageListEntity.h"
#import "THLEntityMapper.h"
#import "THLDataStore.h"
#import "THLMessageListItem.h"

@implementation THLMessageListDataManager

//- (instancetype)initWithDataStore:(THLDataStore *)dataStore
//                     entityMapper:(THLEntityMapper *)entityMapper
//                     messageLisrService:(id<THLMessageListServiceInterface>)messageListService {
//    if (self = [super init]) {
//        _dataStore = dataStore;
//        _entityMapper = entityMapper;
//        _messageListService = messageListService;
//    }
//    return self;
//}

- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                      messageList:(id<THLMessageListServiceInterface>)messageListService {
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _messageListService = messageListService;
    }
    return self;
}

- (BFTask *)fetchAllChannels {
    WEAKSELF();
    STRONGSELF();
    [[_messageListService fetchHistory] continueWithSuccessBlock:^id(BFTask * _Nonnull task) {
        THLDataStoreDomain *domain = [SSELF domainForMessageList];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapMessageListItems:task.result]];
        [SSELF.dataStore refreshDomain:domain withEntities:entities andDeleteEntities:YES];
        return [BFTask taskWithResult:nil];
    }];
    return nil;
}

- (THLDataStoreDomain *)domainForMessageList {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLMessageListEntity *messageListEntity = (THLMessageListEntity *)entity;
        return messageListEntity; //(perkStoreItemEntity.credits > 0);
    }];
    return domain;
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
