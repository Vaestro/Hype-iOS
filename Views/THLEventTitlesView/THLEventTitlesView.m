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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) UILabel *locationNeighborhoodLabel;
@end

@implementation THLEventTitlesView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _dateLabel = [self newDateLabel];
    _locationNameLabel = [self newLocationNameLabel];
    _locationNeighborhoodLabel = [self newLocationNeighborhoodLabel];
}

- (void)layoutView {
    [self addSubviews:@[_locationNameLabel,
                        _titleLabel,
                        _locationNeighborhoodLabel,
                        _dateLabel
                        ]
     ];
    
    [_locationNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF locationNameLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
    }];
    
    [_locationNeighborhoodLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF titleLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF locationNeighborhoodLabel].mas_baseline).insets(kTHLEdgeInsetsLow());
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());

    }];
}

- (void)bindView {
    RAC(self.titleLabel, text) = RACObserve(self, titleText);
    RAC(self.dateLabel, text) = RACObserve(self, dateText);
    RAC(self.locationNameLabel, text) = RACObserve(self, locationNameText);
    RAC(self.locationNeighborhoodLabel, text) = RACObserve(self, locationNeighborhoodText);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newLocationNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newLocationNeighborhoodLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
