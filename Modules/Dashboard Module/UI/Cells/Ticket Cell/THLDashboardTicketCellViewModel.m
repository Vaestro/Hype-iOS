//
//  THLDashboardTicketCellViewModel.m
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardTicketCellViewModel.h"
#import "THLDashboardTicketCellView.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLGuestEntity.h"
#import "THLHostEntity.h"

@interface THLDashboardTicketCellViewModel()
@property (nonatomic, readonly) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, readonly) THLPromotionEntity *promotionEntity;
@property (nonatomic, readonly) THLEventEntity *eventEntity;

@end

@implementation THLDashboardTicketCellViewModel
- (instancetype)initWithGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite {
    if (self = [super init]) {
        _guestlistInviteEntity = guestlistInvite;
        _guestlistEntity = _guestlistInviteEntity.guestlist;
        _promotionEntity = _guestlistEntity.promotion;
        _eventEntity = _promotionEntity.event;
    }
    return self;
}

- (void)configureView:(id<THLDashboardTicketCellView>)cellView {
    
    [cellView setLocationImageURL:_eventEntity.location.imageURL];
    [cellView setPromotionMessage:_promotionEntity.promotionMessage];
    [cellView setLocationName:_eventEntity.location.name];
    [cellView setEventName:_eventEntity.title];
    [cellView setEventDate:[NSString stringWithFormat:@"%@, %@", _eventEntity.date.thl_weekdayString, _eventEntity.date.thl_timeString]];
    [cellView setHostImageURL:_promotionEntity.host.imageURL];
    [cellView setHostName:_promotionEntity.host.firstName];
    [cellView setGuestlistReviewStatus:_guestlistEntity.reviewStatus];
    switch (_guestlistEntity.reviewStatus) {
        case THLStatusPending: {
            [cellView setGuestlistReviewStatusTitle:@"Guestlist Pending"];
            break;
        }
        case THLStatusAccepted: {
            [cellView setGuestlistReviewStatusTitle:@"Guestlist Accepted"];
            
            break;
        }
        case THLStatusDeclined: {
            [cellView setGuestlistReviewStatusTitle:@"Guestlist Declined"];
            break;
        }
        default: {
            break;
        }
    }
}

@end
