//
//  THLWaitlistCodeEntryViewController.m
//  Hype
//
//  Created by Phil Meyers IV on 12/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistCodeEntryViewController.h"
#import "IHKeyboardAvoiding.h"
#import "THLActionBarButton.h"
#import "ReactiveCocoa.h"
#import "THLAppearanceConstants.h"
#import "THLWaitlistEntry.h"

static const CGFloat kSubmitButtonHeight = 58.0f;
static const CGFloat kLogoImageSize = 75.0f;

@interface THLWaitlistCodeEntryViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) THLActionBarButton *submitButton;

@end

@implementation THLWaitlistCodeEntryViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	[self constructView];
	[self layoutView];
	[self bindView];
}

- (void)constructView {
    _dismissButton = [self newDismissButton];
	_logoImageView = [self newLogoImageView];
	_textField = [self newTextField];
	[IHKeyboardAvoiding setAvoidingView:_textField];
	_submitButton = [self newSubmitButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = @"Use Invite Code";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kTHLNUIPrimaryFontColor,
       NSFontAttributeName:[UIFont fontWithName:@"Raleway-Regular" size:21]}];
    
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
    _dismissButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismissViewControllerAnimated:NO completion:NULL];
        return [RACSignal empty];
    }];
    
	_submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validInputSignal] signalBlock:^RACSignal *(id input) {
		[self submitCodeForValidation];
		return [RACSignal empty];
	}];
}

- (RACSignal *)validInputSignal {
	return [_textField.rac_textSignal map:^id(NSString *input) {
		return @(input.length == _codeLength);
	}];
}

- (void)submitCodeForValidation {
	[_delegate view:self didRecieveCode:_textField.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:YES];
	return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return string.length <= _codeLength && [string isEqualToString:[string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]];
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
	[textField setPlaceholder:@"Enter your code"];
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

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel X Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}


@end
