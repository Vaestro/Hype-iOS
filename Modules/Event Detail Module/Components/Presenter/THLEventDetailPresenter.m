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
#import "THLUser.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"

@interface THLEventDetailPresenter()
<
THLEventDetailInteractorDelegate
>

@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;
@property (nonatomic, strong) id<THLEventDetailView> view;
@property (nonatomic) BOOL guestlistReviewStatus;

@end

@implementation THLEventDetailPresenter
@synthesize moduleDelegate;

- (instancetype)initWithInteractor:(THLEventDetailInteractor *)interactor
						 wireframe:(THLEventDetailWireframe *)wireframe {
	if (self = [super init]) {
		_interactor = interactor;
		_interactor.delegate = self;
		_wireframe = wireframe;
	}
	return self;
}

- (void)configureView:(id<THLEventDetailView>)view {
	_view = view;

	[view setLocationImageURL:_eventEntity.location.imageURL];
	[view setPromoImageURL:_eventEntity.imageURL];
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
	[_interactor getPlacemarkForLocation:_eventEntity.location];
    [_interactor getGuestlistForGuest:[THLUser currentUser].objectId forEvent:_eventEntity.objectId];

    RACCommand *actionBarButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleCreateGuestlistAction];
        return [RACSignal empty];
    }];
    
    [RACObserve(self, guestlistReviewStatus) subscribeNext:^(NSNumber *b) {
        BOOL activeGuestlist = [b boolValue];
        [view setActionBarButtonStatus:activeGuestlist];
    }];
    
    [view setActionBarButtonCommand:actionBarButtonCommand];
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
    [_interactor getPromotionForEvent:_eventEntity.objectId];
	[_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleCreateGuestlistAction {
    [self.moduleDelegate eventDetailModule:self promotion:_promotionEntity presentGuestlistInvitationInterfaceOnController:(UIViewController *)_view];
}

#pragma mark - THLEventDetailInteractorDelegate
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error {
	if (!error && placemark) {
		[_view setLocationPlacemark:placemark];
	}
}

- (void)interactor:(THLEventDetailInteractor *)interactor didGetPromotion:(THLPromotionEntity *)promotionEntity forEvent:(THLEventEntity *)eventEntity error:(NSError *)error {
    if (!error && promotionEntity) {
        _promotionEntity = promotionEntity;
    }
}

- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlist:(THLGuestlistEntity *)guestlist forGuest:(NSString *)guestId forEvent:(NSString *)eventId error:(NSError *)error {
    if (!error && guestlist) {
        _guestlistEntity = guestlist;
        if (!_guestlistEntity) {
            self.guestlistReviewStatus = NO;
        } else {
            self.guestlistReviewStatus = YES;
        }
    }
}
@end
