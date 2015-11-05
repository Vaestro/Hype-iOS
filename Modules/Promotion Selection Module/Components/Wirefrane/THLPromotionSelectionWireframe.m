//
//  THLPromotionSelectionWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionSelectionWireframe.h"
#import "THLPromotionSelectionDataManager.h"
#import "THLPromotionSelectionInteractor.h"
#import "THLPromotionSelectionPresenter.h"
#import "THLPromotionSelectionViewController.h"

@interface THLPromotionSelectionWireframe ()
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) THLPromotionSelectionPresenter *presenter;
@property (nonatomic, strong) THLPromotionSelectionInteractor *interactor;
@property (nonatomic, strong) THLPromotionSelectionViewController *view;
@property (nonatomic, strong) THLPromotionSelectionDataManager *dataManager;
@end

@implementation THLPromotionSelectionWireframe
- (instancetype)initWithEntityMapper:(THLEntityMapper *)entityMapper
					promotionService:(id<THLPromotionServiceInterface>)promotionService {
	if (self = [super init]) {
		_entityMapper = entityMapper;
		_promotionService = promotionService;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLPromotionSelectionDataManager alloc] initWithEntityMapper:_entityMapper promotionService:_promotionService];
	_interactor = [[THLPromotionSelectionInteractor alloc] initWithDataManager:_dataManager];
	_presenter = [[THLPromotionSelectionPresenter alloc] initWithWireframe:self interactor:_interactor];
	_view = [[THLPromotionSelectionViewController alloc] initWithNibName:nil bundle:nil];
}

- (id<THLPromotionSelectionModuleInterface>)moduleInterface {
	return _presenter;
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
