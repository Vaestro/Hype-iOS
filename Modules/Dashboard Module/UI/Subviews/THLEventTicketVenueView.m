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
#import "THLStatusView.h"

@interface THLEventTicketVenueView()
@property (nonatomic, strong) UIImageView *venueImageView;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *eventTimeLabel;
@property (nonatomic, strong) UILabel *guestlistReviewStatusLabel;
@property (nonatomic, strong) THLStatusView *statusView;
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
    _eventTimeLabel = [self newEventTimeLabel];
    _statusView = [self newStatusView];
    _guestlistReviewStatusLabel = [self newGuestlistReviewStatusLabel];
}

- (void)layoutView {
    [self setBackgroundColor:kTHLNUIPrimaryBackgroundColor];
	[self addSubviews:@[_venueImageView,
					   _venueNameLabel,
                        _eventTimeLabel,
                        _statusView,
                        _guestlistReviewStatusLabel]];

    
	[_venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
	}];
    
    WEAKSELF();
    [_eventTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF venueNameLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
	[_venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsSuperHigh());
        make.right.lessThanOrEqualTo([WSELF venueImageView].mas_right);
        make.top.greaterThanOrEqualTo([WSELF venueImageView].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(20);
        make.width.mas_equalTo([WSELF statusView].mas_height);
        make.centerY.equalTo([WSELF guestlistReviewStatusLabel].mas_centerY);
    }];

    [_guestlistReviewStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(kTHLEdgeInsetsLow());
        make.left.equalTo([WSELF statusView].mas_right);
    }];
    
    [self addGradientLayer];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.venueNameLabel, text, @"") = RACObserve(self, locationName);
    RAC(_statusView, status) = RACObserve(self, guestlistReviewStatus);
    RAC(_guestlistReviewStatusLabel, text, @"") = RACObserve(self, guestlistReviewStatusTitle);
    RAC(self.eventTimeLabel, text, @"") = RACObserve(self, eventTime);
    
    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.venueImageView sd_setImageWithURL:url];
    }];
}

- (void)addGradientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.venueImageView.bounds;
    gradient.colors = @[(id)[UIColor blackColor].CGColor,
                        (id)[UIColor clearColor].CGColor];
    
    self.venueImageView.layer.mask = gradient;
}

- (UIImageView *)newVenueImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UILabel *)newVenueNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
	return label;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
    return statusView;
}

- (UILabel *)newGuestlistReviewStatusLabel {
    UILabel *guestlistReviewStatusLabel = THLNUILabel(kTHLNUIDetailTitle);
    guestlistReviewStatusLabel.adjustsFontSizeToFitWidth = YES;
    guestlistReviewStatusLabel.textAlignment = NSTextAlignmentLeft;
    return guestlistReviewStatusLabel;
}

- (UILabel *)newEventTimeLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

@end
