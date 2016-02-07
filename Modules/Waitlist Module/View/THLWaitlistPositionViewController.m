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


static const CGFloat kLogoImageSize = 50.0f;
@interface THLWaitlistPositionViewController ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UILabel *descriptionLabel;
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
    _backgroundView = [self newBackgroundView];
    _titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
	_positionLabel = [self newPositionLabel];
    _subtitleLabel = [self newSubtitleLabel];
}

- (void)layoutView {
	[self.view addSubviews:@[_backgroundView,
                             _titleLabel,
                             _descriptionLabel,
                             _logoImageView,
							 _positionLabel,
                             _subtitleLabel]];

    WEAKSELF();
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(UIEdgeInsetsZero);
    }];
    
	[_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
	}];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF positionLabel].mas_top).insets(kTHLEdgeInsetsHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];
    
	[_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF subtitleLabel].mas_top).insets(kTHLEdgeInsetsHigh());
	}];
    
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo(kTHLEdgeInsetsInsanelyHigh());
    }];
}

#pragma mark - Interface
- (void)displayPosition:(NSInteger)position {
	[_positionLabel setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:position]]];
    [_positionLabel setFont:[UIFont systemFontOfSize:72]];
    [_positionLabel setTextColor:kTHLNUIAccentColor];
}

#pragma mark - Constructors
- (UIImageView *)newBackgroundView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"WaitlistPositionBG"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}


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
    label.text = @"Waitlist";
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"You're on your way to the party";
    label.numberOfLines = 0;
    label.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
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
