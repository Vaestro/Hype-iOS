//
//  THLGuestlistReviewHeaderView.m
//  Hype
//
//  Created by Daniel Aksenov on 1/4/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewHeaderView.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "THLStatusView.h"


@interface THLGuestlistReviewHeaderView()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *guestlistReviewStatusLabel;
@property (nonatomic, strong) THLStatusView *statusView;
@end


//static CGFloat kTHLGuestlistReviewHeaderHeight = 125;

@implementation THLGuestlistReviewHeaderView
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
    _menuButton = [self newMenuButton];
    _imageView = [self newImageView];
    _titleLabel = [self newTitleLabel];
    _dateLabel = [self newDateLabel];
    _statusView = [self newStatusView];
    _guestlistReviewStatusLabel = [self newGuestlistReviewStatusLabel];
    
}

- (void)layoutView {
    [self addSubviews:@[_dismissButton, _menuButton, _imageView, _titleLabel, _dateLabel, _statusView, _guestlistReviewStatusLabel]];
    
    [self sendSubviewToBack:_imageView];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(150);
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.dismissButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsLow());

    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.titleLabel.mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsLow());
    }];
    
    [_statusView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo([WSELF guestlistReviewStatusLabel].mas_height);
        make.width.mas_equalTo([WSELF statusView].mas_height);
        make.centerY.equalTo([WSELF guestlistReviewStatusLabel].mas_centerY);
    }];
    
    [_guestlistReviewStatusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF dateLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.equalTo([WSELF statusView].mas_right);
        make.right.insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.titleLabel, text) = RACObserve(self, title);
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(self.menuButton, rac_command) = RACObserve(self, showMenuCommand);
    RAC(self.dateLabel, text) = RACObserve(self, formattedDate);
    RAC(_statusView, status) = RACObserve(self, guestlistReviewStatus);
    RAC(_guestlistReviewStatusLabel, text) = RACObserve(self, guestlistReviewStatusTitle);
    
    RACSignal *imageURLSignal = [RACObserve(self, headerViewImage) filter:^BOOL(NSURL *url) {
        return url.isValid;
    }];
    
    [imageURLSignal subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];

}



#pragma mark - constructors
//-------------------------------------

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"Back Button"] forState:UIControlStateNormal];
    return button;
}

- (UIButton *)newMenuButton {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"Menu Icon"] forState:UIControlStateNormal];
    return button;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView dimView];
    return imageView;
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUINavBarTitle);
//    label.text = _title;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    //    label.text = _title;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentLeft;
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

//-------------------------------------

- (void)compressView {
    [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(75);
    }];
    
    [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.equalTo(SCREEN_WIDTH*0.80);
    }];
    
    [_dismissButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_dateLabel setHidden:YES];
    [_statusView setHidden:YES];
    [_guestlistReviewStatusLabel setHidden:YES];
}

- (void)uncompressView {
    WEAKSELF();
    [_imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(150);
    }];
    
    [_dismissButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.dismissButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsLow());
        
    }];
    
    [_dateLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.titleLabel.mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsLow());
    }];
    
    [_statusView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo([WSELF guestlistReviewStatusLabel].mas_height);
        make.width.mas_equalTo([WSELF statusView].mas_height);
        make.centerY.equalTo([WSELF guestlistReviewStatusLabel].mas_centerY);
    }];
    
    [_guestlistReviewStatusLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF dateLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.equalTo([WSELF statusView].mas_right);
        make.right.insets(kTHLEdgeInsetsLow());
    }];
    
    [_dateLabel setHidden:NO];
    [_statusView setHidden:NO];
    [_guestlistReviewStatusLabel setHidden:NO];
}

@end
