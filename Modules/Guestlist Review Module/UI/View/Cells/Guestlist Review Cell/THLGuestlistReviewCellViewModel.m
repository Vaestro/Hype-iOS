//
//  THLGuestlistReviewCellViewModel.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewCellViewModel.h"
#import "THLGuestlistReviewCellView.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestEntity.h"

@implementation THLGuestlistReviewCellViewModel
- (instancetype)initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)guestlistInvite {
    if (self = [super init]) {
        _guestlistInviteEntity = guestlistInvite;
    }
    return self;
}

- (void)configureView:(id<THLGuestlistReviewCellView>)cellView {
    [cellView setGuestlistInviteStatus:_guestlistInviteEntity.response];
    if (_guestlistInviteEntity.response != THLStatusNone) {
        [cellView setNameText:_guestlistInviteEntity.guest.firstName];
        [cellView setImageURL:_guestlistInviteEntity.guest.imageURL];
    }
    else {
        [cellView setNameText:@"Unregistered User"];
    }
}

@end
