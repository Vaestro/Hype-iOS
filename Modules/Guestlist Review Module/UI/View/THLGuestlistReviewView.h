//
//  THLGuestlistReviewView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, THLGuestlistReviewerStatus) {
    THLGuestlistReviewerStatusPendingGuest = 0,
    THLGuestlistReviewerStatusAttendingGuest,
    THLGuestlistReviewerStatusOwner,
    THLGuestlistReviewerStatusPendingHost,
    THLGuestlistReviewerStatusHost,
    THLGuestlistReviewerStatus_Count
};

@class THLViewDataSource;

@protocol THLGuestlistReviewView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;

@property (nonatomic) THLGuestlistReviewerStatus reviewerStatus;
@property (nonatomic) BOOL showRefreshAnimation;
@property (nonatomic) NSInteger showActivityIndicator;

@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, strong) RACCommand *declineCommand;
@property (nonatomic, strong) RACCommand *confirmCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;

- (void)confirmActionWithMessage:(NSString *)text;
@end
