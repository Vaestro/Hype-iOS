//
//  THLNumberVerificationPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLNumberVerificationModuleInterface.h"
@class THLNumberVerificationWireframe;

@interface THLNumberVerificationPresenter : NSObject<THLNumberVerificationModuleInterface>
@property (nonatomic, weak, readonly) THLNumberVerificationWireframe *wireframe;

- (instancetype)initWithWireframe:(THLNumberVerificationWireframe *)wireframe;

@end
