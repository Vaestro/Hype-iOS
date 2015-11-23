//
//  THLNightTicketVenueView.m
//  HypeList
//
//  Created by Phil Meyers IV on 8/1/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//

#import "THLEventTicketVenueView.h"
#import "UILabel+NUI.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"

@interface THLEventTicketVenueView()
@property (nonatomic, strong) UIImageView *venueImageView;
@property (nonatomic, strong) UILabel *venueNameLabel;
@end

@implementation THLEventTicketVenueView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self constructView];
        [self layoutView];
        [self bindView];
	}
	return self;
}

- (void)constructView {
	_venueImageView = [self newVenueImageView];
	_venueNameLabel = [self newVenueNameLabel];
}

- (void)layoutView {
	[self addSubviews:@[_venueImageView,
					   _venueNameLabel]];

	[_venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.top.offset(-20);
	}];
    WEAKSELF();
	[_venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsSuperHigh());
        make.right.lessThanOrEqualTo([WSELF venueImageView].mas_right);
        make.top.greaterThanOrEqualTo([WSELF venueImageView].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.venueNameLabel, text, @"") = RACObserve(self, locationName);
    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.venueImageView sd_setImageWithURL:url];
    }];
}

- (UIImageView *)newVenueImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView dimView];
    return imageView;
}

- (UILabel *)newVenueNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
	return label;
}

@end
