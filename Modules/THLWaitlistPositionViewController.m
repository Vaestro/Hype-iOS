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

@property (nonatomic, strong) UILabel *positionLabel;
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
	_positionLabel = [self newPositionLabel];
}

- (void)layoutView {
	[self.view addSubviews:@[_logoImageView,
							 _positionLabel]];

	[_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
		make.centerX.mas_equalTo(0);
		make.top.insets(UIEdgeInsetsMake1(70));
	}];

	[_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsHigh());
		make.centerY.mas_equalTo(0);
	}];
}

#pragma mark - Interface
- (void)displayPosition:(NSInteger)position {
	[_positionLabel setText:[NSString stringWithFormat:@"You are currently in position %lu", position]];
}

#pragma mark - Constructors
- (UIImageView *)newLogoImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	return imageView;
}

- (UILabel *)newPositionLabel {
	UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
	label.numberOfLines = 0;
	return label;
}
@end
