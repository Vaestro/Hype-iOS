//
//  THLGuestlistReviewPresenter.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistReviewModuleInterface.h"
@class THLGuestlistReviewWireframe;
@class THLGuestlistReviewInteractor;
@protocol THLGuestlistReviewView;

@interface THLGuestlistReviewPresenter : NSObject<THLGuestlistReviewModuleInterface>
@property (nonatomic, weak, readonly) THLGuestlistReviewWireframe *wireframe;
@property (nonatomic, readonly) THLGuestlistReviewInteractor *interactor;

- (instancetype)initWithWireframe:(THLGuestlistReviewWireframe *)wireframe
                       interactor:(THLGuestlistReviewInteractor *)interactor;

- (void)configureView:(id<THLGuestlistReviewView>)view;
@end
