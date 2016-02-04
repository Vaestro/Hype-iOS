//
//  THLMessageListPresenter.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListModuleInterface.h"

@protocol THLMessageListView;
@class THLMessageListWireframe;
@class THLMessageListInteractor;

@interface THLMessageListPresenter : NSObject<THLMessageListModuleInterface>

@property (nonatomic, readonly, weak) THLMessageListWireframe *wireframe;
@property (nonatomic, readonly, weak) THLMessageListInteractor *interactor;
- (instancetype)initWithInteractor:(THLMessageListInteractor *)interactor
                         wireframe:(THLMessageListWireframe *)wireframe;
- (void)configureView:(id<THLMessageListView>)view;

@end
