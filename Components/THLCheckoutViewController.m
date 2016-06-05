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
#import "THLEvent.h"
#import "THLLocationEntity.h"
#import "THLUser.h"
#import "Parse.h"
#import "THLActionButton.h"
#import "THLPurchaseDetailsView.h"
#import "THLNeedToKnowInfoView.h"
#import "THLGuestlistInvite.h"
#import "THLGuestlist.h"
#import "THLImportantInformationView.h"
#import "THLPaymentMethodView.h"
#import "SVProgressHUD.h"

@interface THLCheckoutViewController ()
@property (nonatomic) THLEvent *event;
@property (nonatomic, strong) RACCommand *completionAction;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) THLActionButton *purchaseButton;
@property (nonatomic, strong) THLPurchaseDetailsView *purchaseDetailsView;
@property (nonatomic, strong) THLPaymentMethodView *paymentMethodView;

@property (nonatomic, strong) NSDictionary *paymentInfo;
@property (nonatomic, strong) THLImportantInformationView *importantInformationView;
@end

@implementation THLCheckoutViewController

#pragma mark - Life cycle

- (id)initWithEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo;
{
    if (self = [super init]) {
        self.event = (THLEvent *)event;
        self.paymentInfo = paymentInfo;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = [self backBarButton];
    self.navigationItem.titleView = [self navBarTitleLabel];

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
    
    [self.paymentMethodView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.purchaseDetailsView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.importantInformationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.paymentMethodView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.importantInformationView.bottom);
    }];
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
        _importantInformationView.importantInformationLabel.text = @"Your purchase is non-refundable\n\nPlease dress appropriately\n\nDoorman has final say on admission";
//        [self.scrollView addSubview:_importantInformationView];
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
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event.location.name, _event.date.thl_formattedDate];
    [label sizeToFit];
    return label;
}

- (THLActionButton *)purchaseButton {
    if (!_purchaseButton) {
        _purchaseButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_purchaseButton setTitle:@"Complete Order"];
        [_purchaseButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_purchaseButton];
    }
    return _purchaseButton;
}

