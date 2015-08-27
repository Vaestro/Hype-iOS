//
//  THLEventDetailWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleInterface.h"

@interface THLEventDetailWireframe : NSObject
@property (nonatomic, readonly) id<THLEventDetailModuleInterface> moduleInterface;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
