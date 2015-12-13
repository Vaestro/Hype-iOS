//
//  THLPerkDetailPresenter.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkDetailModuleInterface.h"

@protocol THLPerkDetailView;
@class THLPerkDetailWireframe;
@class THLPerkDetailInteractor;



@interface THLPerkDetailPresenter : NSObject<THLPerkDetailModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLPerkDetailWireframe *wireframe;
@property (nonatomic, readonly, weak) THLPerkDetailInteractor *interactor;
- (instancetype)initWithInteractor:(THLPerkDetailInteractor *)interactor
                         wireframe:(THLPerkDetailWireframe *)wireframe;
- (void)configureView:(id<THLPerkDetailView>)view;
@end
