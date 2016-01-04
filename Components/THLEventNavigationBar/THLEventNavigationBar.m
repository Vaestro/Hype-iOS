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

static CGFloat kTHLEventNavigationBarHeight = 125;

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
    _imageView = [self newImageView];
}

- (void)layoutView {
    [self addSubviews:@[_imageView, _dismissButton]];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(UIEdgeInsetsZero);
        make.top.offset(-20);
    }];
 
    UIView *titleContainerView = [UIView new];
    [titleContainerView addSubview:_titleLabel];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsHigh());
        make.right.top.insets(kTHLEdgeInsetsNone());
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];

    [self addSubview:titleContainerView];
    [titleContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(titleContainerView));
        make.top.greaterThanOrEqualTo([WSELF.dismissButton mas_bottom]).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsHigh());
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

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width, kTHLEventNavigationBarHeight);
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
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
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
    return button;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end