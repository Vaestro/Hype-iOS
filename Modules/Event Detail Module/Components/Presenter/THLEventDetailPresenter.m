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
#import "THLGuestlistInviteEntity.h"
#import "THLLocationEntity.h"

@interface THLEventDetailPresenter()<THLEventDetailInteractorDelegate>

@property (nonatomic, strong) id<THLEventDetailView> view;
@property (nonatomic) BOOL guestHasAcceptedInvite;
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
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
        if (![THLUser currentUser]) {
            [WSELF handleNeedLoginAction];
        } else {
            if (_guestHasAcceptedInvite) {
                [WSELF handleViewGuestlistAction];
            } else {
                //            TODO: Create logic so that Guests with Declined Guestlists can have another guestlist invite to the same event if their other one is declined
                [WSELF handleCreateGuestlistAction];
            }
        }
        

        return [RACSignal empty];
    }];
    
    [RACObserve(self, guestHasAcceptedInvite) subscribeNext:^(id _) {
        [WSELF.view setUserHasAcceptedInvite:WSELF.guestHasAcceptedInvite];
    }];
    
	[self.view setEventName:_eventEntity.title];
    [self.view setEventDate:[NSString stringWithFormat:@"%@, %@", _eventEntity.date.thl_weekdayString, _eventEntity.date.thl_timeString]];
	[self.view setPromoInfo:_eventEntity.info];
    [self.view setPromoImageURL:_eventEntity.imageURL];
    if (_eventEntity.maleCover > 0 && _eventEntity.femaleCover == 0) {
        [self.view setCoverInfo:[NSString stringWithFormat:@"$%@ (Guys only)", [NSNumber numberWithFloat:_eventEntity.maleCover ]]];
    } else {
        [self.view setCoverInfo:[NSString stringWithFormat:@"$%@", [NSNumber numberWithFloat:_eventEntity.maleCover ]]];
    }
    [self.view setActionBarButtonCommand:actionBarButtonCommand];
    [self.view setLocationInfo:_eventEntity.location.info];
    [self.view setLocationAddress:_eventEntity.location.fullAddress];
    [self.view setLocationMusicTypes:[NSString stringWithFormat:@"%@", [_eventEntity.location.musicTypes componentsJoinedByString:@" | "]]];
    [self.view setLocationAttireRequirement:_eventEntity.location.attireRequirement];
    
    if (_eventEntity.femaleRatio == 1) {
        [self.view setRatioInfo:@"1 Girl : 1 Guy"];
    } else if (_eventEntity.femaleRatio > 1) {
        [self.view setRatioInfo:[NSString stringWithFormat:@"%d Girls : 1 Guy", _eventEntity.femaleRatio]];
    } else {
        [self.view setRatioInfo:@"No ratio required"];
    }

}

- (void)configureNavigationBar:(THLEventNavigationBar *)navBar {
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];

	[navBar setTitleText:_eventEntity.location.name];
	[navBar setLocationImageURL:_eventEntity.location.imageURL];
	[navBar setDismissCommand:dismissCommand];
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
}

- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)window {
    _eventEntity = eventEntity;
    [_interactor getPlacemarkForLocation:_eventEntity.location];
	[_wireframe presentInterfaceInWindow:window];
    
#ifdef DEBUG
#else
    [Answers logCustomEventWithName:@"Events"
                   customAttributes:@{@"Venue Name & Event Date": [NSString stringWithFormat:@"%@ %@", _eventEntity.location.name, _eventEntity.date.thl_dayOfTheWeek ]}];
#endif
}

- (void)checkForInvite {
    [_interactor checkValidGuestlistInviteForEvent:_eventEntity];
}

- (void)handleNeedLoginAction {
    [self.moduleDelegate userNeedsLoginOnViewController:(UIViewController *)_view];
}

- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleViewGuestlistAction {
    [self.moduleDelegate eventDetailModule:self guestlist:_guestlistInviteEntity.guestlist guestlistInvite:_guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)self.view];
}

- (void)handleCreateGuestlistAction {
    [self.moduleDelegate eventDetailModule:self event:_eventEntity presentGuestlistInvitationInterfaceOnController:(UIViewController *)self.view];
}

#pragma mark - THLEventDetailInteractorDelegate
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error {
	if (!error && placemark) {
		[self.view setLocationPlacemark:placemark];
	}
}


- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(THLEventEntity *)event error:(NSError *)error {
    if (!error && guestlistInvite) {
        _guestlistInviteEntity = guestlistInvite;
        _eventEntity = event;
        if (_guestlistInviteEntity.response == THLStatusAccepted) {
            self.guestHasAcceptedInvite = TRUE;
        }
    }
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
