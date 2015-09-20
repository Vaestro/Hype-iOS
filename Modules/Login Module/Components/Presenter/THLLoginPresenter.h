//
//  THLLoginPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleInterface.h"

@protocol THLLoginView;
@class THLLoginWireframe;
@class THLLoginInteractor;

@interface THLLoginPresenter : NSObject<THLLoginModuleInterface>
@property (nonatomic, weak, readonly) THLLoginWireframe *wireframe;
@property (nonatomic, strong, readonly) THLLoginInteractor *interactor;

- (instancetype)initWithWireframe:(THLLoginWireframe *)wireframe
					   interactor:(THLLoginInteractor *)interactor NS_DESIGNATED_INITIALIZER;

- (void)configureView:(id<THLLoginView>)view;
@end
