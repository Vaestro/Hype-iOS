//
//  THLLoginViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginViewController.h"
#import "THLAppearanceConstants.h"
@interface THLLoginViewController()
@property (nonatomic, strong) UIButton *loginButton;
@end

@implementation THLLoginViewController
@synthesize loginCommand;
@synthesize loginText;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self constructView];
	[self layoutView];
	[self bindView];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
	_loginButton = [self newLoginButton];
}

- (void)layoutView {
	self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubviews:@[_loginButton]];
	[_loginButton makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
		make.height.equalTo(40);
	}];
}

- (void)bindView {
	RAC(self.loginButton, rac_command) = RACObserve(self, loginCommand);
	RAC(self.loginButton, titleLabel.text) = RACObserve(self, loginText);
}

#pragma mark - Constructors
- (UIButton *)newLoginButton {
	UIButton *button = THLNUIButton(kTHLNUIUndef);
	return button;
}
@end
