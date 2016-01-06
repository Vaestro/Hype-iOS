//
//  THLEventTicketPromotionView.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventTicketPromotionView.h"
#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"
#import "THLStatusView.h"

@interface THLEventTicketPromotionView()
@property (nonatomic, strong) THLPersonIconView *iconView;
@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) UILabel *yourHostLabel;
@property (nonatomic, strong) UIView *hairlineView;
@property (nonatomic, strong) UILabel *eventMessage;
@property (nonatomic, strong) UILabel *eventTimeLabel;
@property (nonatomic, strong) UILabel *guestlistReviewStatusLabel;
@property (nonatomic, strong) THLStatusView *statusView;

@end

@implementation THLEventTicketPromotionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}


- (void)constructView {
    _eventMessage = [self newEventMessage];
    _eventTimeLabel = [self newEventTimeLabel];
    _statusView = [self newStatusView];
    _guestlistReviewStatusLabel = [self newGuestlistReviewStatusLabel];
}

- (void)layoutView {
    [self addSubviews:@[_eventMessage,
                        _eventTimeLabel,
                        _statusView,
                        _guestlistReviewStatusLabel]];
    
    WEAKSELF();
    [_eventTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo([WSELF guestlistReviewStatusLabel].mas_height);
        make.width.mas_equalTo([WSELF statusView].mas_height);
        make.centerY.equalTo([WSELF guestlistReviewStatusLabel].mas_centerY);
    }];
    
    [_guestlistReviewStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF eventTimeLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.equalTo([WSELF statusView].mas_right);
    }];
    
    [_eventMessage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF guestlistReviewStatusLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.bottom.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(_statusView, status) = RACObserve(self, guestlistReviewStatus);
    RAC(_guestlistReviewStatusLabel, text, @"") = RACObserve(self, guestlistReviewStatusTitle);
    [[RACObserve(self, promotionMessage) filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 0;
    }] subscribeNext:^(id x) {
        [WSELF.eventMessage setText:x];
    }];
    
    RAC(self.eventTimeLabel, text, @"") = RACObserve(self, eventTime);
}

#pragma mark - Constructors
- (UILabel *)newVenueNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    return label;
}

- (THLStatusView *)newStatusView {
    THLStatusView *statusView = [THLStatusView new];
    [statusView setScale:0.5];
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

- (UILabel *)newEventMessage {
    UILabel *eventMessage = THLNUILabel(kTHLNUIDetailTitle);
    eventMessage.text = @"Upon arrival at the venue, check-in with the host. Your Host will keep you updated with what you need to know about the event.";
    eventMessage.numberOfLines = 0;
    return eventMessage;
}

@end
