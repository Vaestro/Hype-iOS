//
//  THLEventDetailPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleInterface.h"

@protocol THLEventDetailView;
@class THLEventDetailWireframe;
@class THLEventDetailInteractor;
@class THLEventNavigationBar;

@interface THLEventDetailPresenter : NSObject<THLEventDetailModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLEventDetailWireframe *wireframe;
@property (nonatomic, readonly) THLEventDetailInteractor *interactor;
- (instancetype)initWithInteractor:(THLEventDetailInteractor *)interactor
						 wireframe:(THLEventDetailWireframe *)wireframe;

- (void)configureView:(id<THLEventDetailView>)view;
- (void)configureNavigationBar:(THLEventNavigationBar *)navBar;
@end
