//
//  THLEventDetailsPromotionInfoView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailsPromotionInfoView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLEventDetailsPromotionInfoViewImageViewHeight = 92;

@interface THLEventDetailsPromotionInfoView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation THLEventDetailsPromotionInfoView

- (void)constructView {
	[super constructView];
	_textView = [self newTextView];
	_imageView = [self newImageView];
}

- (void)layoutView {
	[super layoutView];
	[self.contentView addSubviews:@[_textView,
									_imageView]];

	[_textView makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.equalTo(kTHLEdgeInsetsNone());
	}];

	[_imageView makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.equalTo(kTHLEdgeInsetsNone());
		make.top.equalTo(_textView.mas_bottom).insets(kTHLEdgeInsetsHigh());
		make.height.equalTo(kTHLEventDetailsPromotionInfoViewImageViewHeight);
	}];
}

- (void)bindView {
	[super bindView];
	RAC(self.textView, text) = RACObserve(self, promotionInfo);

	[[RACObserve(self, promoImageURL) filter:^BOOL(NSURL *url) {
		return [url isValid];
	}] subscribeNext:^(NSURL *url) {
		[_imageView sd_setImageWithURL:url];
	}];
}

#pragma mark - Constructors
- (UITextView *)newTextView {
	UITextView *textView = THLNUITextView(kTHLNUIUndef);
	[textView setScrollEnabled:NO];
	return textView;
}

- (UIImageView *)newImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	return imageView;
}

@end
