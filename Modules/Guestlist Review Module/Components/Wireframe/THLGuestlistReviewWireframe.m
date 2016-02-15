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
#import "THLDashboardViewController.h"

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
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_controller.view.window.layer addAnimation:transition forKey:nil];
    
    [_controller presentViewController:_view animated:NO completion:NULL];
}

- (void)presentInController:(UIViewController *)controller {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    keyWindow.rootViewController = nvc;
//    UITabBarController *tabController = (UITabBarController *)[keyWindow rootViewController];
//    UINavigationController *navController = (UINavigationController *)[tabController viewControllers][2];
//    THLDashboardViewController *dash = [[navController viewControllers] firstObject];
//    [dash presentModalViewController:controller animated:YES];
    //[navController showViewController:chrmvctrl sender:nil];
}

- (void)dismissInterface {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_view.view.window.layer addAnimation:transition forKey:nil];
    
    [_view dismissViewControllerAnimated:NO completion:^{
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
