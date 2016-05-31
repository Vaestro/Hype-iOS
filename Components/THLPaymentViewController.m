//
//  THLPaymentViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 4/29/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPaymentViewController.h"
#import "THLAppearanceConstants.h"
#import "THLActionButton.h"
#import "Stripe.h"
#import "Parse.h"
#import "THLUser.h"
#import "MBProgressHUD.h"

@interface THLPaymentViewController()<STPPaymentCardTextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cardInfoLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *securitySymbol;
@property (nonatomic, strong) UIImageView *paymentCardIcon;

@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@property(nonatomic, strong) THLActionButton *addCardButton;
@property(nonatomic, strong) THLActionButton *removeCardButton;

@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) NSArray<NSDictionary *> *paymentInfo;
@end

@implementation THLPaymentViewController

- (id)initWithPaymentInfo:(NSArray<NSDictionary *> *)paymentInfo
{
    if (self = [super init]) {
        if (paymentInfo.count != 0) _paymentInfo = paymentInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.paymentTextField = [STPPaymentCardTextField new];
    self.paymentTextField.textColor = [UIColor whiteColor];
    self.paymentTextField.delegate = self;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_paymentInfo) {
        self.titleLabel.text = @"Payment";
        NSString *last4CardDigits = _paymentInfo[0][@"last4"];
        NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
        _cardInfoLabel = [self cardInfoLabel:cardInfoText];
//        [self.view addSubviews:@[_paymentCardIcon, _cardInfoLabel, _removeCardButton]];
        
    } else {
//        [self.view addSubviews:@[_paymentTextField, _addCardButton]];
    }
    
    WEAKSELF();
    if (_paymentInfo) {
        [self.removeCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF cardInfoLabel].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        }];
        
        [self.paymentCardIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF removeCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.cardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(_paymentCardIcon.mas_right).insets(kTHLEdgeInsetsHigh());
            make.bottom.equalTo(_paymentCardIcon);
        }];
    } else {
        [self.addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF paymentTextField].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        }];
        
        [self.paymentTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF addCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
    }
    
    [self.securitySymbol mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.centerY.equalTo([WSELF descriptionLabel]);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF securitySymbol].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
        
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
    }];

}


- (void)updateLayoutForAddPayment {
    [_removeCardButton removeFromSuperview];
    [_paymentCardIcon removeFromSuperview];
    [_cardInfoLabel removeFromSuperview];
    _titleLabel.text = @"Add Payment";

    WEAKSELF();

    [_addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF paymentTextField].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
    }];
    
    [_paymentTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF addCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
}


- (void)updateLayoutForHasPayment {
    NSString *last4CardDigits = _paymentInfo[0][@"last4"];
    NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
    _cardInfoLabel = [self cardInfoLabel:cardInfoText];
    
    [self.view addSubviews:@[_paymentCardIcon, _cardInfoLabel,_removeCardButton]];
    WEAKSELF();
    [_removeCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_paymentCardIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF removeCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_cardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_paymentCardIcon.mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(_paymentCardIcon);
    }];
    
    [_paymentTextField removeFromSuperview];
    [_addCardButton removeFromSuperview];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF cardInfoLabel].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
    }];
}


- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField
{
    self.addCardButton.enabled = textField.isValid;
}

#pragma mark - Payment Processing

- (void)saveCreditCardInfo
{
    self.hud.labelText = @"Updating...";
    [self.hud show:YES];
    [[STPAPIClient sharedClient]
     createTokenWithCard:self.paymentTextField.cardParams
     completion:^(STPToken *token, NSError *error) {
         if (error) {
             [self displayError:error];
         } else {
             
             [PFCloud callFunctionInBackground:@"createStripeCustomer"
                                withParameters:@{@"stripeToken": token.tokenId}
                                         block:^(NSArray<NSDictionary *> *paymentInfo, NSError *cloudError) {
                                             [self.hud hide:YES];
                                             if (cloudError) {
                                                 [self displayError:cloudError];
                                             } else {
                                                 _paymentInfo = paymentInfo;
                                                 [[THLUser currentUser] fetch];
                                                 [self displaySuccess];
                                                 [self updateLayoutForHasPayment];
                                             }
              }];
         }
     }];
}

- (void)deleteCreditCardInfo {
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [PFCloud callFunctionInBackground:@"removeCardInfo"
                                                                                 withParameters:@{@"cardId": _paymentInfo[0][@"id"],
                                                                                                  @"customerId": [THLUser currentUser].stripeCustomerId}
                                                            block:^(id  _Nullable object, NSError * _Nullable cloudError) {
                                                                if (cloudError) {
                                                                    [self displayError:cloudError];
                                                                } else {
                                                                    [self updateLayoutForAddPayment];
                                                                }
                                                          }];
                                                      }];
    
    NSString *message = NSStringWithFormat(@"Are you sure you want to remove your card info?");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, confirmAction, nil]];
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)displayError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)displaySuccess {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"Success")
                                                      message:@"Your credit card information has been successfully added"
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

#pragma mark - Accessors

- (THLActionButton *)addCardButton
{
    if (!_addCardButton) {
        _addCardButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_addCardButton setTitle:@"ADD CARD"];
        [_addCardButton addTarget:self action:@selector(saveCreditCardInfo) forControlEvents:UIControlEventTouchUpInside];
        _addCardButton.enabled = NO;
        [self.view addSubview:_addCardButton];
    }
    return _addCardButton;
}


- (THLActionButton *)removeCardButton
{
    if (!_removeCardButton) {
        _removeCardButton = [[THLActionButton alloc] initWithInverseStyle];
        [_removeCardButton setTitle:@"REMOVE CARD"];
        [_removeCardButton addTarget:self action:@selector(deleteCreditCardInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeCardButton];
    }

    return _removeCardButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIRegularTitle);
        _titleLabel.text = @"Add Payment";
        [self.view addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UILabel *)cardInfoLabel:(NSString *)info {
    if (!_cardInfoLabel) {
        _cardInfoLabel = THLNUILabel(kTHLNUIRegularTitle);
        _cardInfoLabel.text = info;
        [self.view addSubview:_cardInfoLabel];
    }
    return _cardInfoLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        [_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:10]];
        _descriptionLabel.text = @"Your card details are encrypted using SSL before transmission to our secure payment service provider and they will not be stored on this device or our servers.";
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        _descriptionLabel.numberOfLines = 4;
        _descriptionLabel.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
        [self.view addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (UIImageView *)securitySymbol {
    if (!_securitySymbol) {
        _securitySymbol = [UIImageView new];
        _securitySymbol.image = [UIImage imageNamed:@"security_symbol"];
        _securitySymbol.contentMode = UIViewContentModeScaleAspectFit;
        _securitySymbol.clipsToBounds = YES;
        [self.view addSubview:_securitySymbol];
    }

    return _securitySymbol;
}

- (UIImageView *)paymentCardIcon {
    if (!_paymentCardIcon) {
        _paymentCardIcon = [UIImageView new];
        _paymentCardIcon.image = [UIImage imageNamed:@"payment_card"];
        _paymentCardIcon.contentMode = UIViewContentModeScaleAspectFit;
        _paymentCardIcon.clipsToBounds = YES;
        [self.view addSubview:_paymentCardIcon];
    }

    return _paymentCardIcon;
}

@end

