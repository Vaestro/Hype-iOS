//
//  THLSignUpViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLSignUpViewController.h"
#import "THLLoginService.h"

#import "THLAppearanceConstants.h"
#import "SVProgressHUD.h"
#import "THLResourceManager.h"
#import "THLActionButton.h"
#import "TTTAttributedLabel.h"
#import "THLInformationViewController.h"
#import "THLUser.h"
#import "THLTextEntryViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"
#import "THLPermissionRequestViewController.h"
#import "JVFloatLabeledTextField.h"

#import "NSString+EmailAddresses.h"

@interface THLSignUpViewController()
<
THLLoginServiceDelegate,
THLTextEntryViewDelegate,
THLPermissionRequestViewControllerDelegate,
TTTAttributedLabelDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) THLLoginService *loginService;

@property (nonatomic, strong) JVFloatLabeledTextField *fullNameField;
@property (nonatomic, strong) JVFloatLabeledTextField *emailField;
@property (nonatomic, strong) JVFloatLabeledTextField *passwordField;

@property (nonatomic, strong) UILabel *genderRadioButtonLabel;
@property (nonatomic, strong) UIButton *maleRadioButton;
@property (nonatomic, strong) UIButton *maleTextButton;

@property (nonatomic, strong) UIButton *femaleRadioButton;
@property (nonatomic, strong) UIButton *femaleTextButton;

@property (nonatomic, strong) THLActionButton *submitButton;

@end

@implementation THLSignUpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.loginService = [THLLoginService new];
    self.loginService.delegate = self;
    
    WEAKSELF();
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(kTHLEdgeInsetsSuperHigh());
        make.size.mas_equalTo(CGSizeMake1(25.0f));

    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(75);
        make.centerX.equalTo(0);
        make.size.mas_equalTo(CGSizeMake1(50.0f));
    }];
    
//    [self.bodyLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(0);
//        make.top.equalTo([WSELF logoImageView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//        make.width.equalTo(SCREEN_WIDTH*0.67);
//    }];
    
    [self.fullNameField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF maleRadioButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.genderRadioButtonLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.maleRadioButton);
        make.left.equalTo(WSELF.fullNameField).insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.maleRadioButton makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(15);
        make.height.equalTo(WSELF.maleRadioButton.mas_width);
        make.bottom.equalTo([WSELF emailField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo(WSELF.genderRadioButtonLabel.mas_right).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.maleTextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.maleRadioButton);
        make.left.equalTo(WSELF.maleRadioButton.mas_right).insets(kTHLEdgeInsetsLow());
    }];
    
    [self.femaleRadioButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.maleRadioButton);
        make.width.equalTo(15);
        make.height.equalTo(WSELF.femaleRadioButton.mas_width);
        make.left.equalTo(WSELF.maleTextButton.mas_right).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.femaleTextButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.femaleRadioButton);
        make.left.equalTo(WSELF.femaleRadioButton.mas_right).insets(kTHLEdgeInsetsLow());
    }];
    
    [self.emailField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF passwordField].mas_top).insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF submitButton].mas_top).insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.submitButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-35);
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
}


- (void)handleSubmit {
    NSString *fullName = self.fullNameField.text;
    NSString *firstName = [[fullName componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString *lastName = [fullName substringFromIndex:[fullName rangeOfString:firstName].length + 1];
    THLSex sex;
    if (_maleRadioButton.selected) {
        sex = THLSexMale;
    } else {
        sex = THLSexFemale;
    }
    
    [_loginService signUpWithEmail:_emailField.text password:_passwordField.text firstName:firstName lastName:lastName sex:sex];
}

- (void)handleDismiss {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - THLLoginServiceDelegate


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self validateFields];
}

- (void)validateFields {
    if ([_emailField.text isValidEmailAddress] && _passwordField.text.length > 6 && [self checkValidFullName:_fullNameField.text] && [self checkGenderSelected]) {
        _submitButton.enabled = true;
        _submitButton.backgroundColor = kTHLNUIAccentColor;
    } else {
        _submitButton.enabled = false;
        _submitButton.backgroundColor = [UIColor clearColor];
    }
}

- (BOOL)checkValidFullName:(NSString *)nameText {
//    NSString *nameRegex = @"^[A-Za-z]+(?:\\s[A-Za-z]+)*$";
//    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
//    bool isCheckStringValid = [nameTest evaluateWithObject:nameText];
//    return isCheckStringValid;
    
//    Check for white space between text
    NSString *trimmedString = [nameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange whiteSpaceRange = [trimmedString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    return (whiteSpaceRange.location != NSNotFound);
}

- (BOOL)checkGenderSelected {
    return (_femaleRadioButton.selected || _maleRadioButton.selected);
}

- (void)maleRadioButtonToggle:(id)sender {
    _maleRadioButton.selected = true;
    _femaleRadioButton.selected = false;
    [self validateFields];
}

- (void)femaleRadioButtonToggle:(id)sender {
    _femaleRadioButton.selected = true;
    _maleRadioButton.selected = false;
    [self validateFields];
}

#pragma mark - Accessors
- (JVFloatLabeledTextField *)fullNameField {
    if (!_fullNameField) {
        _fullNameField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        [_fullNameField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: kTHLNUIGrayFontColor}]];
        _fullNameField.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.10];
        _fullNameField.delegate = self;
        _fullNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:_fullNameField];
    }
    
    return _fullNameField;
}

