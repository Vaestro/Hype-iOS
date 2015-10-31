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
        make.top.equalTo(kTHLEdgeInsetsNone());
        make.left.right.equalTo(kTHLEdgeInsetsLow());
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(kTHLEdgeInsetsNone());
        make.top.equalTo(_textView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(kTHLEdgeInsetsHigh());
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
    
    [RACObserve(self.promoImageURL, isValid) subscribeNext:^(id x) {
        [self updateConstraints];
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
- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    return textView;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

@end
