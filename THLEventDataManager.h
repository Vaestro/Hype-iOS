//
//  THLEventDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventDataManager;
@protocol THLEventDataManagerDelegate <NSObject>
- (void)eventDataManagerDidUpdateUpcomingEvents:(THLEventDataManager *)dataManager;
- (void)eventDataManagerDidPurgeAllEvents:(THLEventDataManager *)dataManager;
- (void)eventDataManagerDidCleanUpEvents:(THLEventDataManager *)dataManager;
@end

@protocol THLEventDataManagerInterface <NSObject>
@property (nonatomic, weak) id<THLEventDataManagerDelegate> delegate;
- (void)updateUpcomingEvents;
- (void)purgeAllEvents;
- (void)cleanUpEvents;
@end


@interface THLEventDataManager : NSObject<THLEventDataManagerInterface>

@end
