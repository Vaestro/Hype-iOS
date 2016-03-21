//
//  THLWaitlistCodeEntryViewController.m
//  Hype
//
//  Created by Edgar Li on 12/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistCodeEntryViewController.h"
#import "IHKeyboardAvoiding.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import "THLSingleLineTextField.h"

@interface THLWaitlistCodeEntryViewController ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) THLSingleLineTextField *textField;
@property (nonatomic, strong) THLActionButton *submitButton;

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
    _titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
	_textField = [self newTextField];
	_submitButton = [self newSubmitButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    _containerView = [UIView new];
    [IHKeyboardAvoiding setAvoidingView:_containerView];
    [self.view addSubviews:@[_containerView,
                             _submitButton]];
    WEAKSELF();
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF submitButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];

    [_containerView addSubviews:@[_titleLabel, _descriptionLabel, _textField]];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF textField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.80);
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
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
    label.text = @"Enter your invite code to get in";
    label.numberOfLines = 0;
    label.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
    return label;
}

- (THLSingleLineTextField *)newTextField {
    THLSingleLineTextField *codeField = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleNone];
    [codeField setPlaceholder:@"Code"];
    codeField.delegate = self;
    [codeField setValidationBlock:^NSDictionary *(THLSingleLineTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:0];
        if (text.length != _codeLength) {
            return @{ VALIDATION_INDICATOR_NO : [NSString stringWithFormat:@"Code must be %@ digits", [NSNumber numberWithInteger:_codeLength]]};
//            return @{ VALIDATION_INDICATOR_YES : @"Correct" };
        }
        return nil;
    }];
    return codeField;
}

- (THLActionButton *)newSubmitButton {
	THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
	[button setTitle:@"Submit Code"];
	return button;
}

@end
