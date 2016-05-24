//
//  THLEventInviteCell.m
//  Hype
//
//  Created by Edgar Li on 5/24/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventInviteCell.h"
#import "THLPersonIconView.h"
#import "THLStatusView.h"
#import "THLAppearanceConstants.h"

@interface THLEventInviteCell()

@end

@implementation THLEventInviteCell
@synthesize statusView = _statusView;
@synthesize personIconView = _personIconView;
@synthesize dateLabel = _dateLabel;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize senderIntroductionLabel = _senderIntroductionLabel;

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
//    [super layoutSubviews];
    WEAKSELF();
    [_personIconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(SV(WSELF.personIconView)).insets(kTHLEdgeInsetsHigh());
        make.bottom.lessThanOrEqualTo(SV(WSELF.personIconView)).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(SV(WSELF.personIconView)).sizeOffset(CGSizeMake(50, -67));
        make.width.equalTo([WSELF personIconView].mas_height);
        make.centerY.equalTo(0);
    }];
    
    [_senderIntroductionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.personIconView.mas_top).mas_offset(-10);
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF personIconView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_locationNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF senderIntroductionLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF personIconView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.centerY.equalTo(0);
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF locationNameLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF personIconView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(WSELF.personIconView.mas_bottom).mas_offset(10);
    }];
}

#pragma mark -
#pragma mark Accessors

- (THLPersonIconView *)personIconView {
    if (!_personIconView) {
        _personIconView = [THLPersonIconView new];
        [self.contentView addSubview:_personIconView];
    }
    return _personIconView;
}

- (THLStatusView *)statusView {
    if (!_statusView) {
        _statusView = [THLStatusView new];
        [_statusView setScale:1];
        _statusView.status = THLStatusPending;
        [self.contentView addSubview:_statusView];
    }
    return _statusView;
}

- (UILabel *)senderIntroductionLabel {
    if (!_senderIntroductionLabel) {
        _senderIntroductionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _senderIntroductionLabel.adjustsFontSizeToFitWidth = YES;
        _senderIntroductionLabel.numberOfLines = 1;
        _senderIntroductionLabel.minimumScaleFactor = 0.5;

        [self.contentView addSubview:_senderIntroductionLabel];
    }
    return _senderIntroductionLabel;
}

- (UILabel *)locationNameLabel {
    if (!_locationNameLabel) {
        _locationNameLabel = THLNUILabel(kTHLNUIRegularDetailTitle);
        _locationNameLabel.adjustsFontSizeToFitWidth = YES;
        _locationNameLabel.numberOfLines = 1;
        _locationNameLabel.minimumScaleFactor = 0.5;
        
        [self.contentView addSubview:_locationNameLabel];
    }
    return _locationNameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = THLNUILabel(kTHLNUIDetailTitle);
        _dateLabel.adjustsFontSizeToFitWidth = YES;
        _dateLabel.numberOfLines = 1;
        _dateLabel.minimumScaleFactor = 0.5;
        [_dateLabel setTextColor:kTHLNUIGrayFontColor];
        
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
