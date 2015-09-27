//
//  THLTitledContentView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"
#import "THLAppearanceConstants.h"
@interface THLTitledContentView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation THLTitledContentView
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
	_separatorView = [self newSeparatorView];
	_contentView = [self newContentView];
}

- (void)layoutView {
	[self addSubviews:@[_titleLabel,
						_separatorView,
						_contentView]];

	[_titleLabel makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsNone());
	}];

	[_separatorView makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_titleLabel.mas_baseline).insets(kTHLEdgeInsetsLow());
	}];

	[_contentView makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_separatorView.mas_baseline).insets(kTHLEdgeInsetsLow());
	}];
}

- (void)bindView {
	RAC(self.titleLabel, text) = RACObserve(self, title);
	RAC(self.titleLabel, textColor) = RACObserve(self, titleColor);
	RAC(self.separatorView, backgroundColor) = RACObserve(self, dividerColor);
}

#pragma mark - Constructors
- (UIView *)newContentView {
	UIView *view = [UIView new];
	return view;
}

- (UILabel *)newTitleLabel {
	UILabel *label = THLNUILabel(kTHLNUISectionTitle);
	label.alpha = 0.7;
	return label;
}

- (UIView *)newSeparatorView {
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor whiteColor];
	view.alpha = 0.7;
	return view;
}

@end
