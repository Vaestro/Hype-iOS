//
//  THLHostDashboardNotificationCellViewModel.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardNotificationCellViewModel.h"
#import "THLHostDashboardNotificationCellView.h"
#import "THLGuestlistEntity.h"
#import "THLEventEntity.h"
#import "THLGuestEntity.h"
#import "THLLocationEntity.h"

@interface THLHostDashboardNotificationCellViewModel()

@end

@implementation THLHostDashboardNotificationCellViewModel
- (instancetype)initWithGuestlist:(THLGuestlistEntity *)guestlist {
    if (self = [super init]) {
        _guestlistEntity = guestlist;
    }
    return self;
}

- (void)configureView:(id<THLHostDashboardNotificationCellView>)cellView {
    [cellView setLocationName:[NSString stringWithFormat:@"@ %@", _guestlistEntity.event.location.name]];
    [cellView setNotificationStatus:_guestlistEntity.reviewStatus];
    [cellView setSenderIntroductionText:[NSString stringWithFormat:@"%@ joined your guestlist", _guestlistEntity.owner.firstName]];
    [cellView setSenderImageURL:_guestlistEntity.owner.imageURL];
    [cellView setDate:[NSString stringWithFormat:@"%@, %@", _guestlistEntity.event.date.thl_weekdayString, _guestlistEntity.event.date.thl_timeString]];
}

@end

