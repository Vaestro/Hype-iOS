//
//  THLEventHostingTableCellViewModel.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingTableCellViewModel.h"
#import "THLEventHostingTableCellView.h"
#import "THLGuestlistEntity.h"
#import "THLGuestEntity.h"

@implementation THLEventHostingTableCellViewModel
- (instancetype)initWithGuestlistEntity:(THLGuestlistEntity *)guestlist {
    if (self = [super init]) {
        _guestlistEntity = guestlist;
    }
    return self;
}

- (void)configureView:(id<THLEventHostingTableCellView>)cellView {
    [cellView setGuestlistTitle:NSStringWithFormat(@"%@'s Guestlist", _guestlistEntity.owner.firstName)];
    [cellView setImageURL:_guestlistEntity.owner.imageURL];
    [cellView setGuestlistReviewStatus: _guestlistEntity.reviewStatus];
    switch (_guestlistEntity.reviewStatus) {
        case THLStatusPending: {
            [cellView setGuestlistReviewStatusTitle:@"Pending"];
            break;
        }
        case THLStatusAccepted: {
            [cellView setGuestlistReviewStatusTitle:@"Accepted"];

            break;
        }
        case THLStatusDeclined: {
            [cellView setGuestlistReviewStatusTitle:@"Declined"];
            break;
        }
        default: {
            break;
        }
    }

}
@end
