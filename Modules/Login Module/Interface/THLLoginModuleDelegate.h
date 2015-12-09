//
//  THLLoginModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLUser;
@protocol THLLoginModuleInterface;
@protocol THLLoginModuleDelegate <NSObject>
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error;
- (void)dismissLoginWireframe;
@end
