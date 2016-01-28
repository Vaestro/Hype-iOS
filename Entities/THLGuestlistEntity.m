//
//  THLGuestProfileViewController+THLGuestlistEntity.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLGuestlistEntity.h"

@implementation THLGuestlistEntity
- (BOOL)isAccepted {
    return self.reviewStatus == THLStatusAccepted;
}

- (BOOL)isPending {
    return self.reviewStatus == THLStatusPending;
}

- (BOOL)isDeclined {
    return self.reviewStatus == THLStatusDeclined;
}
@end