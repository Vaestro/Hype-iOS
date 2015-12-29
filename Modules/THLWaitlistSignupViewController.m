//
//  THLWaitlistSignupViewController.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistSignupViewController.h"
#import "THLActionBarButton.h"
#import "ReactiveCocoa.h"
#import "THLAppearanceConstants.h"
#import "NSString+EmailAddresses.h"
#import "IHKeyboardAvoiding.h"

static const CGFloat kSubmitButtonHeight = 58.0f;
static const CGFloat kLogoImageSize = 75.0f;

@interface THLWaitlistSignupViewController ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) THLActionBarButton *submitButton;

@end

@implementation THLWaitlistSignupViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
	_logoImageView = [self newLogoImageView];
	_textField = [self newTextField];
	[IHKeyboardAvoiding setAvoidingView:_textField];
	_submitButton = [self newSubmitButton];
}

- (void)layoutView {
	[self.view addSubviews:@[_logoImageView,
							 _textField,
							 _submitButton]];

	[_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.insets(kTHLEdgeInsetsNone());
		make.height.mas_equalTo(kSubmitButtonHeight);
	}];

	[_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
		make.centerX.mas_equalTo(0);
		make.top.insets(UIEdgeInsetsMake1(70));
	}];

	[_textField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(UIEdgeInsetsMake1(45));
		make.centerX.mas_equalTo(0);
		make.bottom.equalTo(_submitButton.mas_top).insets(UIEdgeInsetsMake1(163));
	}];
}

- (void)bindView {
	_submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validEmailSignal] signalBlock:^RACSignal *(id input) {
		[_delegate signupView:self userDidSubmitEmail:_textField.text];
		return [RACSignal empty];
	}];
}

- (RACSignal *)validEmailSignal {
	return [_textField.rac_textSignal map:^id(NSString *input) {
		return @([input isValidEmailAddress]);
	}];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:YES];
	return NO;
}

#pragma mark - Constructors
- (UIImageView *)newLogoImageView {
	UIImageView *imageView = [UIImageView new];
	imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	return imageView;
}

- (UITextField *)newTextField {
	UITextField *textField = [UITextField new];
	[textField setPlaceholder:@"Enter your email"];
	[textField setTextColor:[UIColor whiteColor]];
	[textField setBackgroundColor:[UIColor greenColor]];
	textField.delegate = self;
	return textField;
}

- (THLActionBarButton *)newSubmitButton {
	THLActionBarButton *button = [THLActionBarButton new];
	[button setTitle:@"Submit" forState:UIControlStateNormal];
	return button;
}

@end
