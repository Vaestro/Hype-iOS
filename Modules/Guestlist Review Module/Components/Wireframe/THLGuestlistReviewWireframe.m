//
//  THLGuestlistReviewWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewWireframe.h"
#import "THLGuestlistReviewInteractor.h"
#import "THLGuestlistReviewDataManager.h"
#import "THLGuestlistReviewPresenter.h"
#import "THLGuestlistReviewViewController.h"

@interface THLGuestlistReviewWireframe()
@property (nonatomic, strong) THLGuestlistReviewInteractor *interactor;
@property (nonatomic, strong) THLGuestlistReviewDataManager *dataManager;
@property (nonatomic, strong) THLGuestlistReviewPresenter *presenter;
@property (nonatomic, strong) THLGuestlistReviewViewController *view;
@property (nonatomic, strong) UIViewController *controller;
@end

@implementation THLGuestlistReviewWireframe
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore
                   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        _dataStore = dataStore;
        _viewDataSourceFactory = viewDataSourceFactory;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLGuestlistReviewDataManager alloc] initWithGuestlistService:_guestlistService entityMapper:_entityMapper dataStore:_dataStore];
    _interactor = [[THLGuestlistReviewInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLGuestlistReviewViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLGuestlistReviewPresenter alloc] initWithWireframe:self
                                                                 interactor:_interactor];
}

#pragma mark - Interface
- (void)presentInterfaceInController:(UIViewController *)controller {
    _controller = controller;
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
        [_presenter.moduleDelegate dismissGuestlistReviewWireframe];
    }];
}

- (id<THLGuestlistReviewModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
