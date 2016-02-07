//
//  THLInfoVerificationViewController.m
//  Hype
//
//  Created by Edgar Li on 1/18/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLUserInfoVerificationViewController.h"
#import "THLActionButton.h"
#import "ReactiveCocoa.h"
#import "THLAppearanceConstants.h"
#import "NSString+EmailAddresses.h"
#import "IHKeyboardAvoiding.h"
#import "THLSingleLineTextField.h"

static const CGFloat kSubmitButtonHeight = 58.0f;

@interface THLUserInfoVerificationViewController()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) THLSingleLineTextField *textField;
@property (nonatomic, strong) THLActionButton *submitButton;

@end

@implementation THLUserInfoVerificationViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
    _textField = [self newTextField];
    [IHKeyboardAvoiding setAvoidingView:_textField];
    _submitButton = [self newSubmitButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubviews:@[_titleLabel,
                             _descriptionLabel,
                             _textField,
                             _submitButton]];
    
    WEAKSELF();
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF textField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.66);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.80);
        make.bottom.equalTo([WSELF submitButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
}

- (void)bindView {
    _submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validEmailSignal] signalBlock:^RACSignal *(id input) {
        [_delegate userInfoVerificationView:self userDidConfirmEmail:_textField.text];
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
    label.text = @"Confirm Info";
    return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"We use your email and phone number to send you confirmations and receipts";
    label.numberOfLines = 0;
    return label;
}

- (THLSingleLineTextField *)newTextField {
    THLSingleLineTextField *textFieldEmail = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleEmail];
    textFieldEmail.delegate = self;
    return textFieldEmail;
}

- (THLActionButton *)newSubmitButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"Verify Phone Number"];
    return button;
}

@end