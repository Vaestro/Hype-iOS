//
//  THLEventHostingPresenter.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventHostingModuleInterface.h"

@protocol THLEventHostingView;
@class THLEventHostingWireframe;
@class THLEventHostingInteractor;
@class THLEventNavigationBar;

@interface THLEventHostingPresenter : NSObject<THLEventHostingModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLEventHostingWireframe *wireframe;
@property (nonatomic, readonly, weak) THLEventHostingInteractor *interactor;
- (instancetype)initWithWireframe:(THLEventHostingWireframe *)wireframe
                        interactor:(THLEventHostingInteractor *)interactor;

- (void)configureView:(id<THLEventHostingView>)view;
- (void)configureNavigationBar:(THLEventNavigationBar *)navBar;
@end
