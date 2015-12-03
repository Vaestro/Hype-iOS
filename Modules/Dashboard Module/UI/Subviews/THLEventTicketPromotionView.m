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

@interface THLEventTicketPromotionView()
@property (nonatomic, strong) THLPersonIconView *iconView;
@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) UILabel *yourHostLabel;
@property (nonatomic, strong) UIView *hairlineView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *eventTimeLabel;


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
//    _iconView = [self newIconView];
//    _hostNameLabel = [self newHostNameLabel];
//    _yourHostLabel = [self newYourHostLabel];
//    _hairlineView = [self newHairlineView];
    _textView = [self newTextView];
    _eventTimeLabel = [self newEventTimeLabel];
}

- (void)layoutView {
    [self addSubviews:@[_textView,
//                        _iconView,
//                        _hostNameLabel,
//                        _yourHostLabel,
//                        _hairlineView,
                        _eventTimeLabel]];
    
    WEAKSELF();
    [_eventTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
//    [_iconView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF eventTimeLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//        make.left.insets(kTHLEdgeInsetsSuperHigh());
//        make.size.equalTo(CGSizeMake1(60));
//    }];
//    
//    [_yourHostLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo([WSELF iconView].mas_right).insets(kTHLEdgeInsetsHigh());
//        make.top.equalTo([WSELF eventTimeLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//        make.right.insets(kTHLEdgeInsetsHigh());
//    }];
//    
//    [_hostNameLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo([WSELF iconView].mas_right).insets(kTHLEdgeInsetsHigh());
//        make.top.equalTo([WSELF yourHostLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
//        make.bottom.equalTo(WSELF.iconView);
//        make.right.insets(kTHLEdgeInsetsSuperHigh());
//    }];
//    
//    [_hairlineView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
//        make.top.equalTo([WSELF hostNameLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
//    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF eventTimeLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    [[RACObserve(self, promotionMessage) filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 0;
    }] subscribeNext:^(id x) {
        [WSELF.textView setText:x];
    }];
    
//    RAC(self.iconView, imageURL) = RACObserve(self, hostImageURL);
    RAC(self.eventTimeLabel, text, @"") = RACObserve(self, eventTime);
//    RAC(self.hostNameLabel, text, @"") = RACObserve(self, hostName);
}

#pragma mark - Constructors
- (UILabel *)newVenueNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    return label;
}

- (THLPersonIconView *)newIconView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newYourHostLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"YOUR HOST";
    return label;
}

- (UILabel *)newHostNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UILabel *)newEventTimeLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UIView *)newHairlineView {
    UIView *view = [UIView new];
    view.backgroundColor = kTHLNUIPrimaryFontColor;
    return view;
}

- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    textView.userInteractionEnabled = NO;
    [textView setScrollEnabled:NO];
    textView.text = @"Upon arrival at the venue, check-in with the host. Your Host will keep you updated with what you need to know about the event.";
    return textView;
}

@end
