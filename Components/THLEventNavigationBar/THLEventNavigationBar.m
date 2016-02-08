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
@property (nonatomic, strong) UIImageView *imageView;
@end

//static CGFloat kTHLEventNavigationBarHeight = 125;

@implementation THLEventNavigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)constructView {
    _dismissButton = [self newDismissButton];
    _titleLabel = [self newTitleLabel];
    _imageView = [self newImageView];
}

- (void)layoutView {
    [self addSubviews:@[_imageView, _dismissButton, _titleLabel]];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
//        make.top.offset(-20);x
    }];

    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(_titleLabel));
        make.top.greaterThanOrEqualTo([WSELF.dismissButton mas_bottom]).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.titleLabel, text, @"") = RACObserve(self, titleText);
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);

    RACSignal *imageURLSignal = [RACObserve(self, locationImageURL) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
}

//- (CGSize)sizeThatFits:(CGSize)size {
//    return CGSizeMake([super sizeThatFits:size].width, kTHLEventNavigationBarHeight);
//}

- (void)addGradientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    CGRect frame = self.imageView.frame;
    gradient.frame = frame;
    gradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor clearColor].CGColor];

//    self.imageView.alpha = 0.5;
    self.imageView.layer.mask = gradient;
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    return label;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeCenter;
    [self addGradientLayer];

    return imageView;
}

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end