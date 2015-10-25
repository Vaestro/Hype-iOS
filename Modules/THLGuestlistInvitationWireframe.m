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
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) THLGuestlistInvitationPresenter *presenter;
@property (nonatomic, strong) THLGuestlistInvitationInteractor *interactor;
@property (nonatomic, strong) THLGuestlistInvitationViewController *view;
@property (nonatomic, strong) THLGuestlistInvitationDataManager *dataManager;
@end

@implementation THLGuestlistInvitationWireframe
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
				   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
							 addressBook:(APAddressBook *)addressBook
dataStore:(THLDataStore *)dataStore{
	if (self = [super init]) {
		_guestlistService = guestlistService;
		_viewDataSourceFactory = viewDataSourceFactory;
		_addressBook = addressBook;
		_dataStore = dataStore;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
    _dataManager = [[THLGuestlistInvitationDataManager alloc] initWithGuestlistService:_guestlistService dataStore:_dataStore addressBook:_addressBook];
	_interactor = [[THLGuestlistInvitationInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
	_view = [[THLGuestlistInvitationViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLGuestlistInvitationPresenter alloc] initWithWireframe:self
																 interactor:_interactor];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_view];
	[_window makeKeyAndVisible];
}

- (void)dismissInterface {
	[_view dismissViewControllerAnimated:YES completion:NULL];
}

- (id<THLGuestlistInvitationModuleInterface>)moduleInterface {
	return self.presenter;
}

@end
