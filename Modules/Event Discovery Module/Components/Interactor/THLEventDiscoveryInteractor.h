//
//  THLEventDiscoveryInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventDiscoveryDataManager;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@class THLEventDiscoveryInteractor;
@protocol THLEventDiscoveryInteractorDelegate <NSObject>
- (void)interactor:(THLEventDiscoveryInteractor *)interactor didUpdateEvents:(NSError *)error;
@end

@interface THLEventDiscoveryInteractor : NSObject
@property (nonatomic, weak) id<THLEventDiscoveryInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLEventDiscoveryDataManager *dataManager;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLEventDiscoveryDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)updateEvents;
- (THLViewDataSource *)generateDataSource;
@end