- (THLPurchaseDetailsView *)purchaseDetailsView {
    if (!_purchaseDetailsView) {
        _purchaseDetailsView = [THLPurchaseDetailsView new];
        _purchaseDetailsView.titleLabel.text = @"Purchase Details";
        
        float maleServiceCharge = (_event.maleTicketPrice * 0.029) + 0.30;
        float femaleServiceCharge = (_event.femaleTicketPrice * 0.029) + 0.30;
        NSString *purchaseTitleText;
        THLUser *currentUser = [THLUser currentUser];
        if (currentUser.sex == THLSexMale) {
            purchaseTitleText = @"Male General Admission";
        } else if (currentUser.sex == THLSexFemale) {
            purchaseTitleText = @"Female General Admission";
        }
        if (currentUser.sex == THLSexMale && _event.maleTicketPrice > 0.0) {
            _purchaseDetailsView.purchaseTitleLabel.text = purchaseTitleText;
            
            _purchaseDetailsView.subtotalLabel.text = [NSString stringWithFormat:@"$%.2f", _event.maleTicketPrice];
            _purchaseDetailsView.serviceChargeLabel.text = [NSString stringWithFormat:@"$%.2f", maleServiceCharge];
            _purchaseDetailsView.totalLabel.text = [NSString stringWithFormat:@"$%.2f", _event.maleTicketPrice + maleServiceCharge];
        } else if (currentUser.sex == THLSexFemale && _event.femaleTicketPrice > 0.0) {
            _purchaseDetailsView.purchaseTitleLabel.text = purchaseTitleText;
            _purchaseDetailsView.subtotalLabel.text = [NSString stringWithFormat:@"$%.2f", _event.femaleTicketPrice];
            _purchaseDetailsView.serviceChargeLabel.text = [NSString stringWithFormat:@"$%.2f", femaleServiceCharge];
            _purchaseDetailsView.totalLabel.text = [NSString stringWithFormat:@"$%.2f", _event.femaleTicketPrice + femaleServiceCharge];
        } else {
            _purchaseDetailsView.purchaseTitleLabel.text = purchaseTitleText;
            _purchaseDetailsView.subtotalLabel.text = @"FREE";
            _purchaseDetailsView.serviceChargeLabel.text = @"FREE";
            _purchaseDetailsView.totalLabel.text = @"FREE";
        }
//        [self.scrollView addSubview:_purchaseDetailsView];
    }

    return _purchaseDetailsView;
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buy:(id)sender
{
    [SVProgressHUD show];
    if ([THLUser currentUser].stripeCustomerId) {
        [self chargeCustomer:[THLUser currentUser] forEvent:_event];
    } else {
        [SVProgressHUD dismiss];
        [self.delegate checkoutViewControllerWantsToPresentPaymentViewController];
//        [self displayError:@"You currently don't have a credit card on file. Please add a payment method in your profile"];
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

- (void)chargeCustomer:(THLUser *)customer forEvent:(THLEvent *)event
{
    
    if (_paymentInfo[@"guestlistInviteId"]) {
        
        NSDictionary *purchaseInfo = @{
                                      @"eventId": event.objectId,
                                      @"eventTime": event.date,
                                      @"venue": event.location.name,
                                      @"amount":  customer.sex == 1 ? [NSNumber numberWithFloat:event.maleTicketPrice] : [NSNumber numberWithFloat:event.femaleTicketPrice],
                                      @"customerName": [customer fullName],
                                      @"description": customer.sex == 1 ? @"Male GA" : @"Female GA",
                                      @"guestlistInviteId": _paymentInfo[@"guestlistInviteId"]
                                              };
        
        
        [PFCloud callFunctionInBackground:@"completeOrderForInvite"
                           withParameters:purchaseInfo
                                    block:^(id response, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error) {
                                            [self displayError:[error localizedDescription]];
                                        } else {
//                                            [self.delegate checkoutViewController:self didFinishPurchasingForGuestlistInvite:response];
//                                            [self.navigationController dismissViewControllerAnimated:TRUE completion:^{
//                                                [_completionAction execute:nil];
//                                            }];
                                            [[self queryForGuestlistInviteForEvent:_event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *queryError) {
                                                if (!queryError) {
                                                    [guestlistInvite pinInBackground];
                                                    PFObject *guestlist = guestlistInvite[@"Guestlist"];
                                                    [self.delegate checkoutViewControllerDidFinishCheckoutForEvent:_event withGuestlistId:guestlist.objectId];
                                                } else {
                                                    
                                                }
                                            }];
                                    }
                                    }];
    } else {
        
        NSDictionary *purchaseInfo = @{
                                       @"eventId": event.objectId,
                                       @"eventTime": event.date,
                                       @"venue": event.location.name,
                                       @"amount":  customer.sex == 1 ? [NSNumber numberWithFloat:event.maleTicketPrice] : [NSNumber numberWithFloat:event.femaleTicketPrice],
                                       @"customerName": [customer fullName],
                                       @"description": customer.sex == 1 ? @"Male GA" : @"Female GA"
                                       };
        
        [PFCloud callFunctionInBackground:@"completeOrder"
                           withParameters:purchaseInfo
                                    block:^(NSString *guestlistId, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error) {
                                            [self displayError:[error localizedDescription]];
                                        } else {
//                                            [self.delegate checkoutViewController:self didFinishSubmittingGuestlist:guestlistId];
//                                            [self.navigationController dismissViewControllerAnimated:TRUE completion:^{
//                                                [_completionAction execute:nil];
//                                            }];
                                            [[self queryForGuestlistInviteForEvent:_event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *queryError) {
                                                if (!queryError) {
                                                    [guestlistInvite pinInBackground];
                                                    PFObject *guestlist = guestlistInvite[@"Guestlist"];
                                                    [self.delegate checkoutViewControllerDidFinishCheckoutForEvent:_event withGuestlistId:guestlist.objectId];
                                                } else {
                                                    
                                                }
                                            }];
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
    [query includeKey:@"host"];
    return query;
}

- (PFQuery *)baseGuestlistQuery {
    PFQuery *query = [THLGuestlist query];
    [query includeKey:@"Owner"];
    [query includeKey:@"event"];
    [query includeKey:@"event.host"];
    [query includeKey:@"event.location"];
    return query;
}

- (PFQuery *)baseGuestlistInviteQuery {
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    return query;
}

@end
