//
//  THLEventDetailPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailPresenter.h"
#import "THLEventDetailWireframe.h"
#import "THLEventDetailInteractor.h"

#import "THLEventNavigationBar.h"
#import "THLEventDetailView.h"

#import "THLUser.h"
#import "THLEventEntity.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistInviteEntity.h"

@interface THLEventDetailPresenter()
<
THLEventDetailInteractorDelegate
>
@property (nonatomic, strong) id<THLEventDetailView> view;
@property (nonatomic) THLGuestlistStatus guestlistReviewStatus;

@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;

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
	self.view = view;
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [WSELF checkForInvite];
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
    
    [RACObserve(self, guestlistReviewStatus) subscribeNext:^(id _) {
        [WSELF.view setActionBarButtonStatus:WSELF.guestlistReviewStatus];
    }];
    
//    [_view setDismissCommand:dismissCommand];
	[self.view setLocationImageURL:_eventEntity.location.imageURL];
	[self.view setPromoImageURL:_eventEntity.imageURL];
	[self.view setEventName:_eventEntity.title];
	[self.view setPromoInfo:_eventEntity.info];
	[self.view setLocationName:_eventEntity.location.name];
	[self.view setLocationInfo:_eventEntity.location.info];
	[self.view setLocationAddress:_eventEntity.location.fullAddress];
    [self.view setActionBarButtonCommand:actionBarButtonCommand];
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
    [_interactor getPromotionForEvent:_eventEntity.objectId];
	[_wireframe presentInterfaceInWindow:window];
}

- (void)checkForInvite {
    [_interactor checkValidGuestlistInviteForUser:[THLUser currentUser] atEvent:_eventEntity.objectId];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleViewGuestlistAction {
    [self.moduleDelegate eventDetailModule:self guestlist:_guestlistInviteEntity.guestlist guestlistInvite:_guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)self.view];
}

- (void)handleCreateGuestlistAction {
    [self.moduleDelegate eventDetailModule:self promotion:_promotionEntity presentGuestlistInvitationInterfaceOnController:(UIViewController *)self.view];
}

#pragma mark - THLEventDetailInteractorDelegate
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error {
	if (!error && placemark) {
		[self.view setLocationPlacemark:placemark];
	}
}

- (void)interactor:(THLEventDetailInteractor *)interactor didGetPromotion:(THLPromotionEntity *)promotionEntity forEvent:(THLEventEntity *)eventEntity error:(NSError *)error {
    if (!error && promotionEntity) {
        _promotionEntity = promotionEntity;
    }
}

- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(NSString *)eventId error:(NSError *)error {
    if (!error && guestlistInvite) {
        _guestlistInviteEntity = guestlistInvite;
        THLGuestlistEntity *guestlistEntity = _guestlistInviteEntity.guestlist;
        if (_guestlistInviteEntity.response == THLStatusPending) {
            self.guestlistReviewStatus = THLGuestlistStatusPendingInvite;
        }
        else if (guestlistEntity.reviewStatus == THLStatusPending) {
            self.guestlistReviewStatus = THLGuestlistStatusPendingHost;
        }
        else if (guestlistEntity.reviewStatus == THLStatusAccepted) {
            self.guestlistReviewStatus = THLGuestlistStatusAccepted;
        }
    }
    else {
        self.guestlistReviewStatus = THLGuestlistStatusDeclined;
    }
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
