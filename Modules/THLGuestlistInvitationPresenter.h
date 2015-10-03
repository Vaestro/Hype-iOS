//
//  THLGuestlistInvitationPresenter.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistInvitationModuleInterface.h"
@class THLGuestlistInvitationWireframe;
@class THLGuestlistInvitationInteractor;
@protocol THLGuestlistInvitationView;

@interface THLGuestlistInvitationPresenter : NSObject<THLGuestlistInvitationModuleInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistInvitationWireframe *wireframe;
@property (nonatomic, readonly) THLGuestlistInvitationInteractor *interactor;
- (instancetype)initWithWireframe:(THLGuestlistInvitationWireframe *)wireframe
					   interactor:(THLGuestlistInvitationInteractor *)interactor;

- (void)configureView:(id<THLGuestlistInvitationView>)view;

@end
