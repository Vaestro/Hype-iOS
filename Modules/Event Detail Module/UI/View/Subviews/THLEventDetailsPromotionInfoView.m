//
//  THLEventDetailsPromotionInfoView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailsPromotionInfoView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLEventDetailsPromotionInfoViewImageViewHeight = 150;

@interface THLEventDetailsPromotionInfoView()
@property (nonatomic, strong) UILabel *eventDetailsLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation THLEventDetailsPromotionInfoView

- (void)constructView {
    [super constructView];
    _eventDetailsLabel = [self newEventDetailsLabel];
    _imageView = [self newImageView];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_eventDetailsLabel,
                                    _imageView]];
    WEAKSELF();
    [_eventDetailsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsLow());
        make.left.right.equalTo(kTHLEdgeInsetsNone());
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF eventDetailsLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(kTHLEdgeInsetsHigh());
        make.height.equalTo(kTHLEventDetailsPromotionInfoViewImageViewHeight);
    }];
}

- (void)bindView {
    WEAKSELF();
    [super bindView];
    RAC(self.eventDetailsLabel, text) = RACObserve(self, promotionInfo);
    
    [[RACObserve(self, promoImageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
    
    [RACObserve(self.promoImageURL, isValid) subscribeNext:^(id x) {
        [WSELF updateConstraints];
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    __block CGFloat height = (self.promoImageURL.isValid) ? kTHLEventDetailsPromotionInfoViewImageViewHeight : 0;
    [_imageView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

#pragma mark - Constructors
- (UILabel *)newEventDetailsLabel {
    UILabel *eventDetailsLabel = THLNUILabel(kTHLNUIDetailTitle);
    eventDetailsLabel.numberOfLines = 0;
    return eventDetailsLabel;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}

@end