- (UILabel *)genderRadioButtonLabel {
    if (!_genderRadioButtonLabel) {
        _genderRadioButtonLabel = [UILabel new];
        _genderRadioButtonLabel.text = @"Gender";
        _genderRadioButtonLabel.textColor = kTHLNUIGrayFontColor;
        _genderRadioButtonLabel.font = [UIFont systemFontOfSize:14.0f];
        _genderRadioButtonLabel.numberOfLines = 1;
        _genderRadioButtonLabel.adjustsFontSizeToFitWidth = YES;
        _genderRadioButtonLabel.minimumScaleFactor = 0.5;
        _genderRadioButtonLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_genderRadioButtonLabel];
    }
    return _genderRadioButtonLabel;
}

- (UIButton *)maleRadioButton
{
    if (!_maleRadioButton) {
        _maleRadioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maleRadioButton setImage:[UIImage imageNamed:@"unchecked_box"] forState:UIControlStateNormal];
        [_maleRadioButton setImage:[UIImage imageNamed:@"checked_box"] forState:UIControlStateSelected];
        [_maleRadioButton addTarget:self
                             action:@selector(maleRadioButtonToggle:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_maleRadioButton];

    }
    
    return _maleRadioButton;
}

- (UIButton *)maleTextButton
{
    if (!_maleTextButton) {
        _maleTextButton = [UIButton new];
        [_maleTextButton setTitle:@"Male" forState:UIControlStateNormal];
        _maleTextButton.titleLabel.font = [UIFont fontWithName:_maleTextButton.titleLabel.font.fontName size:_maleTextButton.titleLabel.font.pointSize * 0.7f];
        [_maleTextButton setTitleColor:kTHLNUIGrayFontColor];
        [_maleTextButton addTarget:self
                             action:@selector(maleRadioButtonToggle:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_maleTextButton];
        
    }
    
    return _maleTextButton;
}

- (UIButton *)femaleRadioButton
{
    if (!_femaleRadioButton) {
        _femaleRadioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_femaleRadioButton setImage:[UIImage imageNamed:@"unchecked_box"] forState:UIControlStateNormal];
        [_femaleRadioButton setImage:[UIImage imageNamed:@"checked_box"] forState:UIControlStateSelected];
        [_femaleRadioButton addTarget:self
                             action:@selector(femaleRadioButtonToggle:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_femaleRadioButton];

    }
    
    return _femaleRadioButton;
}

- (UIButton *)femaleTextButton
{
    if (!_femaleTextButton) {
        _femaleTextButton = [UIButton new];
        [_femaleTextButton setTitle:@"Female" forState:UIControlStateNormal];
        _femaleTextButton.titleLabel.font = [UIFont fontWithName:_femaleTextButton.titleLabel.font.fontName size:_femaleTextButton.titleLabel.font.pointSize * 0.7f];
        [_femaleTextButton setTitleColor:kTHLNUIGrayFontColor];
        [_femaleTextButton addTarget:self
                             action:@selector(femaleRadioButtonToggle:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_femaleTextButton];
        
    }
    
    return _femaleTextButton;
}

- (JVFloatLabeledTextField *)emailField {
    if (!_emailField) {
        _emailField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        [_emailField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: kTHLNUIGrayFontColor}]];
        _emailField.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.10];
        _emailField.delegate = self;
        _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:_emailField];
    }
    
    return _emailField;
}

- (JVFloatLabeledTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        [_passwordField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: kTHLNUIGrayFontColor}]];
        _passwordField.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.10];
        _passwordField.delegate = self;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self.view addSubview:_passwordField];
        
    }
    return _passwordField;
}

- (UILabel *)bodyLabel {
    if (!_bodyLabel) {
        _bodyLabel = [UILabel new];
        _bodyLabel.text = @"Welcome back. It's good seeing you again";
        _bodyLabel.textColor = kTHLNUIGrayFontColor;
        _bodyLabel.font = [UIFont fontWithName:@"Raleway-Light" size:18];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.adjustsFontSizeToFitWidth = YES;
        _bodyLabel.minimumScaleFactor = 0.5;
        _bodyLabel.textAlignment = NSTextAlignmentCenter;
        [_bodyLabel sizeToFit];
        [self.view addSubview:_bodyLabel];
    }
    return _bodyLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
        [self.view addSubview:_logoImageView];
    }
    
    return _logoImageView;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
//        _dismissButton = [[UIButton alloc] initWithImage:[UIImage imageNamed:@"back_button"] target:self action:@selector(handleDismiss)];
        _dismissButton = [UIButton new];
        UIImage *btnImage = [UIImage imageNamed:@"back_button"];
        [_dismissButton setImage:btnImage forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(handleDismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dismissButton];
    }
    
    return _dismissButton;
}

- (THLActionButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[THLActionButton alloc] initWithInverseStyle];
        [_submitButton setTitle:@"Continue"];
        _submitButton.enabled = false;
        [_submitButton addTarget:self action:@selector(handleSubmit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitButton];
    }
    return _submitButton;
}

@end