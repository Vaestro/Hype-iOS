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

@protocol THLWireframeFactory <NSObject>
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe;
@end

/**
 *  Manages all dependenies for the app.
 */
@interface THLDependencyManager : NSObject<THLWireframeFactory>
- (THLMasterWireframe *)masterWireframe;
@end
