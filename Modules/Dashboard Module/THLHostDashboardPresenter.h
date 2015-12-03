//
//  THLHostDashboardPresenter.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostDashboardModuleInterface.h"

@protocol THLHostDashboardView;
@class THLHostDashboardWireframe;
@class THLHostDashboardInteractor;

@interface THLHostDashboardPresenter : NSObject<THLHostDashboardModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLHostDashboardWireframe *wireframe;
@property (nonatomic, readonly, weak) THLHostDashboardInteractor *interactor;
- (instancetype)initWithWireframe:(THLHostDashboardWireframe *)wireframe
                       interactor:(THLHostDashboardInteractor *)interactor;

- (void)configureView:(id<THLHostDashboardView>)view;
@end
