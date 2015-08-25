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
@class THLExtensionManager;

@class THLEventDiscoveryInteractor;
@protocol THLEventDiscoveryInteractorDelegate <NSObject>
- (void)interactor:(THLEventDiscoveryInteractor *)interactor didUpdateEventsWithSuccess:(BOOL)success error:(NSError *)error;
@end

@interface THLEventDiscoveryInteractor : NSObject
@property (nonatomic, weak) id<THLEventDiscoveryInteractorDelegate> delegate;

@property (nonatomic, readonly) THLEventDiscoveryDataManager *dataManager;
@property (nonatomic, readonly) THLExtensionManager *extensionManager;
- (instancetype)initWithDataManager:(THLEventDiscoveryDataManager *)dataManager
				   extensionManager:(THLExtensionManager *)extensionManager;

- (THLViewDataSource *)generateDataSource;
- (void)updateEvents;
@end
