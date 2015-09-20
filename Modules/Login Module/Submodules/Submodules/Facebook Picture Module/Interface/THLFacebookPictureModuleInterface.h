//
//  THLFacebookPictureModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLFacebookPictureModuleDelegate.h"

@protocol THLFacebookPictureModuleInterface <NSObject>
@property (nonatomic, weak) id<THLFacebookPictureModuleDelegate> moduleDelegate;

- (void)presentFacebookPictureInterfaceInWindow:(UIWindow *)window;
@end
