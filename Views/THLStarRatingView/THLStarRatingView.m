//
//  THLStarRatingView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLStarRatingView.h"
#import "HCSStarRatingView.h"
#import "THLAppearanceConstants.h"

static CGFloat const ASPECT_RATIO = 247.0/40.0;

@interface THLStarRatingView()
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@end

@implementation THLStarRatingView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self constructView];
		[self layoutView];
		[self bindView];
	}
	return self;
}

- (void)constructView {
	_ratingView = [self newRatingView];
}

- (void)layoutView {
	[_ratingView makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(kTHLEdgeInsetsNone());
		make.height.equalTo(self.mas_width).dividedBy(ASPECT_RATIO);
	}];
}

- (void)bindView {
	RAC(self.ratingView, value) = RACObserve(self, rating);
}

#pragma mark - Constructors
- (HCSStarRatingView *)newRatingView {
	HCSStarRatingView *ratingView = [HCSStarRatingView new];
	ratingView.maximumValue = 5;
	ratingView.minimumValue = 0;
	ratingView.allowsHalfStars = YES;
	return ratingView;
}

@end
