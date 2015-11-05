//
//  THLPromotionCardView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionCardView.h"
#import "THLPromotionCardInfoView.h"
#import "THLStarRatingView.h"
#import "THLRoundImageView.h"
#import "THLAppearanceConstants.h"

@interface THLPromotionCardView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) THLRoundImageView *thumnailImageView;
@property (nonatomic, strong) THLStarRatingView *ratingView;
@property (nonatomic, strong) THLPromotionCardInfoView *infoView;
@end

@implementation THLPromotionCardView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self constructView];
		[self layoutView];
		[self bindView];
	}
	return self;
}

- (void)constructView {
	_nameLabel = [self newNameLabel];
	_thumnailImageView = [self newThumbnailImageView];
	_ratingView = [self newRatingView];
	_infoView = [self newInfoView];
}

- (void)layoutView {
	[self addSubviews:@[_nameLabel, _thumnailImageView, _ratingView, _infoView]];
	[_nameLabel makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsLow());
	}];

	[_thumnailImageView makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(_thumnailImageView.mas_height);
		make.top.equalTo(_nameLabel.mas_baseline).insets(kTHLEdgeInsetsLow());
		make.bottom.equalTo(_ratingView.mas_top).insets(kTHLEdgeInsetsLow());
	}];

	[_ratingView makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(_thumnailImageView);
	}];

	[_infoView makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.right.insets(kTHLEdgeInsetsHigh());
		make.top.equalTo(_ratingView.mas_bottom).insets(kTHLEdgeInsetsLow());
	}];
}

- (void)bindView {
	RAC(self.nameLabel, text) = RACObserve(self, hostName);
	RAC(self.thumnailImageView, image) = RACObserve(self, hostThumbnail);
	RAC(self.ratingView, rating) = RACObserve(self, hostRating);
	RAC(self.infoView, arrivalTime) = RACObserve(self, arrivalTime);
	RAC(self.infoView, guestlistSpace) = RACObserve(self, guestlistSpace);
	RAC(self.infoView, coverCharge) = RACObserve(self, coverCharge);
	RAC(self.infoView, femaleRatio) = RACObserve(self, femaleRatio);
}

#pragma mark - Constructors
- (UILabel *)newNameLabel {
	UILabel *label = THLNUILabel(kTHLNUIUndef);
	return label;
}

- (THLRoundImageView *)newThumbnailImageView {
	THLRoundImageView *imageView = [THLRoundImageView new];
	return imageView;
}

- (THLStarRatingView *)newRatingView {
	THLStarRatingView *ratingView = [THLStarRatingView new];
	return ratingView;
}

- (THLPromotionCardInfoView *)newInfoView {
	THLPromotionCardInfoView *infoView = [THLPromotionCardInfoView new];
	return infoView;
}
@end
