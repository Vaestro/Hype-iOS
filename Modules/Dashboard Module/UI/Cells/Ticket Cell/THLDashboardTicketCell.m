//
//  THLDashboardTicketCell.m
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardTicketCell.h"
#import "UIView+DimView.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"
#import "THLEventTicketVenueView.h"
#import "THLEventTicketPromotionView.h"
#import "THLStatusView.h"

@interface THLDashboardTicketCell()
@property (nonatomic, strong) UIImageView *venueImageView;
@property (nonatomic, strong) UILabel *venueNameLabel;
@property (nonatomic, strong) UILabel *eventTimeLabel;
@property (nonatomic, strong) UILabel *guestlistReviewStatusLabel;
@property (nonatomic, strong) THLStatusView *statusView;

@end

@implementation THLDashboardTicketCell
@synthesize locationImageURL;
@synthesize hostImageURL;
@synthesize hostName;
@synthesize eventName;
@synthesize eventDate;
@synthesize locationName;
@synthesize guestlistReviewStatus;
@synthesize guestlistReviewStatusTitle;

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
        make.bottom.equalTo([WSELF venueNameLabel].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF guestlistReviewStatusLabel].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(20);
        make.width.mas_equalTo([WSELF statusView].mas_height);
        make.centerY.equalTo([WSELF guestlistReviewStatusLabel].mas_centerY);
    }];
    
    [_guestlistReviewStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo([WSELF statusView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.venueNameLabel, text, @"") = RACObserve(self, locationName);
    RAC(_statusView, status) = RACObserve(self, guestlistReviewStatus);
    RAC(_guestlistReviewStatusLabel, text, @"") = RACObserve(self, guestlistReviewStatusTitle);
    RAC(self.eventTimeLabel, text, @"") = RACObserve(self, eventDate);
    
    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.venueImageView sd_setImageWithURL:url];
    }];
}

#pragma mark - Constructors

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
    [imageView dimView];
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
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    return label;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
