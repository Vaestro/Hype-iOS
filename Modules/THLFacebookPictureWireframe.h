//
//  THLFacebookPictureWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLFacebookPictureModuleInterface.h"
@class THLFacebookProfilePictureURLFetchService;

@interface THLFacebookPictureWireframe : NSObject
@property (nonatomic, readonly) id<THLFacebookPictureModuleInterface> moduleInterface;
@property (nonatomic, readonly) THLFacebookProfilePictureURLFetchService *fetchService;

- (instancetype)initWithFetchService:(THLFacebookProfilePictureURLFetchService *)fetchService;
@end
