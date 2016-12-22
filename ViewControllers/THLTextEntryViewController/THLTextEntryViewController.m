//
//  THLTextEntryViewController.m
//  Hype
//
//  Created by Edgar Li on 3/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTextEntryViewController.h"
@import IHKeyboardAvoiding;
#import "THLAppearanceConstants.h"
#import "THLSingleLineTextField.h"
#import "NSString+EmailAddresses.h"

@interface THLTextEntryViewController()
<
UITextFieldDelegate
>
@property (nonatomic, assign) THLTextEntryType type;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) THLSingleLineTextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) THLActionButton *submitButton;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *buttonText;
 
@end

@implementation THLTextEntryViewController

- (instancetype)initWithType:(THLTextEntryType)type title:(NSString *)titleText description:(NSString *)descriptionText buttonText:(NSString *)buttonText {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    self.type = type;
    self.titleText = titleText;
    self.descriptionText = descriptionText;
    self.buttonText = buttonText;
    
    return self;
}

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;


    WEAKSELF();
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(WSELF.submitButton.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(WSELF.descriptionLabel.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF textField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.80);
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)handleEmailEntry {
    if ([self.textField.text isValidEmailAddress]) {
        [self.delegate emailEntryView:self userDidSubmitEmail:self.textField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid email address"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)handleCodeEntry {
    if (self.textField.text.length > 0) {
        [self.delegate codeEntryView:self userDidSubmitRedemptionCode:_textField.text];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid code"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

#pragma mark - Constructors
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        //    TODO: Keyboard avoiding doesnt work on re-opening
        [KeyboardAvoiding setAvoidingView:_containerView];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIRegularTitle);
        _titleLabel.text = _titleText;
        [self.containerView addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = _descriptionText;

        _descriptionLabel.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
        [self.containerView addSubview:_descriptionLabel];
    }

    return _descriptionLabel;
}

- (THLSingleLineTextField *)textField {
    if (!_textField) {
        switch (self.type) {
            case THLTextEntryTypeEmail: {
                _textField = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleEmail];
                break;
            }
            case THLTextEntryTypeRedeemCode: {
                _textField = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleNone];
                [_textField setPlaceholder:@"Code"];
                break;
            }
        }
        _textField.delegate = self;
        [self.containerView addSubview:_textField];
    }
    return _textField;
}

- (THLActionButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[THLActionButton alloc] initWithInverseStyle];
        [_submitButton setTitle:self.buttonText];
        switch (self.type) {
            case THLTextEntryTypeEmail: {
                [_submitButton addTarget:self action:@selector(handleEmailEntry) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case THLTextEntryTypeRedeemCode: {
                [_submitButton addTarget:self action:@selector(handleCodeEntry) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
        }
        [self.view addSubview:_submitButton];
    }
    return _submitButton;
}

@end
