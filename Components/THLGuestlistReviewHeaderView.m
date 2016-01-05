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


@interface THLGuestlistReviewHeaderView()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
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
}

- (void)layoutView {
    [self addSubviews:@[_dismissButton, _menuButton, _imageView, _titleLabel, _dateLabel]];
    
    [self sendSubviewToBack:_imageView];
    
    WEAKSELF();
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(125);
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
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.titleLabel.mas_bottom).insets(kTHLEdgeInsetsLow());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.titleLabel, text) = RACObserve(self, title);
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(self.menuButton, rac_command) = RACObserve(self, showMenuCommand);
    RAC(self.dateLabel, text) = RACObserve(self, formattedDate);
    
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
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
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
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    //    label.text = _title;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}



//-------------------------------------

- (void)compressView {
    WEAKSELF();
    [self.imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(75);
    }];
    
    [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(WSELF.dismissButton.mas_right).insets(kTHLEdgeInsetsHigh());
        make.centerY.offset(0);
        make.left.equalTo(WSELF.dismissButton.mas_right).insets(kTHLEdgeInsetsHigh());
        make.right.equalTo(WSELF.menuButton.mas_left).insets(kTHLEdgeInsetsLow());
        make.centerX.offset(0);
    }];
    
    [_dismissButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_dateLabel setHidden:YES];
}

- (void)uncompressView {
    WEAKSELF();
    [_imageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(125);
    }];
    
    [_titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.dismissButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_dismissButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_dateLabel setHidden:NO];
    
//    [_dateLabel remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(WSELF.titleLabel.mas_bottom).insets(kTHLEdgeInsetsLow());
//        make.left.insets(kTHLEdgeInsetsSuperHigh());
//    }];


}

@end
