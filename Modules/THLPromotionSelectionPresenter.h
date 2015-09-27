//
//  THLPromotionSelectionPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPromotionSelectionModuleInterface.h"

@protocol THLPromotionSelectionView;
@class THLPromotionSelectionWireframe;
@class THLPromotionSelectionInteractor;

@interface THLPromotionSelectionPresenter : NSObject <THLPromotionSelectionModuleInterface>

#pragma mark - Dependencies
@property (nonatomic, weak, readonly) THLPromotionSelectionWireframe *wireframe;
@property (nonatomic, readonly) THLPromotionSelectionInteractor *interactor;
- (instancetype)initWithWireframe:(THLPromotionSelectionWireframe *)wireframe
					   interactor:(THLPromotionSelectionInteractor *)interactor;

- (void)configureView:(id<THLPromotionSelectionView>)view;
@end
