//
//  THLGuestlistInvitationWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistInvitationPresenter.h"
#import "THLGuestlistInvitationInteractor.h"
#import "THLGuestlistInvitationDataManager.h"
#import "THLGuestlistInvitationViewController.h"

@interface THLGuestlistInvitationWireframe()
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) THLGuestlistInvitationPresenter *presenter;
@property (nonatomic, strong) THLGuestlistInvitationInteractor *interactor;
@property (nonatomic, strong) THLGuestlistInvitationViewController *view;
@property (nonatomic, strong) THLGuestlistInvitationDataManager *dataManager;
@end

@implementation THLGuestlistInvitationWireframe
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService {
	if (self = [super init]) {
		_guestlistService = guestlistService;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLGuestlistInvitationDataManager alloc] initWithGuestlistService:_guestlistService];
	_interactor = [[THLGuestlistInvitationInteractor alloc] initWithDataManager:_dataManager];
	_view = [[THLGuestlistInvitationViewController alloc] init];
	_presenter = [[THLGuestlistInvitationPresenter alloc] initWithWireframe:self
																 interactor:_interactor];
}

- (void)presentInterfaceInViewController:(UIViewController *)controller {
	_controller = controller;
	[_presenter configureView:_view];
	[controller presentViewController:_view animated:YES completion:NULL];
}

- (void)dismissInterface {
	[_view dismissViewControllerAnimated:YES completion:NULL];
}

@end
