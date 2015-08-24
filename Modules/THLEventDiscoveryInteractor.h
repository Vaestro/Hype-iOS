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

@interface THLEventDiscoveryInteractor : NSObject
@property (nonatomic, readonly) THLEventDiscoveryDataManager *dataManager;
@property (nonatomic, readonly) THLExtensionManager *extensionManager;

- (instancetype)initWithDataManager:(THLEventDiscoveryDataManager *)dataManager
				   extensionManager:(THLExtensionManager *)extensionManager;

- (THLViewDataSource *)generateDataSource;
@end
