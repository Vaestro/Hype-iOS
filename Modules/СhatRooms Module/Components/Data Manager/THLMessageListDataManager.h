//
//  THLMessageListDataManager.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLEventServiceInterface;

@interface THLMessageListDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLEventServiceInterface> eventService;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                     eventService:(id<THLEventServiceInterface>)eventService;

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate;

@end
