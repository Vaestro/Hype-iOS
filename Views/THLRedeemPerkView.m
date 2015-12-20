//
//  THLRedeemPerkView.m
//  Hype
//
//  Created by Daniel Aksenov on 12/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLRedeemPerkView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLRedeemPerkViewSeparatorViewHeight = 1;
static CGFloat const kTHLRedeemPerkViewSeparatorViewWidth = 300;


@interface THLRedeemPerkView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *checkIconView;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *dismissButton;
@end


@implementation THLRedeemPerkView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}


- (void)constructView {
    _nameLabel = [self newNameLabel];
    _checkIconView = [self newCheckIconView];
    _underlineView = [self newUnderlineView];
    _descriptionLabel = [self newDescriptionLabel];
    _dismissButton = [self newDismissButton];
    
}

- (void)layoutView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.tintColor = [UIColor blackColor];
    
    [self addSubviews:@[_nameLabel, _checkIconView, _underlineView, _descriptionLabel, _dismissButton]];
    [_underlineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset(0);
        make.size.equalTo(CGSizeMake(kTHLRedeemPerkViewSeparatorViewWidth, kTHLRedeemPerkViewSeparatorViewHeight));
//        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsHigh());
    }];
    
    WEAKSELF();
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.underlineView.mas_top).insets(kTHLEdgeInsetsHigh());
        make.centerX.offset(0);
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_checkIconView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.nameLabel.mas_top).insets(kTHLEdgeInsetsHigh());
        make.left.top.greaterThanOrEqualTo(SV(WSELF.checkIconView)).insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(WSELF.checkIconView)).insets(kTHLEdgeInsetsHigh());
        make.centerX.offset(0);
        
    }];
    
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.underlineView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.offset(0);
        make.left.right.insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    RAC(_dismissButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(_descriptionLabel, text) = RACObserve(self, confirmationDescription);
}

- (UILabel *)newNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.text = @"Perk Redeemed";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)newCheckIconView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Clear Check"]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UIView *)newUnderlineView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 2;
    label.minimumScaleFactor = 0.5;
    return label;
}

- (UIButton *)newDismissButton {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
    return button;
}


@end
