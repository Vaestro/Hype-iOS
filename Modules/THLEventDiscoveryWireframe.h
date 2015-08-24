//
//  THLEventDiscoveryWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDiscoveryModuleInterface.h"

@class THLEventDataStore;
@class THLExtensionManager;
@protocol THLEventFetchServiceInterface;

@interface THLEventDiscoveryWireframe : NSObject<THLEventDiscoveryModuleInterface>
@property (nonatomic, readonly) THLEventDataStore *eventDataStore;
@property (nonatomic, readonly) id<THLEventFetchServiceInterface> eventFetchService;
@property (nonatomic, readonly) THLExtensionManager *extensionManager;

- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService
				 extensionManager:(THLExtensionManager *)extensionManager;

@end
