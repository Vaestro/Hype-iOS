//
//  THLCheckoutViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLCheckoutViewController.h"
#import "MBProgressHUD.h"
#import "THLAppearanceConstants.h"
#import "THLEventEntity.h"
#import "THLLocationEntity.h"
#import "THLUser.h"
#import "Parse.h"
#import "THLActionButton.h"
#import "THLPurchaseDetailsView.h"
#import "THLNeedToKnowInfoView.h"


@interface THLCheckoutViewController ()
@property (nonatomic) THLEventEntity *event;
@property (nonatomic, strong) RACCommand *completionAction;
@property (nonatomic, strong) THLActionButton *purchaseButton;
@property (nonatomic, strong) THLPurchaseDetailsView *purchaseDetailsView;

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)displayError:(NSString *)error;
@end

@implementation THLCheckoutViewController

#pragma mark - Life cycle

- (id)initWithEvent:(THLEventEntity *)event andCompletionAction:(RACCommand *)completionAction
{
    if (self = [super init]) {
        self.event = event;
        self.completionAction = completionAction;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}

- (void)constructView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = [self backBarButton];
    self.navigationItem.titleView = [self navBarTitleLabel];
    
    _purchaseButton = [self newPurchaseButton];
    _purchaseDetailsView = [self newPurchaseDetailsView];
}

- (void)layoutView {
    [self.view addSubviews:@[_purchaseButton, _purchaseDetailsView]];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [_purchaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.bottom.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_purchaseDetailsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.equalTo(_purchaseButton.mas_top);
    }];
}


#pragma mark - Constructors

- (UIBarButtonItem *)backBarButton
{
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (UILabel *)navBarTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event.location.name, _event.date.thl_formattedDate];
    [label sizeToFit];
    return label;
}

- (THLActionButton *)newPurchaseButton {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"Complete Order"];
    [button addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (THLPurchaseDetailsView *)newPurchaseDetailsView {
    THLPurchaseDetailsView *purchaseDetailsView = [THLPurchaseDetailsView new];
    purchaseDetailsView.title = NSLocalizedString(@"Purchase Details",@"Purchase Details");

    float maleServiceCharge = (_event.maleTicketPrice * 0.029) + 0.30;
    float femaleServiceCharge = (_event.femaleTicketPrice * 0.029) + 0.30;
    if ([THLUser currentUser].sex == THLSexMale) {
        purchaseDetailsView.purchaseTitleText = @"Male General Admission";
        purchaseDetailsView.subtotalAmount = [NSString stringWithFormat:@"$%.2f", _event.maleTicketPrice];
        purchaseDetailsView.serviceChargeAmount = [NSString stringWithFormat:@"$%.2f", maleServiceCharge];
        purchaseDetailsView.totalAmount = [NSString stringWithFormat:@"$%.2f", _event.maleTicketPrice + maleServiceCharge];
    } else if ([THLUser currentUser].sex == THLSexFemale) {
        purchaseDetailsView.purchaseTitleText = @"Female General Admission";
        purchaseDetailsView.subtotalAmount = [NSString stringWithFormat:@"$%.2f", _event.femaleTicketPrice];
        purchaseDetailsView.serviceChargeAmount = [NSString stringWithFormat:@"$%.2f", femaleServiceCharge];
        purchaseDetailsView.totalAmount = [NSString stringWithFormat:@"$%.2f", _event.femaleTicketPrice + femaleServiceCharge];
    }
    return purchaseDetailsView;
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buy:(id)sender
{
    self.hud.labelText = NSLocalizedString(@"Processing...", @"Processing...");
    [self.hud show:YES];
    if ([THLUser currentUser].stripeCustomerId) {
        [self chargeCustomer:[THLUser currentUser] forEvent:_event];
    } else {
        [self.hud hide:YES];
        [self displayError:@"You currently don't have a credit card on file. Please add a payment method in your profile"];
    }
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

- (void)chargeCustomer:(THLUser *)customer forEvent:(THLEventEntity *)event
{
    NSDictionary *purchaseInfo = @{
                                   @"eventId": event.objectId,
                                   @"eventTime": event.date,
                                   @"venue": event.location.name,
                                   @"amount":  customer.sex == 1 ? [NSNumber numberWithFloat:event.maleTicketPrice] : [NSNumber numberWithFloat:event.maleTicketPrice],
                                   @"customerName": [customer fullName],
                                   @"description": customer.sex == 1 ? @"Male GA" : @"Female GA"
                                   };
    
    [PFCloud callFunctionInBackground:@"completeOrder"
                       withParameters:purchaseInfo
                                block:^(id object, NSError *error) {
                                    [self.hud hide:YES];
                                    if (error) {
                                        [self displayError:[error localizedDescription]];
                                    } else {
                                        [self.navigationController dismissViewControllerAnimated:TRUE completion:^{
                                            [_completionAction execute:nil];
                                        }];
                                    }
                                }];
}


@end
