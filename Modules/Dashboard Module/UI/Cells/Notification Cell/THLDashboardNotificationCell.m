//
//  THLDashboardNotificationCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardNotificationCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"
#import "THLStatusView.h"

@interface THLDashboardNotificationCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) THLStatusView *statusView;
@property (nonatomic, strong) UILabel *senderIntroductionLabel;

@end

@implementation THLDashboardNotificationCell
@synthesize notificationStatus;
@synthesize senderIntroductionText;
@synthesize locationName;
@synthesize senderImageURL;
@synthesize date;
@synthesize eventName;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _iconImageView = [self newIconImageView];
    _dateLabel = [self newDateLabel];
    _locationNameLabel = [self newLocationNameLabel];
    _statusView = [self newStatusView];
    _senderIntroductionLabel = [self newSenderIntroductionLabel];
}

- (void)layoutView {
    self.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    WEAKSELF();
    [self addSubviews:@[_iconImageView, _dateLabel, _locationNameLabel, _statusView, _senderIntroductionLabel]];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.lessThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(SV(WSELF.iconImageView)).sizeOffset(CGSizeMake(50, -67));
        make.width.equalTo([WSELF iconImageView].mas_height);
        make.centerY.equalTo(0);
    }];
    
    [_senderIntroductionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.iconImageView.mas_top).mas_offset(-10);
        make.right.equalTo(WSELF.statusView.mas_left).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_locationNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF senderIntroductionLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(WSELF.statusView.mas_left).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.centerY.equalTo(0);
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF locationNameLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(WSELF.statusView.mas_left).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(WSELF.iconImageView.mas_bottom).mas_offset(10);
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(SV(WSELF.statusView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.lessThanOrEqualTo(SV(WSELF.statusView)).insets(kTHLEdgeInsetsHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
        make.centerY.equalTo(0);
    }];
}

- (void)bindView {
    RAC(_iconImageView, imageURL) = RACObserve(self, senderImageURL);
    RAC(_dateLabel, text) = RACObserve(self, date);
    RAC(_locationNameLabel, text) = RACObserve(self, locationName);
    RAC(_statusView, status) = RACObserve(self, notificationStatus);
    RAC(_senderIntroductionLabel, text) = RACObserve(self, senderIntroductionText);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.layer.cornerRadius = ViewWidth(_iconImageView)/2.0;
}

#pragma mark - Constructors
- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *imageView = [THLPersonIconView new];
    return imageView;
}

- (UILabel *)newDateLabel {
    UILabel *dateLabel = THLNUILabel(kTHLNUIDetailTitle);
    return dateLabel;
}

- (UILabel *)newLocationNameLabel {
    UILabel *locationNameLabel = THLNUILabel(kTHLNUIDetailTitle);
    return locationNameLabel;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
    [statusView setScale:1];
    return statusView;
}

- (UILabel *)newSenderIntroductionLabel {
    UILabel *senderIntroductionLabel = THLNUILabel(kTHLNUIDetailTitle);
    senderIntroductionLabel.adjustsFontSizeToFitWidth = YES;
    senderIntroductionLabel.minimumScaleFactor = 0.5;
    return senderIntroductionLabel;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
