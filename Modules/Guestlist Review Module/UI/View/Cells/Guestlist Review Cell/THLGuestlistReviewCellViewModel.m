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
    if (_guestlistInviteEntity.response == THLStatusPending || _guestlistInviteEntity.response == THLStatusAccepted || _guestlistInviteEntity.response == THLStatusDeclined) {
        [cellView setNameText:_guestlistInviteEntity.guest.firstName];
        [cellView setImageURL:_guestlistInviteEntity.guest.imageURL];
    }
    else {
//        TODO: Hack to get placeholder image to show, this logic should not be here
        [cellView setNameText:@"Pending Signup"];
    }
}
@end
