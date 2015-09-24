//
//  THLChooseHostPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLChooseHostModuleInterface.h"

@protocol THLChooseHostView;
@class THLChooseHostWireframe;
@class THLChooseHostInteractor;

@interface THLChooseHostPresenter : NSObject <THLChooseHostModuleInterface>

@property (nonatomic, weak, readonly) THLChooseHostWireframe *wireframe;
@property (nonatomic, readonly) THLChooseHostInteractor *interactor;
- (instancetype)initWithWireframe:(THLChooseHostWireframe *)wireframe
					   interactor:(THLChooseHostInteractor *)interactor;


- (void)configureView:(id<THLChooseHostView>)view;
@end
