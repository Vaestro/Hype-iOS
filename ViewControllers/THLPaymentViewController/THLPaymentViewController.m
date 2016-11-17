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
#import <Parse/Parse.h>
#import "THLUser.h"
#import "SVProgressHUD.h"
#import "STPAddCardViewController.h"

@interface THLPaymentViewController()
<
STPAddCardViewControllerDelegate
>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *cardInfoLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *acceptedPaymentNoticeLabel;

@property (nonatomic, strong) UIImageView *securitySymbol;
@property (nonatomic, strong) UIImageView *paymentCardIcon;
@property (nonatomic, strong) UIImageView *acceptedPaymentCardsImage;

@property(nonatomic, strong) THLActionButton *addCardButton;
@property(nonatomic, strong) THLActionButton *removeCardButton;

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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_paymentInfo) {
        self.titleLabel.text = @"Payment";
        NSString *last4CardDigits = _paymentInfo[0][@"last4"];
        NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
        _cardInfoLabel = [self cardInfoLabel:cardInfoText];
//        [self.view addSubviews:@[_paymentCardIcon, _cardInfoLabel, _removeCardButton]];
        
    } else {
        [self payButtonTapped];
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
            make.bottom.equalTo([WSELF addCardButton].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        }];
        
    }
    
    [self.securitySymbol mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.centerY.equalTo([WSELF descriptionLabel]);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF securitySymbol].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsSuperHigh());
        
        make.bottom.equalTo([WSELF acceptedPaymentNoticeLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.mas_equalTo(SCREEN_WIDTH*0.75);
    }];

    [self.acceptedPaymentNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF acceptedPaymentCardsImage].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.acceptedPaymentCardsImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
    }];
}


- (void)updateLayoutForAddPayment {
    [_removeCardButton removeFromSuperview];
    [_paymentCardIcon removeFromSuperview];
    [_cardInfoLabel removeFromSuperview];
    _titleLabel.text = @"Add Payment";

    WEAKSELF();
    [self.addCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF addCardButton].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
    }];
}


- (void)updateLayoutForHasPayment {
    NSString *last4CardDigits = _paymentInfo[0][@"last4"];
    NSString *cardInfoText = [NSString stringWithFormat:@"**** **** **** %@", last4CardDigits];
    _cardInfoLabel = [self cardInfoLabel:cardInfoText];
    
    [self.addCardButton removeFromSuperview];
    
    WEAKSELF();
    [self.removeCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF descriptionLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.paymentCardIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF removeCardButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.cardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_paymentCardIcon.mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo(_paymentCardIcon);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo([WSELF cardInfoLabel].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
    }];
}

#pragma mark - Payment Processing
- (void)payButtonTapped {
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = self;
    // STPAddCardViewController must be shown inside a UINavigationController.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion {
                    [PFCloud callFunctionInBackground:@"createStripeCustomer"
                                       withParameters:@{@"stripeToken": token.tokenId}
                                                block:^(NSArray<NSDictionary *> *paymentInfo, NSError *cloudError) {
                                                    [SVProgressHUD dismiss];
                                                    if (cloudError) {
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                        [self displayError:cloudError];
                                                    } else {
                                                        _paymentInfo = paymentInfo;
                                                        [[THLUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable userError) {
                                                            [self updateLayoutForHasPayment];
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                        }];
                                                    }
                                                }];
}

//- (void)saveCreditCardInfo
//{
//    [_addCardButton setEnabled:FALSE];
//    [SVProgressHUD showWithStatus:@"Updating.."];
//    [[STPAPIClient sharedClient]
//     createTokenWithCard:self.paymentTextField.cardParams
//     completion:^(STPToken *token, NSError *error) {
//         if (error) {
//             [SVProgressHUD dismiss];
//             [self displayError:error];
//         } else {
//             
//             [PFCloud callFunctionInBackground:@"createStripeCustomer"
//                                withParameters:@{@"stripeToken": token.tokenId}
//                                         block:^(NSArray<NSDictionary *> *paymentInfo, NSError *cloudError) {
//                                             [SVProgressHUD dismiss];
//                                             [_addCardButton setEnabled:TRUE];
//                                             if (cloudError) {
//                                                 [self displayError:cloudError];
//                                             } else {
////                                                 Mixpanel *mixpanel = [Mixpanel sharedInstance];
////                                                 [mixpanel track:@"Payment Method Addded"];
//                                                 _paymentInfo = paymentInfo;
//                                                 [[THLUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable userError) {
//                                                     [self displaySuccess];
//                                                     [self updateLayoutForHasPayment];
//                                                 }];
//                                                 
//                                            }
//              }];
//         }
//     }];
//}

- (void)deleteCreditCardInfo {
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [SVProgressHUD showWithStatus:@"Deleting.."];

                                                              [PFCloud callFunctionInBackground:@"removeCardInfo"
                                                                                 withParameters:@{@"cardId": _paymentInfo[0][@"id"],
                                                                                                  @"customerId": [THLUser currentUser].stripeCustomerId}
                                                                                          block:^(id  _Nullable object, NSError * _Nullable cloudError) {
                                                                                              [SVProgressHUD dismiss];

                                                                                                if (cloudError) {
                                                                                                    [self displayError:cloudError];
                                                                                                } else {
//                                                                                                    Mixpanel *mixpanel = [Mixpanel sharedInstance];
//                                                                                                    [mixpanel track:@"Payment Method Deleted"];
                                                                                                    
                                                                                                    [[THLUser currentUser] fetchInBackgroundWithBlock:^(PFObject *user, NSError * _Nullable userError) {
                                                                                                       [self updateLayoutForAddPayment];
                                                                                                    }];

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
        [_addCardButton addTarget:self action:@selector(payButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//        _addCardButton.enabled = NO;
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
        _titleLabel.text = @"Payment Method";
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

- (UILabel *)acceptedPaymentNoticeLabel {
    if (!_acceptedPaymentNoticeLabel) {
        _acceptedPaymentNoticeLabel = THLNUILabel(kTHLNUIDetailTitle);
        _acceptedPaymentNoticeLabel.text = @"We accept";
        _acceptedPaymentNoticeLabel.textAlignment = kTextAlignmentCenter;

        _acceptedPaymentNoticeLabel.adjustsFontSizeToFitWidth = YES;
        _acceptedPaymentNoticeLabel.numberOfLines = 1;
        [self.view addSubview:_acceptedPaymentNoticeLabel];
    }
    return _acceptedPaymentNoticeLabel;
}

- (UIImageView *)acceptedPaymentCardsImage {
    if (!_acceptedPaymentCardsImage) {
        _acceptedPaymentCardsImage = [UIImageView new];
        _acceptedPaymentCardsImage.image = [UIImage imageNamed:@"accepted_payment_icons"];
        _acceptedPaymentCardsImage.contentMode = UIViewContentModeScaleAspectFit;
        _acceptedPaymentCardsImage.clipsToBounds = YES;
        [self.view addSubview:_acceptedPaymentCardsImage];
    }
    
    return _acceptedPaymentCardsImage;
}

@end

