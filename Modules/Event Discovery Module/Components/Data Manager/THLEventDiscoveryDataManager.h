//
//  THLEventDiscoveryDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLEventServiceInterface;

@interface THLEventDiscoveryDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLEventServiceInterface> eventService;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
					 entityMapper:(THLEntityMapper *)entityMapper
					 eventService:(id<THLEventServiceInterface>)eventService;

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate;
@end
