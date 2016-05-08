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

@interface THLPaymentViewController ()<STPPaymentCardTextFieldDelegate>
@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@property(nonatomic, strong) THLActionButton *addCard;
@end

@implementation THLPaymentViewController

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
    
    _addCard = [self newAddCardButton];
    [self.view addSubviews:@[_paymentTextField, _addCard]];
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
    }];
    
    
}


- (THLActionButton *)newAddCardButton
{
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button
     setTitle:@"Save Card"];
    
    return button;
}


- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField
{
    // Toggle navigation, for example
    self.addCard.enabled = textField.isValid;
}


@end

