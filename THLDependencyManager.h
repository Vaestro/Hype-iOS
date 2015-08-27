//
//  THLDependencyManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLMasterWireframe;
@class THLEventDiscoveryWireframe;
@class THLEventDetailWireframe;

@protocol THLWireframeFactory <NSObject>
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
- (THLEventDetailWireframe *)newEventDetailWireframe;
@end

/**
 *  Manages all dependenies for the app.
 */
@interface THLDependencyManager : NSObject<THLWireframeFactory>
@property (NS_NONATOMIC_IOSONLY, readonly, strong) THLMasterWireframe *masterWireframe;
@end
