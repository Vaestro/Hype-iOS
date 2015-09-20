//
//  THLEventDiscoveryPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDiscoveryModuleInterface.h"

@protocol THLEventDiscoveryView;
@class THLEventDiscoveryWireframe;
@class THLEventDiscoveryInteractor;

@interface THLEventDiscoveryPresenter : NSObject<THLEventDiscoveryModuleInterface>
@property (nonatomic, weak, readonly) THLEventDiscoveryWireframe *wireframe;
@property (nonatomic, strong, readonly) THLEventDiscoveryInteractor *interactor;

- (instancetype)initWithWireframe:(THLEventDiscoveryWireframe *)wireframe
					   interactor:(THLEventDiscoveryInteractor *)interactor NS_DESIGNATED_INITIALIZER;

- (void)configureView:(id<THLEventDiscoveryView>)view;
@end
