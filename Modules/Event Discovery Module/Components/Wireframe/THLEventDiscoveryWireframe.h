//
//  THLEventDiscoveryWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDiscoveryModuleInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@protocol THLEventServiceInterface;
@protocol THLViewDataSourceFactoryInterface;

@interface THLEventDiscoveryWireframe : NSObject
@property (nonatomic, readonly) id<THLEventDiscoveryModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) id<THLEventServiceInterface> eventService;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
					 entityMapper:(THLEntityMapper *)entityMapper
					 eventService:(id<THLEventServiceInterface>)eventService
			viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)presentInWindow:(UIWindow *)window;
@end
