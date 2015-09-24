//
//  THLPromotionCardInfoCell.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionCardInfoCell.h"
#import "THLAppearanceConstants.h"

static CGSize const kTHLPromotionCardInfoCellIconImageViewSize = {20, 20};


@interface THLPromotionCardInfoCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation THLPromotionCardInfoCell
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
	_detailLabel = [self newDetailLabel];
	_iconImageView = [self newIconImageView];
}

- (void)layoutView {
	UIView *labelContainerView = [UIView new];
	[labelContainerView addSubviews:@[_titleLabel, _detailLabel]];
	[_titleLabel makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsNone());
		make.baseline.equalTo(_detailLabel.mas_top).insets(kTHLEdgeInsetsNone());
	}];

	[_titleLabel makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.insets(kTHLEdgeInsetsNone());
	}];

	[self addSubviews:@[_iconImageView, labelContainerView]];

	[_iconImageView makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(kTHLPromotionCardInfoCellIconImageViewSize);
		make.left.insets(kTHLEdgeInsetsNone());
		make.centerY.offset(0);
	}];

	[labelContainerView makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.insets(kTHLEdgeInsetsNone());
		make.left.equalTo(_iconImageView.mas_right).insets(kTHLEdgeInsetsNone());
	}];
}

- (void)bindView {
	RAC(self.titleLabel, text) = RACObserve(self, title);
	RAC(self.detailLabel, text) = RACObserve(self, detail);
	RAC(self.iconImageView, image) = RACObserve(self, icon);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
	UILabel *label = THLNUILabel(kTHLNUIUndef);
	return label;
}

- (UILabel *)newDetailLabel {
	UILabel *label = THLNUILabel(kTHLNUIUndef);
	return label;
}

- (UIImageView *)newIconImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	return imageView;
}

@end
