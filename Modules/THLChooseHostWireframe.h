//
//  THLChooseHostWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLChooseHostModuleInterface.h"
@class THLParseEventService;

@interface THLChooseHostWireframe : NSObject
@property (nonatomic, readonly) id<THLChooseHostModuleInterface> moduleInterface;

@property (nonatomic, readonly) THLParseEventService *eventService;
- (instancetype)initWithEventService:(THLParseEventService *)eventService;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
