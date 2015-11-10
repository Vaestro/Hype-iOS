//
//  THLEventHostingPresenter.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingPresenter.h"

#import "THLEventHostingWireframe.h"
#import "THLEventHostingInteractor.h"
#import "THLViewDataSource.h"

#import "THLEventNavigationBar.h"
#import "THLEventHostingView.h"

#import "THLUser.h"
#import "THLEventEntity.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLEventHostingView.h"
#import "THLEventHostingTableCellViewModel.h"

@interface THLEventHostingPresenter()<THLEventHostingInteractorDelegate>
@property (nonatomic, strong) id<THLEventHostingView> view;
@property (nonatomic, strong) THLEventEntity *eventEntity;

@property (nonatomic) BOOL refreshing;
@end

@implementation THLEventHostingPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLEventHostingWireframe *)wireframe interactor:(THLEventHostingInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

- (void)configureView:(id<THLEventHostingView>)view {
    WEAKSELF();
    _view = view;
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLEventHostingTableCellViewModel alloc] initWithGuestlistEntity:(THLGuestlistEntity *)item];
    };
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleRefreshAction];
        return [RACSignal empty];
    }];
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
}

- (void)configureNavigationBar:(THLEventNavigationBar *)navBar {
    WEAKSELF();
    [navBar setTitleText:_eventEntity.location.name];
    [navBar setSubtitleText:_eventEntity.title];
    [navBar setDateText:_eventEntity.date.thl_weekdayString];
    [navBar setLocationImageURL:_eventEntity.location.imageURL];
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    
    [navBar setDismissCommand:command];
}

- (void)presentEventHostingInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)window {
    _eventEntity = eventEntity;
    [_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
    THLGuestlistEntity *guestlistEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
    [self.moduleDelegate eventHostingModule:self userDidSelectGuestlistEntity:guestlistEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)self.view];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlists];
}

#pragma mark - THLEventHostingInteractorDelegate
- (void)interactor:(THLEventHostingInteractor *)interactor didUpdateGuestlists:(NSError *)error {
    self.refreshing = NO;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
