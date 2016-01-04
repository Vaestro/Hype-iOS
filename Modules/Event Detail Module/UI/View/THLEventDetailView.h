//
//  THLEventDetailView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSInteger, THLGuestlistStatus) {
    THLGuestlistStatusNone = 0,
    THLGuestlistStatusPendingInvite,
    THLGuestlistStatusAccepted,
    THLGuestlistStatusPendingHost,
    THLGuestlistStatusDeclined,
    THLGuestlistStatusUnavailable
};

@protocol THLEventDetailView <NSObject>
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSURL *promoImageURL;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *promoInfo;
@property (nonatomic, copy) NSString *ratioInfo;
@property (nonatomic, copy) NSString *coverInfo;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationInfo;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) NSString *locationAttireRequirement;
@property (nonatomic, copy) NSString *locationMusicTypes;

@property (nonatomic) THLGuestlistStatus actionBarButtonStatus;
@property (nonatomic, strong) CLPlacemark *locationPlacemark;
@property (nonatomic, strong) RACCommand *actionBarButtonCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic) BOOL viewAppeared;
- (void)showDetailsView:(UIView *)detailView;
- (void)hideDetailsView:(UIView *)detailView;
@end
