//
//  THLFacebookPictureModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLFacebookImagePickerController.h"

@protocol THLFacebookPictureModuleInterface;
@protocol THLFacebookPictureModuleDelegate <NSObject>
- (void)facebookPictureModule:(id<THLFacebookPictureModuleInterface>)module didSelectImage:(UIImage *)image;
@end
