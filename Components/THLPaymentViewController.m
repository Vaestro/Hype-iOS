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
@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@property(nonatomic, strong) THLActionButton *addCard;
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
    
    _addCard = [self newAddCardButton];
    
    [self.view addSubviews:@[_paymentTextField, _addCard, _hud]];
}

- (void)layoutView
{
    
    [_paymentTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(0).offset(10);
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    WEAKSELF();
    [_addCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.paymentTextField.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.left.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    
}


- (THLActionButton *)newAddCardButton
{
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"Add Card"];
    [button addTarget:self action:@selector(saveCreditCardInfo) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    return button;
}


- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField
{
    self.addCard.enabled = textField.isValid;
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
                                                 [[PFUser currentUser] saveEventually];
                                                 [self displaySuccess];
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


@end

