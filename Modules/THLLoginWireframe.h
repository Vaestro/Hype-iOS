//
//  THLLoginWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleInterface.h"

@interface THLLoginWireframe : NSObject
@property (nonatomic, readonly) id<THLEventDetailModuleInterface> moduleInterface;

- (void)presentInterfaceInWindow:(UIWindow *)window;

@end
