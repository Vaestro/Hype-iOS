//
//  THLLoginPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleInterface.h"

@protocol THLOnboardingViewInterface;
@protocol THLLoginViewInterface;
@class THLLoginWireframe;
@class THLLoginInteractor;

@interface THLLoginPresenter : NSObject<THLLoginModuleInterface>

@property (nonatomic, readonly) THLLoginWireframe *wireframe;
@property (nonatomic, readonly) THLLoginInteractor *interactor;

- (instancetype)initWithWireframe:(THLLoginWireframe *)wireframe
					   interactor:(THLLoginInteractor *)interactor;

- (void)configureLoginView:(id<THLLoginViewInterface>)loginView;
- (void)configureOnboardingView:(id<THLOnboardingViewInterface>)onboardingView;
- (void)configureBaseView:(UIViewController *)baseView;
- (void)reroute;
@end
