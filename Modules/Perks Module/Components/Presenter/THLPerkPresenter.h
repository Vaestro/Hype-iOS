//
//  THLPerkPresenter.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkModuleInterface.h"

@protocol THLPerksView;
@class THLPerkInteractor;
@class THLPerkWireframe;

@interface THLPerkPresenter : NSObject<THLPerkModuleInterface>
@property (nonatomic, readonly, weak) THLPerkInteractor *interactor;
@property (nonatomic, readonly, weak) THLPerkWireframe *wireframe;

- (instancetype)initWithWireframe:(THLPerkWireframe *)wireframe
                       interactor:(THLPerkInteractor *)interactor;

- (void)configureView:(id<THLPerksView>)view;
@end

