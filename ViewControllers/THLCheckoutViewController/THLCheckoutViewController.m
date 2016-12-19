//
//  THLCheckoutViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLCheckoutViewController.h"
#import "THLAppearanceConstants.h"
#import "THLEvent.h"
#import "THLGuestlistInvite.h"
#import "THLUser.h"
#import "Parse.h"
#import "THLActionButton.h"
#import "THLPurchaseDetailsView.h"
#import "THLGuestlistInvite.h"
#import "THLGuestlist.h"
#import "THLImportantInformationView.h"
#import "THLPaymentMethodView.h"
#import "THLInformationViewController.h"
#import "THLResourceManager.h"
#import "SVProgressHUD.h"
#import "Hype-Swift.h"
#import "Branch.h"

@interface THLCheckoutViewController ()
<
TTTAttributedLabelDelegate
>
@property (nonatomic) THLEvent *event;
@property (nonatomic) PFObject *admissionOption;
@property (nonatomic) THLGuestlistInvite *guestlistInvite;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) float serviceCharge;
@property (nonatomic) float total;
@property (nonatomic) float subTotal;
@property (nonatomic) float creditsAmount;
@property (nonatomic) float tax;
@property (nonatomic) float tip;

@property (nonatomic, strong) THLActionButton *purchaseButton;
@property (nonatomic, strong) THLPurchaseDetailsView *purchaseDetailsView;
@property (nonatomic, strong) THLPaymentMethodView *paymentMethodView;
@property (nonatomic, strong) UIButton *applyCreditsButton;
@property (nonatomic, strong) UILabel *applyCreditsLabel;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property (nonatomic, strong) UILabel *navBarTitleLabel;

@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic) bool applyCreditsPressed;

@property (nonatomic, strong) THLImportantInformationView *importantInformationView;
@end

@implementation THLCheckoutViewController

#pragma mark - Life cycle

- (id)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption guestlistInvite:(PFObject *)guestlistInvite
{
    if (self = [super init]) {
        self.event = (THLEvent *)event;
        self.admissionOption = admissionOption;
        self.guestlistInvite = (THLGuestlistInvite *)guestlistInvite;
        
        _serviceCharge = ([_admissionOption[@"price"] floatValue] * 0.029) + 0.30;
        _subTotal = ([_admissionOption[@"price"] floatValue]);
        _total = [_admissionOption[@"price"] floatValue] + _serviceCharge;
        _applyCreditsPressed = false;
        
        if ([_admissionOption[@"type"] integerValue] == 1) {
            _tax = ([admissionOption[@"price"] floatValue] * 0.0865);
            _tip = ([admissionOption[@"price"] floatValue] * 0.2);
            _total = [_admissionOption[@"price"] floatValue] + _tax + _tip;
        }
        
        if ([_admissionOption[@"price"] floatValue] == 0) {
            _applyCreditsButton.enabled = NO;
        }
        
        
        if ([THLUser currentUser].credits > [_admissionOption[@"price"] floatValue]) {
            _creditsAmount = [_admissionOption[@"price"] floatValue];
        } else {
            _creditsAmount = [THLUser currentUser].credits;
        }
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = [self backBarButton];
    self.navigationItem.titleView = [[THLEventNavBarTitleView alloc] initWithVenueName:_event.location.name date:_event.date];
    
    WEAKSELF();
    [self.purchaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.bottom.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(WSELF.purchaseButton.mas_top);
    }];
    
    [self generateContent];
}

