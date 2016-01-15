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
#import "LRTextField.h"

static const CGFloat kSubmitButtonHeight = 58.0f;

@interface THLWaitlistCodeEntryViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
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
    self.codeLength = 6;
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
    self.navigationItem.title = @"Use Invite Code";
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
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Welcome";
    return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Enter your invtite code to get in";
    label.numberOfLines = 0;
    return label;
}

- (LRTextField *)newTextField {
    LRTextField *codeField = [[LRTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:LRTextFieldStyleNone];
    [codeField setPlaceholder:@"Code"];
    codeField.placeholderActiveColor = kTHLNUIAccentColor;
    codeField.placeholderInactiveColor = kTHLNUIGrayFontColor;
    codeField.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    codeField.delegate = self;
    [codeField setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:0];
        if (text.length != _codeLength) {
            return @{ VALIDATION_INDICATOR_NO : [NSString stringWithFormat:@"Code must be %ld digits", _codeLength] };
//            return @{ VALIDATION_INDICATOR_YES : @"Correct" };
        }
        return nil;
    }];
    return codeField;
}

- (THLActionBarButton *)newSubmitButton {
	THLActionBarButton *button = [THLActionBarButton new];
	[button setTitle:@"Submit" forState:UIControlStateNormal];
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
