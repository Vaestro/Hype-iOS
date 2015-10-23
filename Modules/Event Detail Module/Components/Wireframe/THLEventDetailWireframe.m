//
//  THLEventDetailWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailWireframe.h"
#import "THLEventDetailInteractor.h"
#import "THLEventDetailDataManager.h"
#import "THLEventDetailViewController.h"
#import "THLEventDetailPresenter.h"
#import "THLEventNavigationController.h"

@interface THLEventDetailWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLEventDetailInteractor *interactor;
@property (nonatomic, strong) THLEventDetailDataManager *dataManager;
@property (nonatomic, strong) THLEventDetailViewController *view;
@property (nonatomic, strong) THLEventDetailPresenter *presenter;
@end

@implementation THLEventDetailWireframe
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper {
	if (self = [super init]) {
		_locationService = locationService;
		_promotionService = promotionService;
        _guestlistService = guestlistService;
		_entityMapper = entityMapper;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLEventDetailDataManager alloc] initWithLocationService:_locationService
															 promotionService:_promotionService
                                                             guestlistService:_guestlistService
																entityMappper:_entityMapper];
	_interactor = [[THLEventDetailInteractor alloc] initWithDataManager:_dataManager];
	_view = [[THLEventDetailViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLEventDetailPresenter alloc] initWithInteractor:_interactor wireframe:self];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	THLEventNavigationController *eventNavController = [[THLEventNavigationController alloc] initWithRootViewController:_view];
	[_presenter configureNavigationBar:eventNavController.navigationBar];
	[_window.rootViewController presentViewController:eventNavController animated:YES completion:NULL];
}

- (void)dismissInterface {
	[_view dismissViewControllerAnimated:YES completion:NULL];
}

- (id<THLEventDetailModuleInterface>)moduleInterface {
	return _presenter;
}

@end
