//
//  THLPerkStorePresenter.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkStoreModuleInterface.h"

@protocol THLPerkStoreView;
@class THLPerkStoreInteractor;
@class THLPerkStoreWireframe;

@interface THLPerkStorePresenter : NSObject<THLPerkStoreModuleInterface>
@property (nonatomic, readonly, weak) THLPerkStoreInteractor *interactor;
@property (nonatomic, readonly, weak) THLPerkStoreWireframe *wireframe;

- (instancetype)initWithWireframe:(THLPerkStoreWireframe *)wireframe
                       interactor:(THLPerkStoreInteractor *)interactor;

- (void)configureView:(id<THLPerkStoreView>)view;
@end

