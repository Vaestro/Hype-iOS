//
//  THLEventTitlesView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventTitlesView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLEventTitlesViewSeparatorViewHeight = 0.5;
static CGFloat const kTHLEventTitlesViewSeparatorViewWidth = 112.5;

@interface THLEventTitlesView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *locationNameLabel;
@property (nonatomic, strong) UILabel *locationNeighborhoodLabel;
@property (nonatomic, strong) UIView *separatorView;
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
	_separatorView = [self newSeparatorView];
}

- (void)layoutView {
	[self addSubviews:@[_titleLabel,
					   _dateLabel,
					   _locationNeighborhoodLabel,
						_locationNameLabel,
						_separatorView]];

	[_locationNameLabel makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsNone());
	}];

	[_titleLabel makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_locationNameLabel.mas_baseline).insets(kTHLEdgeInsetsLow());
	}];

	[_separatorView makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_titleLabel.mas_baseline).insets(kTHLEdgeInsetsLow());
		make.size.equalTo(CGSizeMake(kTHLEventTitlesViewSeparatorViewWidth, kTHLEventTitlesViewSeparatorViewHeight));
		make.centerX.offset(0);
	}];

	[_locationNeighborhoodLabel makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_separatorView.mas_bottom);
	}];

	[_dateLabel makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_locationNeighborhoodLabel.mas_baseline).insets(kTHLEdgeInsetsLow());
	}];
}

- (void)bindView {
	RAC(self.titleLabel, text) = RACObserve(self, titleText);
	RAC(self.dateLabel, text) = RACObserve(self, dateText);
	RAC(self.locationNameLabel, text) = RACObserve(self, locationNameText);
	RAC(self.locationNeighborhoodLabel, text) = RACObserve(self, locationNeighborhoodText);
	RAC(self.separatorView, backgroundColor) = RACObserve(self, separatorColor);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
	return THLNUILabel(kTHLNUIBoldTitle);
}

- (UILabel *)newDateLabel {
	return THLNUILabel(kTHLNUIDetailTitle);
}

- (UILabel *)newLocationNameLabel {
	return THLNUILabel(kTHLNUIRegularTitle);
}

- (UILabel *)newLocationNeighborhoodLabel {
	return THLNUILabel(kTHLNUIDetailTitle);
}

- (UIView *)newSeparatorView {
	return THLNUIView(kTHLNUIUndef);
}
@end
