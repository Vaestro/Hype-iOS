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
#import "THLEventEntity.h"

@interface THLEventDetailPresenter()
@property (nonatomic, strong) THLEventEntity *eventEntity;
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
//	[view setLocationImageURL:_event.location.imageURL];
//	[view setPromoImageURL:_event.promoImageURL];
	[view setEventName:_eventEntity.title];
	[view setPromoInfo:_eventEntity.info];
	[view setLocationName:_eventEntity.location.name];
	[view setLocationInfo:_eventEntity.location.info];
	[view setLocationAddress:_eventEntity.location.fullAddress];

	RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];

	[view setDismissCommand:dismissCommand];
}

- (void)configureNavigationBar:(THLEventNavigationBar *)navBar {
	[navBar setTitleText:_eventEntity.location.name];
	[navBar setSubtitleText:_eventEntity.title];
	[navBar setDateText:_eventEntity.date.thl_weekdayString];
	[navBar setLocationImageURL:_eventEntity.location.imageURL];

	RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];

	[navBar setDismissCommand:command];
}


- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)window {
	_eventEntity = eventEntity;
	[_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}
@end
