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
#import "THLEvent.h"
#import "THLEventDiscoveryCellViewModel.h"

@interface THLEventDiscoveryPresenter()
@property (nonatomic, weak) THLEventDiscoveryWireframe *wireframe;
@property (nonatomic, strong) THLEventDiscoveryInteractor *interactor;
@end

@implementation THLEventDiscoveryPresenter
- (instancetype)initWithWireframe:(THLEventDiscoveryWireframe *)wireframe
					   interactor:(THLEventDiscoveryInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
	}
	return self;
}

- (void)configureView:(id<THLEventDiscoveryView>)view {
	THLViewDataSource *dataSource = [_interactor generateDataSource];
	dataSource.dataTransformBlock = ^id(THLEvent *event) {
		return [[THLEventDiscoveryCellViewModel alloc] initWithEvent:event];
	};

	[view setDataSource:dataSource];

	RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleIndexPathSelection:(NSIndexPath *)input];
		return [RACSignal empty];
	}];

	[view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

- (void)presentEventDiscoveryInterfaceInWindow:(UIWindow *)window {

}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
	NSLog(@"Selected indexPath: %@", indexPath);
}
@end
