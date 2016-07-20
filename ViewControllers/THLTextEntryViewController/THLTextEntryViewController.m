//
//  THLTextEntryViewController.m
//  Hype
//
//  Created by Edgar Li on 3/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTextEntryViewController.h"
#import "IHKeyboardAvoiding.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import "THLSingleLineTextField.h"
#import "NSString+EmailAddresses.h"

@interface THLTextEntryViewController()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) THLSingleLineTextField *textField;
@property (nonatomic, strong) THLActionButton *submitButton;

@end

@implementation THLTextEntryViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
//    [self bindView];
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
    switch (self.type) {
        case THLTextEntryTypeEmail: {
            _textField = [self newEmailField];
            break;
        }
        case THLTextEntryTypeCode: {
            _textField = [self newCodeField];
            break;
        }
        case THLTextEntryTypeRedeemCode: {
            _textField = [self newRedeemCodeField];
            break;
        }
    }
    _submitButton = [self newSubmitButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    _containerView = [UIView new];
//    TODO: Keyboard avoiding doesnt work on re-opening
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
        make.bottom.equalTo(WSELF.submitButton.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_containerView addSubviews:@[_titleLabel, _descriptionLabel, _textField]];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(WSELF.descriptionLabel.mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo([WSELF textField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(SCREEN_WIDTH*0.80);
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

//- (void)bindView {
//    WEAKSELF();
//    RAC(self.titleLabel, text, @"") = RACObserve(self, titleText);
//    RAC(self.descriptionLabel, text, @"") = RACObserve(self, descriptionText);
//    [RACObserve(self, buttonText) subscribeNext:^(id x) {
//        [self.submitButton setTitle:_buttonText];
//    }];
//    
//    switch (self.type) {
//        case THLTextEntryTypeEmail: {
//            _submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validEmailSignal] signalBlock:^RACSignal *(id input) {
//                [WSELF.delegate emailEntryView:WSELF userDidSubmitEmail:WSELF.textField.text];
//                return [RACSignal empty];
//            }];
//            break;
//        }
//        case THLTextEntryTypeCode: {
//            _submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validInputSignal] signalBlock:^RACSignal *(id input) {
//                [WSELF submitTextForValidation];
//                return [RACSignal empty];
//            }];
//            break;
//        }
//        case THLTextEntryTypeRedeemCode: {
//            _submitButton.rac_command = [[RACCommand alloc] initWithEnabled:[self validInputSignal] signalBlock:^RACSignal *(id input) {
//                [WSELF.delegate codeEntryView:WSELF userDidSubmitRedemptionCode:_textField.text];
//                return [RACSignal empty];
//            }];
//            break;
//        }
//    }
//}
//
//- (RACSignal *)validEmailSignal {
//    return [_textField.rac_textSignal map:^id(NSString *input) {
//        return @([input isValidEmailAddress]);
//    }];
//}
//
//- (RACSignal *)validInputSignal {
//    WEAKSELF();
//    return [_textField.rac_textSignal map:^id(NSString *input) {
//        return @(input.length == WSELF.textLength);
//    }];
//}

- (void)submitTextForValidation {
    [_delegate codeEntryView:self userDidSubmitCode:_textField.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.type == THLTextEntryTypeCode) {
        return string.length <= _textLength && [string isEqualToString:[string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]];
    }
    return TRUE;
}

#pragma mark - Constructors
- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.numberOfLines = 0;
    label.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
    return label;
}

- (THLSingleLineTextField *)newCodeField {
    THLSingleLineTextField *codeField = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleNone];
    [codeField setPlaceholder:@"Code"];
    codeField.delegate = self;
    WEAKSELF();
    [codeField setValidationBlock:^NSDictionary *(THLSingleLineTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:0];
        if (text.length != WSELF.textLength) {
            return @{ VALIDATION_INDICATOR_NO : [NSString stringWithFormat:@"Code must be %@ digits", [NSNumber numberWithInteger:WSELF.textLength]]};
            //            return @{ VALIDATION_INDICATOR_YES : @"Correct" };
        }
        return nil;
    }];
    return codeField;
}

- (THLSingleLineTextField *)newEmailField {
    THLSingleLineTextField *textFieldEmail = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleEmail];
    textFieldEmail.delegate = self;
    return textFieldEmail;
}

- (THLSingleLineTextField *)newRedeemCodeField {
    THLSingleLineTextField *codeField = [[THLSingleLineTextField alloc] initWithFrame:CGRectMake(20, 70, 260, 30) labelHeight:15 style:THLSingleLineTextFieldStyleNone];
    [codeField setPlaceholder:@"Code"];
    codeField.delegate = self;
    return codeField;
}



- (THLActionButton *)newSubmitButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    return button;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
