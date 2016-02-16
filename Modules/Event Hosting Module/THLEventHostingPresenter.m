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

#import "THLEventHostingNavigationBar.h"
#import "THLEventHostingView.h"

#import "THLUser.h"
#import "THLEventEntity.h"
#import "THLGuestlistEntity.h"
#import "THLLocationEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLEventHostingView.h"
#import "THLEventHostingTableCellViewModel.h"
#import "THLVenueDetailsView.h"

@interface THLEventHostingPresenter()<THLEventHostingInteractorDelegate>
@property (nonatomic, strong) id<THLEventHostingView> view;
@property (nonatomic, strong) THLVenueDetailsView *venueDetailsView;
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
        [WSELF handleIndexPathSelection:(NSIndexPath *)input];
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
    
    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
}

- (void)configureNavigationBar:(THLEventHostingNavigationBar *)navBar {
    WEAKSELF();
    [navBar setTitleText:_eventEntity.location.name];
    [navBar setLocationImageURL:_eventEntity.location.imageURL];
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    RACCommand *detailDisclosureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDetailDisclosureAction];
        return [RACSignal empty];
    }];
    
    [navBar setDismissCommand:command];
    [navBar setDetailDisclosureCommand:detailDisclosureCommand];
}

- (void)configureVenueDetailsView:(THLVenueDetailsView *)venueDetailsView {
    self.venueDetailsView = venueDetailsView;
    [self.venueDetailsView setLocationName:_eventEntity.location.name];
    [self.venueDetailsView setLocationInfo:_eventEntity.location.info];
    [self.venueDetailsView setLocationAddress:_eventEntity.location.fullAddress];
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleVenueDetailsDismissAction];
        return [RACSignal empty];
    }];
    
    [self.venueDetailsView setDismissCommand:dismissCommand];
}

- (void)presentEventHostingInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)window {
    _eventEntity = eventEntity;
    _interactor.eventEntity = _eventEntity;
    [_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

- (void)handleVenueDetailsDismissAction {
    [_view hideDetailsView:self.venueDetailsView];
    
}

- (void)handleDetailDisclosureAction {
    [_view showDetailsView:self.venueDetailsView];
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
