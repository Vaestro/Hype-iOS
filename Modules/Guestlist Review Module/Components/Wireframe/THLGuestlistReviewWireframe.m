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
#import "THLGuestlistTicketView.h"

@interface THLGuestlistReviewWireframe()
@property (nonatomic, strong) THLGuestlistReviewInteractor *interactor;
@property (nonatomic, strong) THLGuestlistReviewDataManager *dataManager;
@property (nonatomic, strong) THLGuestlistReviewPresenter *presenter;
@property (nonatomic, strong) UIViewController *currentView;

@property (nonatomic, strong) THLGuestlistReviewViewController *partyView;
@property (nonatomic, strong) THLGuestlistTicketView *ticketView;
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
    _partyView = [[THLGuestlistReviewViewController alloc] initWithNibName:nil bundle:nil];
    _ticketView = [[THLGuestlistTicketView alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLGuestlistReviewPresenter alloc] initWithWireframe:self
                                                                 interactor:_interactor];
}

#pragma mark - Interface
- (void)presentPartyViewInController:(UIViewController *)controller {
    _controller = controller;
    [_presenter configureView:_partyView];
    _currentView = _partyView;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_controller.view.window.layer addAnimation:transition forKey:nil];
    
    [_controller presentViewController:_partyView animated:NO completion:NULL];
}

- (void)presentTicketViewInController:(UIViewController *)controller {
    _controller = controller;
    [_presenter configureTicketView:_ticketView];
    _currentView = _ticketView;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_ticketView];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [_controller.view.window.layer addAnimation:transition forKey:nil];
    
    [_controller presentViewController:navigationController animated:NO completion:NULL];
}

- (void)presentPartyViewOnTicketView {
    [_presenter configureView:_partyView];
    _currentView = _partyView;
    [_ticketView.navigationController pushViewController:_partyView animated:YES];
}

- (void)presentDetailsForEvent:(THLEventEntity *)eventEntity {
    [_presenter.moduleDelegate guestlistReviewModule:_presenter userDidSelectViewEventEntity:eventEntity onViewController:_ticketView];
}

- (void)presentDetailsForEventOnPartyView:(THLEventEntity *)eventEntity{
    [_presenter.moduleDelegate guestlistReviewModule:_presenter userDidSelectViewEventEntity:eventEntity onViewController:_partyView];
}

- (void)presentInController:(UIViewController *)controller {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:controller];
    keyWindow.rootViewController = nvc;
}

- (void)dismissInterface {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_ticketView.view.window.layer addAnimation:transition forKey:nil];
    
    [_ticketView dismissViewControllerAnimated:NO completion:^{
        [_presenter.moduleDelegate dismissGuestlistReviewWireframe];
    }];
}

- (void)dismissPartyView {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_partyView.view.window.layer addAnimation:transition forKey:nil];
    
    [_partyView dismissViewControllerAnimated:NO completion:^{
        [_presenter.moduleDelegate dismissGuestlistReviewWireframe];
    }];
}

- (void)dismissPartyViewAndShowTicketView {
    [_partyView dismissViewControllerAnimated:NO completion:^{
        _partyView = [[THLGuestlistReviewViewController alloc] initWithNibName:nil bundle:nil];
        [_presenter configureTicketView:_ticketView];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_ticketView];
        [_controller presentViewController:navigationController animated:NO completion:nil];
    }];
}

- (id<THLGuestlistReviewModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
