//
//  THLPartyMemberCell.m
//  Hype
//
//  Created by Edgar Li on 5/30/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPartyMemberCell.h"
#import "THLAppearanceConstants.h"
#import "UIImageView+WebCache.h"
#import "THLPersonIconView.h"
#import "THLStatusView.h"

@implementation THLPartyMemberCell
@synthesize iconImageView = _iconImageView;
@synthesize statusLabel = _statusLabel;
@synthesize nameLabel = _nameLabel;
@synthesize statusView = _statusView;

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    //    [super layoutSubviews];
    self.clipsToBounds = YES;

    WEAKSELF();
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh()).priorityHigh();
        make.left.top.greaterThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(WSELF.iconImageView)).insets(kTHLEdgeInsetsHigh());
        make.size.equalTo(SV(WSELF.iconImageView)).sizeOffset(CGSizeMake(-50, -60));
        make.centerX.offset(0);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF iconImageView].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF nameLabel].mas_bottom).insets(kTHLEdgeInsetsNone());
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.statusView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.size.equalTo(CGSizeMake(25, 25));
        make.right.equalTo([WSELF iconImageView].mas_right);
    }];
    
}



#pragma mark - Constructors
- (THLPersonIconView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [THLPersonIconView new];
        [self.contentView addSubview:_iconImageView];

    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = THLNUILabel(kTHLNUIRegularTitle);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.minimumScaleFactor = 0.5;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];

    }
    return _nameLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = THLNUILabel(kTHLNUIDetailTitle);
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.minimumScaleFactor = 0.5;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [_statusLabel setTextColor:kTHLNUIGrayFontColor];
        switch (self.guestlistInviteStatus) {
            case THLStatusNone:
                [_statusLabel setText:@"Pending Signup"];
                break;
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
        [self.contentView addSubview:_statusLabel];

    }

    return _statusLabel;
}

- (THLStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[THLStatusView alloc] initWithStatus:self.guestlistInviteStatus];
        [self.contentView addSubview:_statusView];
    }
    return _statusView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
