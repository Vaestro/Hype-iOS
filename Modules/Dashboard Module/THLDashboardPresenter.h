//
//  THLDashboardPresenter.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardModuleInterface.h"

@protocol THLDashboardView;
@class THLDashboardWireframe;
@class THLDashboardInteractor;

@interface THLDashboardPresenter : NSObject<THLDashboardModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDashboardWireframe *wireframe;
@property (nonatomic, readonly, weak) THLDashboardInteractor *interactor;
- (instancetype)initWithWireframe:(THLDashboardWireframe *)wireframe
                         interactor:(THLDashboardInteractor *)interactor;

- (void)configureView:(id<THLDashboardView>)view;
@end
