//
//  THLGuestlistReviewCellViewModel.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistReviewCellView.h"

@protocol THLGuestlistReviewCellView;
@class THLGuestlistInviteEntity;

@interface THLGuestlistReviewCellViewModel : NSObject

@property (nonatomic, readonly, weak) THLGuestlistInviteEntity *guestlistInviteEntity;

- (instancetype)initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)guestlistInvite;
- (void)configureView:(id<THLGuestlistReviewCellView>)view;
@end
