//
//  THLEventDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventDataManager;
@protocol THLEventDataManagerDelegate;

@protocol THLEventDataManagerInterface <NSObject>
@property (nonatomic, weak) id<THLEventDataManagerDelegate> delegate;
- (void)updateUpcomingEvents;
- (void)purgeAllEvents;
- (void)cleanUpEvents;
@end

@protocol THLEventDataManagerDelegate <NSObject>
- (void)eventDataManagerDidUpdateUpcomingEvents:(THLEventDataManager *)dataManager;
@end

@class THLEventDataStore;
@protocol THLEventFetchServiceInterface;

@interface THLEventDataManager : NSObject<THLEventDataManagerInterface>
@property (nonatomic, readonly) THLEventDataStore *dataStore;
@property (nonatomic, readonly) id<THLEventFetchServiceInterface> fetchService;

- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService;
@end
