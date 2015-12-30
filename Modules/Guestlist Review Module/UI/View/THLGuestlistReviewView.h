//
//  THLGuestlistReviewView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCPopup.h"

typedef NS_OPTIONS(NSInteger, THLGuestlistReviewerStatus) {
    THLGuestlistReviewerStatusPendingGuest = 0,
    THLGuestlistReviewerStatusAttendingGuest,
    THLGuestlistReviewerStatusOwner,
    THLGuestlistReviewerStatusPendingHost,
    THLGuestlistReviewerStatusActiveHost,
    THLGuestlistReviewerStatus_Count
};

@class THLViewDataSource;

@protocol THLGuestlistReviewView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;

@property (nonatomic) NSNumber *reviewerStatus;
@property (nonatomic) BOOL showRefreshAnimation;
@property (nonatomic) THLActivityStatus showActivityIndicator;

@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, strong) RACCommand *declineCommand;
@property (nonatomic, strong) RACCommand *decisionCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *showMenuCommand;
@property (nonatomic, strong) RACCommand *menuAddCommand;
- (void)showGuestlistMenuView:(UIView *)menuView;
- (void)hideGuestlistMenuView:(UIView *)menuView;
- (void)handleCallAction;
- (void)confirmActionWithMessage:(NSString *)text acceptTitle:(NSString *)acceptTitle declineTitle:(NSString *)declineTitle;
@end
