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
        if (paymentInfo) _paymentInfo = paymentInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}

- (void)constructView
{
    self.paymentTextField = [STPPaymentCardTextField new];
    self.paymentTextField.textColor = [UIColor whiteColor];
    self.paymentTextField.delegate = self;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    _addCardButton = [self newAddCardButton];
    _removeCardButton = [self newRemoveCardButton];

    _titleLabel = [self newTitleLabel];
    _descriptionLabel = [self newDescriptionLabel];
    _securitySymbol = [self newSecuritySymbol];
    _paymentCardIcon = [self newPaymentCardIcon];
    NSString *last4CardDigits = _paymentInfo[0][@"last4"];
    NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
    _cardInfoLabel = [self newCardInfoLabel:cardInfoText];
    [self.view addSubviews:@[_titleLabel, _descriptionLabel, _hud, _securitySymbol]];
    if (_paymentInfo) {
        _titleLabel.text = @"Payment";
        [self.view addSubviews:@[_paymentCardIcon, _cardInfoLabel, _removeCardButton]];

    } else {
        [self.view addSubviews:@[_paymentTextField, _addCardButton]];
    }
}

- (void)layoutView
{
    WEAKSELF();

    

    
    if (_paymentInfo) {
        [_removeCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF cardInfoLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [_paymentCardIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF removeCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [_cardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(_paymentCardIcon.mas_right).insets(kTHLEdgeInsetsHigh());
            make.bottom.equalTo(_paymentCardIcon);
        }];
    } else {
        [_addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF paymentTextField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [_paymentTextField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo([WSELF addCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        }];
    }
        
    [_securitySymbol mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.centerY.equalTo([WSELF descriptionLabel]);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF securitySymbol].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());

        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
    }];
    

}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField
{
    self.addCardButton.enabled = textField.isValid;
}

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
                                                 [[THLUser currentUser] fetch];
                                                 [self displaySuccess];
                                                 NSString *last4CardDigits = paymentInfo[0][@"last4"];
                                                 NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
                                                 _cardInfoLabel = [self newCardInfoLabel:cardInfoText];

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
                                                     make.bottom.equalTo([WSELF cardInfoLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
                                                 }];
                                             }
              }];
         }
     }];
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

- (THLActionButton *)newAddCardButton
{
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"ADD CARD"];
    [button addTarget:self action:@selector(saveCreditCardInfo) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    return button;
}


- (THLActionButton *)newRemoveCardButton
{
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"REMOVE CARD"];
    [button addTarget:self action:@selector(saveCreditCardInfo) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    return button;
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Add Payment";
    return label;
}

- (UILabel *)newCardInfoLabel:(NSString *)info {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = info;
    return label;
}

- (UILabel *)newDescriptionLabel {
    UILabel *label = [UILabel new];
    [label setFont:[UIFont fontWithName:@"OpenSans-Regular" size:10]];
    label.text = @"Your card details are encrypted using SSL before transmission to our secure payment service provider and they will not be stored on this device or our servers.";
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 4;
    label.textColor = [kTHLNUIGrayFontColor colorWithAlphaComponent:0.5];
    return label;
}

- (UIImageView *)newSecuritySymbol {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"security_symbol"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UIImageView *)newPaymentCardIcon {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"payment_card"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

@end

