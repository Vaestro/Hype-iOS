//
//  THLWaitlistPositionViewController.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistPositionViewController.h"
#import "THLAppearanceConstants.h"
#import "THLAppearanceUtils.h"


static const CGFloat kLogoImageSize = 75.0f;
@interface THLWaitlistPositionViewController ()
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation THLWaitlistPositionViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	[self constructView];
	[self layoutView];
}

- (void)constructView {
	_logoImageView = [self newLogoImageView];
    _titleLabel = [self newTitleLabel];
	_positionLabel = [self newPositionLabel];
    _subtitleLabel = [self newSubtitleLabel];
}

- (void)layoutView {
	[self.view addSubviews:@[_titleLabel,
                             _logoImageView,
							 _positionLabel,
                             _subtitleLabel]];

    WEAKSELF();
	[_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
		make.centerX.mas_equalTo(0);
		make.top.insets(UIEdgeInsetsMake1(70));
	}];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo([WSELF positionLabel].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
    
	[_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsHigh());
		make.center.mas_equalTo(0);
	}];
    
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF positionLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Interface
- (void)displayPosition:(NSInteger)position {
	[_positionLabel setText:[NSString stringWithFormat:@"%lu", position]];
    [_positionLabel setFont:[UIFont systemFontOfSize:72]];
    [_positionLabel setTextColor:kTHLNUIAccentColor];
}

#pragma mark - Constructors
- (UIImageView *)newLogoImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	return imageView;
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.numberOfLines = 0;
    label.text = @"You're on your way to the party";
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newPositionLabel {
	UILabel *label = THLNUILabel(kTHLNUIBoldTitle);

    label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 0;
	return label;
}

- (UILabel *)newSubtitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.numberOfLines = 0;
    label.text = @"People in front of you";
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
