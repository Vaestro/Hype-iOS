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
            if (WSELF.guestHasAcceptedInvite) {
                [WSELF.view showAlertView];
//                [WSELF handleViewGuestlistAction];
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
    
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    
    [self.view setTitleText:_eventEntity.location.name];
    [self.view setLocationImageURL:_eventEntity.location.imageURL];
    [self.view setDismissCommand:dismissCommand];
    
	[self.view setEventName:_eventEntity.title];
    [self.view setEventDate:[NSString stringWithFormat:@"%@, %@", _eventEntity.date.thl_weekdayString, _eventEntity.date.thl_timeString]];
	[self.view setPromoInfo:_eventEntity.info];
    [self.view setPromoImageURL:_eventEntity.imageURL];
    [self.view setCoverInfo: [self generateCoverInfoText]];
    [self.view setActionBarButtonCommand:actionBarButtonCommand];
    [self.view setLocationInfo:_eventEntity.location.info];
    [self.view setLocationAddress:_eventEntity.location.fullAddress];
    [self.view setLocationMusicTypes:[NSString stringWithFormat:@"%@", [_eventEntity.location.musicTypes componentsJoinedByString:@" | "]]];
    [self.view setLocationAttireRequirement:_eventEntity.location.attireRequirement];
    [self.view setAgeRequirement:[NSString stringWithFormat:@"%d+", _eventEntity.ageRequirement]];

    [self.view setExclusiveEvent:_eventEntity.requiresApproval];
    if (_eventEntity.maleRatio == 0) {
        [self.view setRatioInfo:@"Girls Only"];
    }
    else if (_eventEntity.femaleRatio == 1) {
        [self.view setRatioInfo:@"1 Girl : 1 Guy"];
    } else if (_eventEntity.femaleRatio > 1) {
        [self.view setRatioInfo:[NSString stringWithFormat:@"%d Girls : 1 Guy", _eventEntity.femaleRatio]];
    } else {
        [self.view setRatioInfo:nil];
    }
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


- (NSString *)generateCoverInfoText {
    if ([THLUser currentUser].sex && _eventEntity.maleTicketPrice > 0) {
        return [NSString stringWithFormat:@"$ %.2f", _eventEntity.maleTicketPrice];
    } else if ([THLUser currentUser].sex && _eventEntity.femaleTicketPrice > 0) {
        return [NSString stringWithFormat:@"$ %.2f", _eventEntity.femaleTicketPrice];
    } else {
        return @"Free Entry";
    }
}



- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity onViewController:(UIViewController *)viewController {
    _eventEntity = eventEntity;
    [_interactor getPlacemarkForLocation:_eventEntity.location];
	[_wireframe presentInterfaceOnViewController:viewController];
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
        if (_guestlistInviteEntity.response == THLStatusAccepted) {
            self.guestHasAcceptedInvite = TRUE;
        }
    }
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