- (void)generateContent {
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    WEAKSELF();
    [contentView addSubviews:@[self.purchaseDetailsView, self.paymentMethodView, self.importantInformationView]];
    
    [self.purchaseDetailsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
//    if ([_admissionOption[@"type"] integerValue] != 1) {
//        [contentView addSubviews:@[self.applyCreditsLabel, self.applyCreditsButton]];
//        
//        [self.applyCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(WSELF.purchaseDetailsView.mas_bottom).insets(kTHLEdgeInsetsHigh());
//            make.centerY.equalTo(WSELF.applyCreditsButton);
//            make.right.insets(kTHLEdgeInsetsSuperHigh());
//        }];
//        
//        [self.applyCreditsButton makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(WSELF.purchaseDetailsView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//            make.left.insets(kTHLEdgeInsetsSuperHigh());
//        }];
//        
//        [self.paymentMethodView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(WSELF.applyCreditsLabel.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
//        }];
//    } else {
        [self.paymentMethodView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.purchaseDetailsView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        }];
//    }

    [self.importantInformationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.paymentMethodView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    if ([_admissionOption[@"type"] integerValue] == 1) {
         [contentView addSubviews:@[self.agreementButton, self.attributedLabel]];
        [self.agreementButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.importantInformationView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.width.equalTo(15);
            make.height.equalTo(WSELF.agreementButton.mas_width);
            make.left.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.insets(kTHLEdgeInsetsSuperHigh());
        }];
        
        [self.attributedLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(WSELF.agreementButton);
            make.left.equalTo(WSELF.agreementButton.mas_right).insets(kTHLEdgeInsetsLow());
            make.right.equalTo(kTHLEdgeInsetsHigh());
        }];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(WSELF.agreementButton.mas_bottom).offset(25);
        }];
    } else {
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(WSELF.importantInformationView.mas_bottom);
        }];
    }

}


#pragma mark - Constructors

- (UIBarButtonItem *)backBarButton
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (THLImportantInformationView *)importantInformationView
{
    if (!_importantInformationView) {
        _importantInformationView = [THLImportantInformationView new];
        _importantInformationView.titleLabel.text = @"Important Information";
        if ([_admissionOption[@"type"] integerValue] == 0) {
            _importantInformationView.importantInformationLabel.text = @"Your purchase is non-refundable\n\nBest Price Guaranteed: Find a better price and we'll match it\n\nTicket is valid until 2am the night of the event\n\nPlease dress appropriately\n\nDoorman has final say on admission";
        } else {
            _importantInformationView.importantInformationLabel.text = @"You will pay the total at the venue\n\nPlease dress appropriately\n\nDoorman has final say on admission";
        }
        
    }
    return _importantInformationView;
}

