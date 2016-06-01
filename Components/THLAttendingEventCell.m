//
//  THLAttendingEventCell.m
//  Hype
//
//  Created by Edgar Li on 6/1/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAttendingEventCell.h"
#import "THLAppearanceConstants.h"

@interface THLAttendingEventCell()

@end

@implementation THLAttendingEventCell

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    //    [super layoutSubviews];
    WEAKSELF();
    [self.venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.insets(kTHLEdgeInsetsNone());
        make.right.equalTo(WSELF.centerX).insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF venueImageView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF dateLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF venueImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.centerY.equalTo(0);
    }];
    
    [self.partyTypeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF venueNameLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.right.equalTo(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF venueImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(kTHLEdgeInsetsHigh());

    }];
}

#pragma mark -
#pragma mark Accessors

- (UILabel *)partyTypeLabel {
    if (!_partyTypeLabel) {
        _partyTypeLabel = THLNUILabel(kTHLNUIRegularDetailTitle);
        _partyTypeLabel.adjustsFontSizeToFitWidth = YES;
        _partyTypeLabel.numberOfLines = 1;
        _partyTypeLabel.minimumScaleFactor = 0.5;
        [self addSubview:_partyTypeLabel];
    }
    return _partyTypeLabel;
}

- (UIImageView *)venueImageView {
    if (!_venueImageView) {
        _venueImageView = [UIImageView new];
        _venueImageView.clipsToBounds = YES;
        _venueImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_venueImageView dimView];
        [self addSubview:_venueImageView];
    }
    return _venueImageView;
}

- (UILabel *)venueNameLabel {
    if (!_venueNameLabel) {
        _venueNameLabel = THLNUILabel(kTHLNUIRegularDetailTitle);
        _venueNameLabel.adjustsFontSizeToFitWidth = YES;
        _venueNameLabel.numberOfLines = 1;
        _venueNameLabel.minimumScaleFactor = 0.5;
        
        [self.contentView addSubview:_venueNameLabel];
    }
    return _venueNameLabel;
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
