//
//  THLEventTitlesView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventTitlesView.h"
#import "THLAppearanceConstants.h"

@interface THLEventTitlesView()

@end

@implementation THLEventTitlesView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.locationNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.insets(kTHLEdgeInsetsNone());
        }];
        
        WEAKSELF();
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.insets(kTHLEdgeInsetsNone());
            make.top.equalTo([WSELF locationNameLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
        }];
        
        [self.locationNeighborhoodLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.insets(kTHLEdgeInsetsNone());
            make.top.equalTo([WSELF titleLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
        }];
        
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF locationNeighborhoodLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
            make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        }];
    }
    return self;
}

#pragma mark - Constructors
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"Raleway-ExtraBold" size:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 3;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = THLNUILabel(kTHLNUIDetailTitle);
        _dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UILabel *)locationNameLabel {
    if (!_locationNameLabel) {
        _locationNameLabel = [UILabel new];
        _locationNameLabel.font = [UIFont fontWithName:@"Raleway-ExtraBold" size:20];
        _locationNameLabel.textColor = [UIColor whiteColor];
        _locationNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationNameLabel.numberOfLines = 2;
        _locationNameLabel.textAlignment = NSTextAlignmentCenter;
        _locationNameLabel.adjustsFontSizeToFitWidth = YES;
        _locationNameLabel.minimumScaleFactor = 0.5;
        [self addSubview:_locationNameLabel];
    }

    return _locationNameLabel;
}

- (UILabel *)locationNeighborhoodLabel {
    if (!_locationNeighborhoodLabel) {
        _locationNeighborhoodLabel = [UILabel new];
        _locationNeighborhoodLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _locationNeighborhoodLabel.textColor = [UIColor whiteColor];
        _locationNeighborhoodLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationNeighborhoodLabel.numberOfLines = 1;
        _locationNeighborhoodLabel.textAlignment = NSTextAlignmentCenter;
        _locationNeighborhoodLabel.adjustsFontSizeToFitWidth = YES;
        _locationNeighborhoodLabel.minimumScaleFactor = 0.5;
        [self addSubview:_locationNeighborhoodLabel];
    }

    return _locationNeighborhoodLabel;
}
@end
