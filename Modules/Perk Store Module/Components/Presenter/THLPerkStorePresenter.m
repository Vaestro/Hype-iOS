//
//  THLPerkStorePresenter.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStorePresenter.h"
#import "THLPerkStoreView.h"
#import "THLPerkStoreWireframe.h"
#import "THLPerkStoreInteractor.h"
#import "THLViewDataSource.h"
#import "THLPerkStoreItemEntity.h"
#import "THLPerkStoreCellViewModel.h"
#import "THLUser.h"
#import "THLCreditsExplanationView.h"

//static NSString *branchMarketingLink = @"https://bnc.lt/m/aTR7pkSq0q";

@interface THLPerkStorePresenter()<THLPerkStoreInteractorDelegate>
@property (nonatomic, weak) id<THLPerkStoreView> view;
@property (nonatomic, strong) THLCreditsExplanationView *creditsExplanationView;
@property (nonatomic) BOOL refreshing;
@end


@implementation THLPerkStorePresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLPerkStoreWireframe *)wireframe
                       interactor:(THLPerkStoreInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

#pragma mark - Module Interface
- (void)presentPerkStoreInterfaceInNavigationController:(UINavigationController *)navigationController {
    [_wireframe presentPerkStoreInterfaceInNavigationController:navigationController];
}

- (void)configureView:(id<THLPerkStoreView>)view {
    _view = view;
    WEAKSELF();

    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [WSELF.interactor refreshUserCredits];
    }];
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLPerkStoreCellViewModel alloc] initWithPerkStoreItem:(THLPerkStoreItemEntity *)item];
    };
    
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF checkIfUserLoggedInThenHandleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];

    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    RACCommand *showCreditsExplanationView = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleShowCreditsExplanationAction];
        return [RACSignal empty];
    }];

    RACCommand *discoverEventsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDiscoverEventsAction];
        return [RACSignal empty];
    }];
    
//    RACCommand *inviteFriendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [WSELF handleInviteFriendsAction];
//        return [RACSignal empty];
//    }];
//    
    [_view setDataSource:dataSource];
    [_view setShowCreditsExplanationView:showCreditsExplanationView];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
    _creditsExplanationView = [THLCreditsExplanationView new];
    [_creditsExplanationView setDiscoverEventsCommand:discoverEventsCommand];
//    [_creditsExplanationView setInviteFriendsCommand:inviteFriendsCommand];

}

    
- (void)checkIfUserLoggedInThenHandleIndexPathSelection:(NSIndexPath *)indexPath {
    if (![THLUser currentUser]) {
        [self handleLogInAction];
    } else {
    THLPerkStoreItemEntity *perkStoreItemEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
    [self.moduleDelegate perkModule:self userDidSelectPerkStoreItemEntity:perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)_view];
    }
}

- (void)handleLogInAction {
    [self.moduleDelegate userNeedsLoginOnViewController:(UIViewController *)_view];
}

- (void)handleShowCreditsExplanationAction {
    [_creditsExplanationView show];
}

- (void)handleDiscoverEventsAction {
//    TODO: Add handle discover events action
}

//- (void)handleInviteFriendsAction {
//    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    while (topController.presentedViewController) {
//        topController = topController.presentedViewController;
//    }
//    
//    NSString *message = @"Check out this amazing app!";
//    NSString *shareBody = branchMarketingLink;
//    
//    NSArray *postItems = @[message, shareBody];
//    
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
//                                            initWithActivityItems:postItems
//                                            applicationActivities:nil];
//    [topController presentViewController:activityVC animated:YES completion:nil];
//}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updatePerks];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

#pragma mark - InteractorDelegate
- (void)interactor:(THLPerkStoreInteractor *)interactor didUpdatePerks:(NSError *)error {
    self.refreshing = NO;
}

- (void)interactor:(THLPerkStoreInteractor *)interactor didUpdateUserCredits:(NSError *)error {
    if (!error) {
        THLUser *currentUser = [THLUser currentUser];
        [_view setCurrentUserCredit:currentUser.credits];
    }
}
@end
