//
//  THLPopupNotificationPresenter.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPopupNotificationModuleInterface.h"

@class THLPopupNotificationWireframe;
@class THLPopupNotificationInteractor;
@class THLPopupNotificationView;

@interface THLPopupNotificationPresenter : NSObject<THLPopupNotificationModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLPopupNotificationWireframe *wireframe;
@property (nonatomic, readonly) THLPopupNotificationInteractor *interactor;
- (instancetype)initWithWireframe:(THLPopupNotificationWireframe *)wireframe
                       interactor:(THLPopupNotificationInteractor *)interactor;

- (void)configureView:(THLPopupNotificationView *)view;
@end