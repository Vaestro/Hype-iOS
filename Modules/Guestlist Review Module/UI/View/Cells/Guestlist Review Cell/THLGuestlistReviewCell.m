//
//  THLGuestlistReviewCell.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/1/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewCell.h"
#import "THLAppearanceConstants.h"
#import "UIImageView+WebCache.h"

#import "THLPersonIconView.h"
#import "THLStatusView.h"

@interface THLGuestlistReviewCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) THLStatusView *statusView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation THLGuestlistReviewCell
@synthesize image;
@synthesize nameText;
@synthesize imageURL;
@synthesize guestlistInviteStatus;

//TODO: Initiate with identifier
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
    _nameLabel = [self newNameLabel];
    _statusLabel = [self newStatusLabel];
    _statusView = [self newStatusView];
}

- (void)layoutView {
    self.clipsToBounds = YES;

    [self addSubviews:@[_iconImageView, _nameLabel, _statusLabel, _statusView]];
    
    WEAKSELF();
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh()).priorityHigh();
        make.left.top.greaterThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
      make.size.equalTo(SV(WSELF.iconImageView)).sizeOffset(CGSizeMake(-50, -60));
        make.centerX.offset(0);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF iconImageView].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    
    [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF nameLabel].mas_bottom).insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.size.equalTo(CGSizeMake(25, 25));
        make.right.equalTo([WSELF iconImageView].mas_right);
    }];
}

- (void)bindView {
    RAC(_iconImageView, imageURL) = RACObserve(self, imageURL);
    RAC(_iconImageView, image) = RACObserve(self, image);
    RAC(_nameLabel, text) = RACObserve(self, nameText);
    RAC(_statusView, status) = RACObserve(self, guestlistInviteStatus);
    WEAKSELF();
    [RACObserve(self, guestlistInviteStatus) subscribeNext:^(id x) {
        [_statusView setStatus:WSELF.guestlistInviteStatus];
        [_statusLabel setTextColor:kTHLNUIGrayFontColor];
        switch (WSELF.guestlistInviteStatus) {
            case THLStatusPending:
                [_statusLabel setText:@"Pending"];
                break;
            case THLStatusAccepted:
                [_statusLabel setText:@"Confirmed"];
                break;
            case THLStatusDeclined:
                [_statusLabel setText:@"Declined"];
                break;
            case THLStatusCheckedIn:
                [_statusLabel setText:@"Checked-In"];
                break;
            default:
                break;
        }
    }];

}

#pragma mark - Constructors
- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newStatusLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
    return statusView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
