//
//  THLGuestlistReviewView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLCPopup.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"

typedef NS_OPTIONS(NSInteger, THLGuestlistReviewerStatus) {
    THLGuestlistPendingGuest = 0,
    THLGuestlistAttendingGuest,
    THLGuestlistOwner,
    THLGuestlistPendingHost,
    THLGuestlistActiveHost,
    THLGuestlistDeclinedHost,
    THLGuestlistCheckedInGuest,
    THLGuestlistCheckedInOwner,
    THLGuestlistAttendingGuestPendingApproval,
    THLGuestlistOwnerPendingApproval
};

@class THLViewDataSource;

@protocol THLGuestlistReviewView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;

@property (nonatomic) NSNumber *reviewerStatus;
@property (nonatomic) BOOL showRefreshAnimation;

@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, strong) RACCommand *declineCommand;
@property (nonatomic, strong) RACCommand *responseCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic, strong) RACCommand *viewDismissAndShowTicketCommand;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *formattedDate;
@property (nonatomic, strong) NSURL *headerViewImage;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) RACCommand *showMenuCommand;

@property (nonatomic, strong) RACCommand *menuAddCommand;
@property (nonatomic) THLStatus guestlistReviewStatus;
@property (nonatomic, copy) NSString *guestlistReviewStatusTitle;
@property (nonatomic, strong) THLGuestlistEntity *guestlist;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInvite;

@property (nonatomic) BOOL viewAppeared;

- (void)showGuestlistMenuView:(UIView *)menuView;
- (void)showResponseView:(UIView *)responseView;

- (void)hideGuestlistMenuView:(UIView *)menuView;
- (void)handleCallActionWithCallerdId:(NSString *)twilioNumber toHostNumber:(NSString *)hostNumber;

- (void)hideActionBar;

@end
