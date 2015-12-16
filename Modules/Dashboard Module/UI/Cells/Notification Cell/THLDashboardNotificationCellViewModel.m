//
//  THLDashboardNotificationCellViewModel.m
//  TheHypelist
//
//  Created by Edgar Li on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardNotificationCellViewModel.h"
#import "THLDashboardNotificationCellView.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLGuestEntity.h"

@interface THLDashboardNotificationCellViewModel()

@end

@implementation THLDashboardNotificationCellViewModel
- (instancetype)initWithGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite {
    if (self = [super init]) {
        _guestlistInviteEntity = guestlistInvite;
    }
    return self;
}

- (void)configureView:(id<THLDashboardNotificationCellView>)cellView {
    [cellView setLocationName:[NSString stringWithFormat:@"@ %@", _guestlistInviteEntity.guestlist.promotion.event.location.name]];
    [cellView setNotificationStatus:_guestlistInviteEntity.response];
    [cellView setSenderIntroductionText:[NSString stringWithFormat:@"%@ invited you to their guestlist", _guestlistInviteEntity.guestlist.owner.firstName]];
    [cellView setSenderImageURL:_guestlistInviteEntity.guestlist.owner.imageURL];
    [cellView setDate:[NSString stringWithFormat:@"%@, %@", _guestlistInviteEntity.guestlist.promotion.event.date.thl_weekdayString, _guestlistInviteEntity.guestlist.promotion.event.date.thl_timeString]];
}

@end
