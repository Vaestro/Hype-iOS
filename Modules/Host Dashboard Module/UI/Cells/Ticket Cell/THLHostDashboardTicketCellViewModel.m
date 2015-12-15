//
//  THLHostDashboardTicketCellViewModel.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardTicketCellViewModel.h"
#import "THLHostDashboardTicketCellView.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLGuestEntity.h"
#import "THLHostEntity.h"

@interface THLHostDashboardTicketCellViewModel()
@property (nonatomic, readonly) THLPromotionEntity *promotionEntity;
@property (nonatomic, readonly) THLEventEntity *eventEntity;

@end

@implementation THLHostDashboardTicketCellViewModel
- (instancetype)initWithGuestlist:(THLGuestlistEntity *)guestlist {
    if (self = [super init]) {
        _guestlistEntity = guestlist;
        _promotionEntity = _guestlistEntity.promotion;
        _eventEntity = _promotionEntity.event;
    }
    return self;
}

- (void)configureView:(id<THLHostDashboardTicketCellView>)cellView {
    
    [cellView setLocationImageURL:_eventEntity.location.imageURL];
    [cellView setLocationName:_eventEntity.location.name];
    [cellView setEventName:_eventEntity.title];
    [cellView setEventDate:[NSString stringWithFormat:@"%@, %@", _eventEntity.date.thl_weekdayString, _eventEntity.date.thl_timeString]];
}

@end
