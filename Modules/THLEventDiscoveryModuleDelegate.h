//
//  THLEventDiscoveryModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEvent;
@protocol THLEventDiscoveryModuleInterface;

@protocol THLEventDiscoveryModuleDelegate <NSObject>
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEvent:(THLEvent *)event;
@end
