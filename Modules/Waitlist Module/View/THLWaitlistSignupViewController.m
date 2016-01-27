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
#import "LRTextField.h"

@interface THLWaitlistSignupViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) LRTextField *textField;
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
    _dismissButton = [self newDismissButton];
	_titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
	_textField = [self newTextField];
	[IHKeyboardAvoiding setAvoidingView:_textField];
	_submitButton = [self newSubmitButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = @"Waitlist signup";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kTHLNUIPrimaryFontColor,
       NSFontAttributeName:[UIFont fontWithName:@"Raleway-Regular" size:21]}];
    
	[self.view addSubviews:@[_titleLabel,
                             _descriptionLabel,
							 _textField,
							 _submitButton]];
    
    WEAKSELF();
	[_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.left.right.insets(kTHLEdgeInsetsNone());
		make.height.mas_equalTo(kSubmitButtonHeight);
	}];

	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.top.insets(UIEdgeInsetsMake1(70));
	}];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo([WSELF titleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];

	[_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.80);
		make.center.mas_equalTo(0);
	}];
}

- (void)bindView {
    _dismissButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismissViewControllerAnimated:NO completion:NULL];
        return [RACSignal empty];
    }];
    
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
- (UILabel *)newTitleLabel {
	UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Join the waitlist";
	return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Please enter your email address to request early access";
    label.numberOfLines = 0;
    return label;
}

- (LRTextField *)newTextField {
    LRTextField *textFieldEmail = [[LRTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:LRTextFieldStyleEmail];
    textFieldEmail.placeholderActiveColor = kTHLNUIAccentColor;
    textFieldEmail.placeholderInactiveColor = kTHLNUIGrayFontColor;
    textFieldEmail.backgroundColor = kTHLNUIPrimaryBackgroundColor;
	textFieldEmail.delegate = self;
	return textFieldEmail;
}

- (THLActionBarButton *)newSubmitButton {
	THLActionBarButton *button = [THLActionBarButton new];
	[button setTitle:@"Request Invitation" forState:UIControlStateNormal];
	return button;
}

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

@end