- (THLPaymentMethodView *)paymentMethodView {
    if (!_paymentMethodView) {
        _paymentMethodView = [THLPaymentMethodView new];
        _paymentMethodView.paymentTitleLabel.text = @"Payment Method";
        [_paymentMethodView addTarget:self.delegate action:@selector(checkoutViewControllerWantsToPresentPaymentViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentMethodView;
}

- (UILabel *)navBarTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event.location.name, _event.date.thl_weekdayString];
    [label sizeToFit];
    return label;
}

- (THLActionButton *)purchaseButton {
    if (!_purchaseButton) {
        _purchaseButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_admissionOption[@"type"] integerValue] == 0 ? [_purchaseButton setTitle:@"COMPLETE ORDER"] : [_purchaseButton setTitle:@"RESERVE"];
        if ([_admissionOption[@"type"] integerValue] == 0) {
           [_purchaseButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [_purchaseButton addTarget:self action:@selector(reserve:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.view addSubview:_purchaseButton];
    }
    return _purchaseButton;
}

- (THLPurchaseDetailsView *)purchaseDetailsView {
    if (!_purchaseDetailsView) {
        if ([_admissionOption[@"price"] floatValue] > 0 && [_admissionOption[@"type"] integerValue] == 0) {
            NSString *subtotal = [NSString stringWithFormat:@"$%.2f", _subTotal];
            NSString *serviceCharge= [NSString stringWithFormat:@"$%.2f", _serviceCharge];
            NSString *total = [NSString stringWithFormat:@"$%.2f", _total];
            NSString *purchaseTitle = _admissionOption[@"name"];
            _purchaseDetailsView = [[THLPurchaseDetailsView alloc] initForTicketWithSubtotal:subtotal purchaseTitle:purchaseTitle serviceCharge:serviceCharge total:total];
        } else if ([_admissionOption[@"price"] floatValue] > 0 && [_admissionOption[@"type"] integerValue] == 1) {
            NSString *subtotal = [NSString stringWithFormat:@"$%.2f", _subTotal];
            NSString *tax= [NSString stringWithFormat:@"$%.2f", _tax];
            NSString *tip = [NSString stringWithFormat:@"$%.2f", _tip];
            NSString *total = [NSString stringWithFormat:@"$%.2f", _total];
            NSString *purchaseTitle = _admissionOption[@"name"];
            _purchaseDetailsView = [[THLPurchaseDetailsView alloc] initForTableReservationWithSubtotal:subtotal purchaseTitle:purchaseTitle tax:tax tip:tip total:total];
        } else {
            NSString *purchaseTitle = _admissionOption[@"name"];
            _purchaseDetailsView = [[THLPurchaseDetailsView alloc] initForTicketWithSubtotal:@"Free" purchaseTitle:purchaseTitle serviceCharge:@"Free" total:@"Free"];
        }
    }

    return _purchaseDetailsView;
}

- (UILabel *)applyCreditsLabel
{
    if (!_applyCreditsLabel) {
        _applyCreditsLabel = [UILabel new];
        _applyCreditsLabel.text = [NSString stringWithFormat:@"$%.2f", _creditsAmount];
        _applyCreditsLabel.textColor = kTHLNUIAccentColor;
    }
    
    return _applyCreditsLabel;
}

- (UIButton *)applyCreditsButton
{
    if (!_applyCreditsButton) {
        _applyCreditsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyCreditsButton setTitle:@"Apply Credits" forState:UIControlStateNormal];
        [_applyCreditsButton addTarget:self
                   action:@selector(applyCredits:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyCreditsButton;
}

- (UIButton *)agreementButton
{
    if (!_agreementButton) {
        _agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementButton setImage:[UIImage imageNamed:@"unchecked_box"] forState:UIControlStateNormal];
        [_agreementButton setImage:[UIImage imageNamed:@"checked_box"] forState:UIControlStateSelected];
        [_agreementButton addTarget:self
                                action:@selector(agreementButtonToggle:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _agreementButton;
}

- (TTTAttributedLabel *)attributedLabel {
    if (!_attributedLabel) {
        _attributedLabel = [TTTAttributedLabel new];
        _attributedLabel.textColor = kTHLNUIGrayFontColor;
        _attributedLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        _attributedLabel.numberOfLines = 1;
        _attributedLabel.adjustsFontSizeToFitWidth = YES;
        _attributedLabel.minimumScaleFactor = 0.5;
        _attributedLabel.linkAttributes = @{NSForegroundColorAttributeName: kTHLNUIAccentColor,
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        
        _attributedLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
        _attributedLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString *labelText = @"I have read and understand the Cancellation Policy";
        _attributedLabel.text = labelText;
        
        NSRange agreement = [labelText rangeOfString:@"I have read and understand the"];
        NSRange cancellation = [labelText rangeOfString:@"Cancellation Policy"];
        [_attributedLabel addLinkToURL:[NSURL URLWithString:@"action://toggle-agreement"] withRange:agreement];
        [_attributedLabel addLinkToURL:[NSURL URLWithString:@"action://show-cancellation"] withRange:cancellation];
        _attributedLabel.delegate = self;
    }
    return _attributedLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-cancellation"]) {
            THLInformationViewController *infoVC = [THLInformationViewController new];
            infoVC.displayText = [THLResourceManager cancellationPolicyText];
            infoVC.title = @"Cancellation Policy";
            
            [self.navigationController pushViewController:infoVC animated:YES];

        } else if ([[url host] hasPrefix:@"toggle-agreement"]) {
            [self agreementButtonToggle:_attributedLabel];
        } else {
            /* deal with http links here */
        }
    }
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reserve:(id)sender
{
    if (!_agreementButton.selected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please check that you agree to the Cancellation Policy"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (![THLUser currentUser].stripeCustomerId) {
        [self handleNeedsPaymentMethodAction];
    } else {
        
        [SVProgressHUD show];
        
        NSDictionary *purchaseInfo = @{
                                       @"admissionOptionId" : _admissionOption.objectId,
                                       @"eventId": _event.objectId,
                                       @"eventTime": _event.date,
                                       @"locationName": _event.location.name,
                                       @"description": _admissionOption[@"name"]
                                       };
        
        [PFCloud callFunctionInBackground:@"createReservation"
                           withParameters:purchaseInfo
                                    block:^(NSString *guestlistId, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error) {
                                            [self displayError:[error localizedDescription]];
                                        } else {
//                                            Mixpanel *mixpanel = [Mixpanel sharedInstance];
//                                            [mixpanel track:@"Reserved a Table"];
//                                            [mixpanel.people increment:@"tables reserved" by:@1];
                                            
                                            [self pinGuestlistInviteForReservation];
                                        }
                                    }];
    }
 
}

- (void)handleNeedsPaymentMethodAction {
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.delegate checkoutViewControllerWantsToPresentPaymentViewController];
                                                          }];
    NSString *message = NSStringWithFormat(@"You currently don't have a credit card on file. Please add a payment method");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:confirmAction, nil]];
    
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

- (void)agreementButtonToggle:(id)sender
{
    _agreementButton.selected = !_agreementButton.selected; // toggle the selected property, just a simple BOOL

}


- (void)buy:(id)sender
{
    [SVProgressHUD show];
    if ([_admissionOption[@"price"] integerValue] == 0 ) {
        [self chargeCustomer:[THLUser currentUser] forEvent:_event];
    } else if ( ![THLUser currentUser].stripeCustomerId){
        [SVProgressHUD dismiss];
        [self handleNeedsPaymentMethodAction];
    } else {
        [self chargeCustomer:[THLUser currentUser] forEvent:_event];
    }
}

- (void)applyCredits:(id)sender
{
    if ([THLUser currentUser].credits <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You do not have any credits to apply to this purchase"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController * alert=  [UIAlertController
                                     alertControllerWithTitle:@"Info"
                                     message:@"If you apply your credits now, you will not be able to get them back"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 _total -= _creditsAmount;
                                 _subTotal -= _creditsAmount;
                                 _applyCreditsPressed = true;
                                 [self updateView];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    

}

- (void)updateView {
    _applyCreditsButton.hidden = YES;
    _applyCreditsLabel.hidden = YES;
     _purchaseDetailsView.subtotalLabel.text = [NSString stringWithFormat:@"$%.2f", _subTotal];
    _purchaseDetailsView.totalLabel.text = [NSString stringWithFormat:@"$%.2f", _total];
}


- (void)pinGuestlistInviteForEvent
{
    [[self queryForGuestlistInviteForEvent:_event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *queryError) {
        if (!queryError) {
            [guestlistInvite pinInBackground];
            PFObject *guestlist = guestlistInvite[@"Guestlist"];
            [self.delegate checkoutViewControllerDidFinishCheckoutForEvent:_event withGuestlistId:guestlist.objectId guestlistInvite:guestlistInvite];
        } else {
            
        }
    }];
}

- (void)pinGuestlistInviteForReservation
{
    [[self queryForGuestlistInviteForEvent:_event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *queryError) {
        if (!queryError) {
            [guestlistInvite pinInBackground];
            [self.delegate checkoutViewControllerDidFinishTableReservationForEvent:guestlistInvite];
        } else {
            
        }
    }];
}



#pragma mark - Helpers

- (void)displayError:(NSString *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:error
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)chargeCustomer:(THLUser *)customer forEvent:(THLEvent *)event
{
    [_purchaseButton setEnabled:FALSE];
    if (_guestlistInvite) {
        THLGuestlist *guestlist = _guestlistInvite[@"Guestlist"];
        NSString *guestlistId = guestlist.objectId;
        NSDictionary *purchaseInfo = @{
                                       @"eventId": event.objectId,
                                       @"eventTime": event.date,
                                       @"venue": event.location.name,
                                       @"amount": [NSNumber numberWithFloat:_total],
                                       @"customerName": [customer fullName],
                                       @"description": _admissionOption[@"name"],
                                       @"admissionOptionId" : _admissionOption.objectId,
                                       @"guestlistId" : guestlistId,
                                       @"guestlistInviteId": _guestlistInvite.objectId
                                       };
        
        [PFCloud callFunctionInBackground:@"completeOrderForInvite"
                           withParameters:purchaseInfo
                                    block:^(id response, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error) {
                                            [self displayError:[error localizedDescription]];
                                            [_purchaseButton setEnabled:TRUE];

                                        } else {
//                                            Mixpanel *mixpanel = [Mixpanel sharedInstance];
//                                           [mixpanel track:@"Accepted invite and purchased ticket"];
//                                           [mixpanel.people increment:@"tickets purchased" by:@1];
//                                            [mixpanel.people trackCharge:[NSNumber numberWithFloat:_total] withProperties:@{
//                                                                                                                            @"$time": [NSDate date]
//                                                                                                                            }];
                                            [[Branch getInstance] userCompletedAction:@"purchase" withState:@{@"$amount":NSStringWithFormat(@"%f", _total)}];
                                            if ([THLUser currentUser].sex == THLSexMale) {
                                                [[Branch getInstance] userCompletedAction:@"maleTicketPurchase"];
                                            } else {
                                                [[Branch getInstance] userCompletedAction:@"femaleTicketPurchase"];
                                            }

                                            if (_applyCreditsPressed) {
                                                [[THLUser currentUser] incrementKey:@"credits" byAmount: [NSNumber numberWithFloat:-_creditsAmount]];
                                                [[THLUser currentUser] saveEventually];
                                            }
                                            
                                            [_guestlistInvite pinInBackground];
                                            [self.delegate checkoutViewControllerDidFinishCheckoutForEvent:_event withGuestlistId:guestlist.objectId guestlistInvite:_guestlistInvite];
                                    }
                                }];
    } else {
        
        NSDictionary *purchaseInfo = @{
                                       @"eventId": event.objectId,
                                       @"eventTime": event.date,
                                       @"venue": event.location.name,
                                       @"amount": [NSNumber numberWithFloat:_total],
                                       @"customerName": [customer fullName],
                                       @"admissionOptionId" : _admissionOption.objectId,
                                       @"description": _admissionOption[@"name"]
                                       };
        
        [PFCloud callFunctionInBackground:@"completeOrder"
                           withParameters:purchaseInfo
                                    block:^(NSString *guestlistId, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error) {
                                            [self displayError:[error localizedDescription]];
                                            [_purchaseButton setEnabled:TRUE];
                                        } else {
//                                            Mixpanel *mixpanel = [Mixpanel sharedInstance];
//                                            [mixpanel track:@"Purchased ticket"];
//                                            [mixpanel.people increment:@"tickets purchased" by:@1];
//                                            [mixpanel.people trackCharge:[NSNumber numberWithFloat:_total] withProperties:@{
//                                                                                              @"$time": [NSDate date]
//                                                                                              }];
                                            [[Branch getInstance] userCompletedAction:@"purchase" withState:@{@"$amount":NSStringWithFormat(@"%f", _total)}];
                                            if ([THLUser currentUser].sex == THLSexMale) {
                                                [[Branch getInstance] userCompletedAction:@"maleTicketPurchase"];
                                            } else {
                                                [[Branch getInstance] userCompletedAction:@"femaleTicketPurchase"];
                                            }
                                            
                                            if (_applyCreditsPressed) {
                                                [[THLUser currentUser] incrementKey:@"credits" byAmount: [NSNumber numberWithFloat:-_creditsAmount]];
                                                [[THLUser currentUser] saveEventually];
                                            }
                                            
                                            [self pinGuestlistInviteForEvent];
                                            
                                        }
                                    }];
    }
}



#pragma mark - ThisShitShouldNotBeHereButFuckIt

- (PFQuery *)queryForGuestlistInviteForEvent:(NSString *)eventId {
    
    PFQuery *eventQuery = [self baseEventQuery];
    [eventQuery whereKey:@"objectId" equalTo:eventId];
    
    PFQuery *guestlistQuery = [self baseGuestlistQuery];
    [guestlistQuery whereKey:@"event" matchesQuery:eventQuery];
    
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guest" equalTo:[THLUser currentUser]];
    [query whereKey:@"Guestlist" matchesQuery:guestlistQuery];
    [query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:-1]];
    return query;
}

- (PFQuery *)baseEventQuery {
    PFQuery *query = [THLEvent query];
    [query includeKey:@"location"];
    return query;
}

- (PFQuery *)baseGuestlistQuery {
    PFQuery *query = [THLGuestlist query];
    [query includeKey:@"Owner"];
    [query includeKey:@"event"];
    [query includeKey:@"event.location"];
    return query;
}

- (PFQuery *)baseGuestlistInviteQuery {
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.location"];
    return query;
}

@end
