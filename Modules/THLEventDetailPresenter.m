//
//  THLEventDetailPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailPresenter.h"
#import "THLEventDetailView.h"
#import "THLEventDetailWireframe.h"
#import "THLEventDetailInteractor.h"

#import "THLEventNavigationBar.h"
#import "THLEvent.h"

@interface THLEventDetailPresenter()
@property (nonatomic, strong) THLEvent *event;
@end

@implementation THLEventDetailPresenter
@synthesize moduleDelegate;

- (instancetype)initWithInteractor:(THLEventDetailInteractor *)interactor
						 wireframe:(THLEventDetailWireframe *)wireframe {
	if (self = [super init]) {
		_interactor = interactor;
		_wireframe = wireframe;
	}
	return self;
}

- (void)configureView:(id<THLEventDetailView>)view {
	[view setLocationImageURL:_event.location.imageURL];
	[view setPromoImageURL:_event.promoImageURL];
	[view setEventName:_event.title];
	[view setPromoInfo:_event.promoInfo];
	[view setLocationName:_event.location.name];
	[view setLocationInfo:_event.location.info];
	[view setLocationAddress:_event.location.fullAddress];

	RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];

	[view setDismissCommand:dismissCommand];
}

- (void)configureNavigationBar:(THLEventNavigationBar *)navBar {
	[navBar setTitleText:_event.location.name];
	[navBar setSubtitleText:_event.title];
	[navBar setDateText:_event.date.thl_weekdayString];
	[navBar setLocationImageURL:_event.location.imageURL];

	RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];

	[navBar setDismissCommand:command];
}


- (void)presentEventDetailInterfaceForEvent:(THLEvent *)event inWindow:(UIWindow *)window {
	_event = event;
	[_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}
@end
