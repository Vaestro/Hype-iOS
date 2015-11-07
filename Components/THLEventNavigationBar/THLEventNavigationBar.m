//
//  THLEventNavigationBar.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventNavigationBar.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"

@interface THLEventNavigationBar()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

static CGFloat kTHLEventNavigationBarHeight = 125;
static CGFloat kTHLEventNavigationBarSublabelAlpha = 0.75;
static CGFloat kTHLEventNavigationBarDateLabelMaxWidth = 100;
static CGRect const kTHLEventNavigationBarDismissButtonFrame = {{5,6},{37,30}};

@implementation THLEventNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _dismissButton = [self newDismissButton];
    _titleLabel = [self newTitleLabel];
    _subtitleLabel = [self newSubtitleLabel];
    _dateLabel = [self newDateLabel];
    _imageView = [self newImageView];
}

- (void)layoutView {
    [self addSubviews:@[_imageView, _dismissButton, _dateLabel]];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(UIEdgeInsetsZero);
        make.top.offset(-20);
    }];
    
//    TODO:Add Gradient Layer to ImageView
//    CAGradientLayer *backgroundLayer = [CAGradientLayer dimGradientLayer];
//    backgroundLayer.frame = _imageView.frame;
//    [_imageView.layer insertSublayer:backgroundLayer atIndex:0];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.insets(kTHLEdgeInsetsHigh());
        make.width.lessThanOrEqualTo(kTHLEventNavigationBarDateLabelMaxWidth);
    }];
    
    UIView *titleContainerView = [UIView new];
    [titleContainerView addSubviews:@[_titleLabel,
                                      _subtitleLabel]];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF subtitleLabel].mas_top);
    }];
    
    [_subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
    [self addSubview:titleContainerView];
    [titleContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo([WSELF.dateLabel mas_left]);
        make.top.greaterThanOrEqualTo([WSELF.dismissButton mas_bottom]).insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.titleLabel, text, @"") = RACObserve(self, titleText);
    RAC(self.subtitleLabel, text, @"") = RACObserve(self, subtitleText);
    RAC(self.dateLabel, text, @"") = RACObserve(self, dateText);
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    
    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width, kTHLEventNavigationBarHeight);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    return label;
}

- (UILabel *)newSubtitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.alpha = kTHLEventNavigationBarSublabelAlpha;
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.alpha = kTHLEventNavigationBarSublabelAlpha;
    return label;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView dimView];
    return imageView;
}

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc]initWithFrame:kTHLEventNavigationBarDismissButtonFrame];
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
    return button;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end