//
//  THLPerkDetailWireframe.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailWireframe.h"
#import "THLPerkDetailInteractor.h"
#import "THLPerkDetailPresenter.h"
#import "THLPerkDetailDataManager.h"
#import "THLPerkDetailViewController.h"
#import "THLPerksViewController.h"
#import "THLPerkDetailDataManager.h"


@interface THLPerkDetailWireframe()
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) THLPerkDetailPresenter *presenter;
@property (nonatomic, strong) THLPerkDetailInteractor *interactor;
@property (nonatomic, strong) THLPerkDetailDataManager *dataManager;
@property (nonatomic, strong) THLPerkDetailViewController *view;
@end

@implementation THLPerkDetailWireframe
- (instancetype)initWithPerkItemStoreService:(id<THLPerkItemStoreServiceInterface>)perkItemStoreService
                                entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _perkItemStoreService = perkItemStoreService;
        _entityMapper = entityMapper;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLPerkDetailDataManager alloc] initWithPerkStoreItemService:_perkItemStoreService entityMapper:_entityMapper];
    _interactor = [[THLPerkDetailInteractor alloc] initWithDataManager:_dataManager];
    _view = [[THLPerkDetailViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLPerkDetailPresenter alloc] initWithInteractor:_interactor wireframe:self];
}

//_dataManager = [[THLPerkDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper perkService:_perkItemStoreService];
//_interactor = [[THLPerkInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
//_view = [[THLPerksViewController alloc] initWithNibName:nil bundle:nil];
//_presenter = [[THLPerkPresenter alloc] initWithWireframe:self interactor:_interactor];





- (void)presentPerkDetailonViewController:(UIViewController *)viewController {
    _controller = viewController;
    [_presenter configureView:_view];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_view];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_controller.view.window.layer addAnimation:transition forKey:nil];
    
    [_controller presentViewController:navigationController animated:NO completion:NULL];
}

- (void)dismissInterface {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_view.navigationController.view.window.layer addAnimation:transition forKey:nil];
    
    [_view.navigationController dismissViewControllerAnimated:NO completion:^{
        [_presenter.moduleDelegate dismissPerkDetailWireframe];
    }];
}

- (id<THLPerkDetailModuleInterface>)moduleInterface {
    return _presenter;
}
@end
