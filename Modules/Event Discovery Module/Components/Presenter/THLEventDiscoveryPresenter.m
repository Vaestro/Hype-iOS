//
//  THLEventDiscoveryPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryPresenter.h"
#import "THLEventDiscoveryView.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLEventDiscoveryInteractor.h"

#import "THLViewDataSource.h"
#import "THLEventEntity.h"
#import "THLEventDiscoveryCellViewModel.h"

@interface THLEventDiscoveryPresenter()<THLEventDiscoveryInteractorDelegate>
@property (nonatomic, weak) id<THLEventDiscoveryView> view;

@property (nonatomic) BOOL refreshing;
@end

@implementation THLEventDiscoveryPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLEventDiscoveryWireframe *)wireframe
					   interactor:(THLEventDiscoveryInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

#pragma mark - Module Interface
- (void)presentEventDiscoveryInterfaceInWindow:(UIWindow *)window {
	[_wireframe presentInWindow:window];
}

- (void)configureView:(id<THLEventDiscoveryView>)view {
	THLViewDataSource *dataSource = [_interactor generateDataSource];
	dataSource.dataTransformBlock = ^id(id item) {
		return [[THLEventDiscoveryCellViewModel alloc] initWithEvent:(THLEventEntity *)item];
	};

	[view setDataSource:dataSource];

	RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleIndexPathSelection:(NSIndexPath *)input];
		return [RACSignal empty];
	}];

	[view setSelectedIndexPathCommand:selectedIndexPathCommand];

	RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleRefreshAction];
		return [RACSignal empty];
	}];

	[view setRefreshCommand:refreshCommand];

	_view = view;

	[RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
		BOOL isRefreshing = [b boolValue];
		[view setShowRefreshAnimation:isRefreshing];
	}];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
	THLEventEntity *eventEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
	[self.moduleDelegate eventDiscoveryModule:self userDidSelectEventEntity:eventEntity];
}

- (void)handleRefreshAction {
	self.refreshing = YES;
	[_interactor updateEvents];
}

#pragma mark - InteractorDelegate
- (void)interactor:(THLEventDiscoveryInteractor *)interactor didUpdateEvents:(NSError *)error {
	self.refreshing = NO;
}
@end
