//
//  THLFacebookPicturePresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLFacebookPictureModuleInterface.h"

@class THLFacebookPictureWireframe;
@class THLFacebookPictureInteractor;

@interface THLFacebookPicturePresenter : NSObject<THLFacebookPictureModuleInterface>
@property (nonatomic, weak, readonly) THLFacebookPictureWireframe *wireframe;
@property (nonatomic, readonly) THLFacebookPictureInteractor *interactor;

- (instancetype)initWithWireframe:(THLFacebookPictureWireframe *)wireframe
					   interactor:(THLFacebookPictureInteractor *)interactor;
@end
