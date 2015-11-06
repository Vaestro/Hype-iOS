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
#import "THLGuestlistInviteEntity.h"

@interface THLEventDetailPresenter()
<
THLEventDetailInteractorDelegate
>

@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;
@property (nonatomic, strong) id<THLEventDetailView> view;
@property (nonatomic) THLGuestlistStatus guestlistReviewStatus;

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
    WEAKSELF();
	_view = view;
    
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    
    RACCommand *actionBarButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if (WSELF.guestlistReviewStatus == THLGuestlistStatusAccepted ||
            WSELF.guestlistReviewStatus  == THLGuestlistStatusPendingHost ||
            WSELF.guestlistReviewStatus == THLGuestlistStatusPendingInvite)
        {
            [WSELF handleViewGuestlistAction];
        } else {
//            TODO: Create logic so that Guests with Declined Guestlists can have another guestlist invite to the same event if their other one is declined
            [WSELF handleCreateGuestlistAction];
        }
        return [RACSignal empty];
    }];
    
    [RACObserve(WSELF, guestlistReviewStatus) subscribeNext:^(id _) {
        [_view setActionBarButtonStatus:_guestlistReviewStatus];
    }];
    
    [_view setDismissCommand:dismissCommand];
	[_view setLocationImageURL:_eventEntity.location.imageURL];
	[_view setPromoImageURL:_eventEntity.imageURL];
	[_view setEventName:_eventEntity.title];
	[_view setPromoInfo:_eventEntity.info];
	[_view setLocationName:_eventEntity.location.name];
	[_view setLocationInfo:_eventEntity.location.info];
	[_view setLocationAddress:_eventEntity.location.fullAddress];
    [_view setActionBarButtonCommand:actionBarButtonCommand];
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


- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)window {
    _eventEntity = eventEntity;
    
    [_interactor getPlacemarkForLocation:_eventEntity.location];
    [_interactor checkValidGuestlistInviteForEvent:_eventEntity.objectId];
    [_interactor getPromotionForEvent:_eventEntity.objectId];
	[_wireframe presentInterfaceInWindow:window];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleViewGuestlistAction {
    [self.moduleDelegate eventDetailModule:self guestlist:_guestlistEntity guestlistInvite:_guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)_view];
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

- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(NSString *)eventId error:(NSError *)error {
    WEAKSELF();
    if (!error && guestlistInvite) {
        _guestlistInviteEntity = guestlistInvite;
        _guestlistEntity = _guestlistInviteEntity.guestlist;
        if (_guestlistInviteEntity.response == THLStatusPending) {
            WSELF.guestlistReviewStatus = THLGuestlistStatusPendingInvite;
        }
        else if (_guestlistEntity.reviewStatus == THLStatusPending) {
            WSELF.guestlistReviewStatus = THLGuestlistStatusPendingHost;
        }
        else if (_guestlistEntity.reviewStatus == THLStatusAccepted) {
            WSELF.guestlistReviewStatus = THLGuestlistStatusAccepted;
        }
        else if (_guestlistEntity.reviewStatus == THLStatusDeclined) {
            WSELF.guestlistReviewStatus = THLGuestlistStatusDeclined;
        }
    }
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
