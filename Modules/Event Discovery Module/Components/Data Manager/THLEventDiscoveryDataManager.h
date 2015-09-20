//
//  THLEventDiscoveryDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventDataStore;
@class BFTask;
@protocol THLEventFetchServiceInterface;

@interface THLEventDiscoveryDataManager : NSObject
@property (nonatomic, readonly) THLEventDataStore *dataStore;
@property (nonatomic, readonly) id<THLEventFetchServiceInterface> fetchService;

- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService NS_DESIGNATED_INITIALIZER;

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate;
@end
