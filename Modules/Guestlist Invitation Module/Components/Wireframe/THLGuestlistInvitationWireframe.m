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
                               dataStore:(THLDataStore *)dataStore
                              dataStore2:(THLDataStore *)dataStore2  {
	if (self = [super init]) {
		_guestlistService = guestlistService;
		_viewDataSourceFactory = viewDataSourceFactory;
        _entityMapper = entityMapper;
		_addressBook = addressBook;
		_dataStore = dataStore;
        _dataStore2 = dataStore2;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
    _dataManager = [[THLGuestlistInvitationDataManager alloc] initWithGuestlistService:_guestlistService entityMapper: _entityMapper dataStore:_dataStore addressBook:_addressBook dataStore2:_dataStore2];
	_interactor = [[THLGuestlistInvitationInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
	_view = [[THLGuestlistInvitationViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLGuestlistInvitationPresenter alloc] initWithWireframe:self
																 interactor:_interactor];
}

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

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}

@end
