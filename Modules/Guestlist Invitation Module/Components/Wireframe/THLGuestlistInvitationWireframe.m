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
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
				   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
							 addressBook:(APAddressBook *)addressBook
dataStore:(THLDataStore *)dataStore{
	if (self = [super init]) {
		_guestlistService = guestlistService;
		_viewDataSourceFactory = viewDataSourceFactory;
        _entityMapper = entityMapper;
		_addressBook = addressBook;
		_dataStore = dataStore;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
    _dataManager = [[THLGuestlistInvitationDataManager alloc] initWithGuestlistService:_guestlistService entityMapper: _entityMapper dataStore:_dataStore addressBook:_addressBook];
	_interactor = [[THLGuestlistInvitationInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
	_view = [[THLGuestlistInvitationViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLGuestlistInvitationPresenter alloc] initWithWireframe:self
																 interactor:_interactor];
}

// Bad code for this module usage because we're supplanting the old VC flow. No good because we
// can never return from this interface/module because there's nothing to return to since we're
// now the base VC.
//- (void)presentInterfaceInWindow:(UIWindow *)window {
//	_window = window;
//	[_presenter configureView:_view];
//	_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_view];
//	[_window makeKeyAndVisible];
//}

// Good code for this module because we're pushing a modal VC ontop of it, which means we can
// always go back once we are done.
- (void)presentInterfaceInController:(UIViewController *)controller {
	_controller = controller;
	[_presenter configureView:_view];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_view];
	[_controller presentViewController:navigationController animated:YES completion:NULL];
}

- (void)dismissInterface {
	[_view.navigationController dismissViewControllerAnimated:YES completion:^{
        [_presenter.moduleDelegate dismissGuestlistInvitationWireframe];
    }];
}

- (id<THLGuestlistInvitationModuleInterface>)moduleInterface {
	return _presenter;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

@end
