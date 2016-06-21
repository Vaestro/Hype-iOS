//
//  THLPerkDetailViewController.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailViewController.h"
#import "ORStackScrollView.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "THLActionBarButton.h"
#import "Parse.h"
#import "THLConfirmationView.h"
#import "Intercom/intercom.h"
#import "THLUser.h"
#import "THLPerkStoreItem.h"

@interface THLPerkDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *perkDescriptionLabel;
@property (nonatomic, strong) UIImageView *perkImageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemCreditsLabel;
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) THLActionBarButton *purchaseButton;
@property (nonatomic, strong) THLConfirmationView *confirmationView;

@property (nonatomic, strong) PFObject *perk;
@property (nonatomic) float userCredits;


@end


@implementation THLPerkDetailViewController
- (id)initWithPerk:(PFObject *)perk {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _perk = perk;

    }
    return self;
}

#pragma mark VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = [_perkStoreItemName uppercaseString];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    WEAKSELF();
    [self.perkImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.height.equalTo(SCREEN_HEIGHT * 0.33);
    }];
    
    [self.itemNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SV([WSELF itemNameLabel])).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF perkImageView]).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo([WSELF itemCreditsLabel].mas_top).insets(kTHLEdgeInsetsHigh());

    }];
    
    [self.itemCreditsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF itemNameLabel]);
        make.bottom.equalTo([WSELF perkImageView]).insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF perkImageView].mas_bottom);
        make.right.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.scrollView.stackView addSubview:self.perkDescriptionLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];
    
    [self.purchaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF scrollView].mas_bottom);
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
}


- (void)showRedeeemPerkFlow {
    WEAKSELF();
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Touched redeem perk button" properties:@{@"Perk Name": NSStringWithFormat(@"%@", _perk[@"name"])}];
    
    _confirmationView = [THLConfirmationView new];
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [[self purchasePerkStoreItem] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            [WSELF didPurchasePerk];
            return nil;
        }];
        [WSELF.confirmationView setInProgressWithMessage:@"Redeeming your reward..."];
        return [RACSignal empty];
    }];

    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.confirmationView dismiss];
        return [RACSignal empty];
    }];

    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];

    THLPerkStoreItem *perk = (THLPerkStoreItem *)_perk;

    [_confirmationView setAcceptButtonText:@"Yes"];
    [_confirmationView setDeclineButtonText:@"No"];
    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:dismissCommand];
    [_confirmationView setConfirmationWithTitle:@"Redeem Reward"
                                        message:[NSString stringWithFormat:@"Are you sure you want to use your credits to pucharse this reward for %i.00 ?", perk.credits]];
    
    _userCredits = [THLUser currentUser].credits;
    
    _userCredits >= perk.credits ? [self showConfirmationView] : [self errorWithPurchase];
}


- (void)errorWithPurchase {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"You dont have enough credits to redeem this reward");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
    
}

- (void)showConfirmationView {
    [self.navigationController.view addSubview:_confirmationView];
    [_confirmationView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:_confirmationView];
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

- (void)didPurchasePerk {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    [Intercom logEventWithName:@"store_purchase" metaData: @{
                                                             @"order_date": dateString,
                                                             @"perk_store_item": _perk[@"name"]
                                                             }];
    THLPerkStoreItem *perk = (THLPerkStoreItem *)_perk;
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Redeemed perk" properties:@{@"Perk Name": NSStringWithFormat(@"%@", perk.name)}];
    [mixpanel.people increment:@"perks redeemed" by:@1];

    [self.confirmationView setSuccessWithTitle:@"Perk Redeemed"
                                       Message:[NSString stringWithFormat:@"You have successfully redeemed your credits for %i. Check your email for further instructions.", perk.credits]];
}

- (BFTask *)purchasePerkStoreItem {
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    THLPerkStoreItem *perk = (THLPerkStoreItem *)_perk;

    [PFCloud callFunctionInBackground:@"purchasePerkStoreItem"
                       withParameters:@{@"perkStoreItemId" : perk.objectId,
                                        @"perkStoreItemCost" : [[NSNumber alloc] initWithFloat:perk.credits],
                                        @"perkStoreItemName" : perk.name,
                                        @"userEmail" : [THLUser currentUser].email,
                                        @"userName" : [THLUser currentUser].fullName
                                        }
                                block:^(id object, NSError *error) {
                                    if (!error){
                                        [completionSource setResult:nil];
                                    } else {
                                        [completionSource setError:error];
                                    }}];
    
    return completionSource.task;
}

#pragma mark - Constructors

- (THLActionBarButton *)purchaseButton {
    if (!_purchaseButton) {
        _purchaseButton = [THLActionBarButton new];
        _purchaseButton.backgroundColor = kTHLNUIAccentColor;
        [_purchaseButton.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"REDEEM CREDITS", nil)];
        [_purchaseButton addTarget:self action:@selector(showRedeeemPerkFlow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_purchaseButton];
    }
    return _purchaseButton;
}

- (ORStackScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [ORStackScrollView new];
        _scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
        _scrollView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [self.view addSubview:_scrollView];
    }

    return _scrollView;
}

- (UIImageView *)perkImageView {
    if (!_perkImageView) {
        _perkImageView = [UIImageView new];
        _perkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _perkImageView.clipsToBounds = YES;
        [_perkImageView dimView];
        PFFile *imageFile = _perk[@"image"];
        NSURL *url = [NSURL URLWithString:imageFile.url];
        [self.perkImageView sd_setImageWithURL:url];
        
        [self.view addSubview:_perkImageView];
    }

    return _perkImageView;
}

- (UILabel *)itemNameLabel {
    if (!_itemNameLabel) {
        _itemNameLabel = THLNUILabel(kTHLNUIBoldTitle);
        _itemNameLabel.adjustsFontSizeToFitWidth = YES;
        _itemNameLabel.numberOfLines = 2;
        _itemNameLabel.minimumScaleFactor = 0.5;
        _itemNameLabel.textAlignment = NSTextAlignmentLeft;
        _itemNameLabel.text = _perk[@"name"];
        [self.view addSubview:_itemNameLabel];
    }

    return _itemNameLabel;
}

- (UILabel *)itemCreditsLabel {
    if (!_itemCreditsLabel) {
        _itemCreditsLabel = [UILabel new];
        _itemCreditsLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:20.0f];
        _itemCreditsLabel.textColor = kTHLNUIAccentColor;
        _itemCreditsLabel.adjustsFontSizeToFitWidth = NO;
        _itemCreditsLabel.numberOfLines = 1;
        _itemCreditsLabel.minimumScaleFactor = 0.5;
        _itemCreditsLabel.textAlignment = NSTextAlignmentRight;
        
        _itemCreditsLabel.text = [NSString stringWithFormat:@"$%@.00", _perk[@"credits"]];

        [self.view addSubview:_itemCreditsLabel];
    }
    return _itemCreditsLabel;
}

- (UILabel *)perkDescriptionLabel {
    if (!_perkDescriptionLabel) {
        _perkDescriptionLabel = THLNUILabel(kTHLNUIDetailTitle);
        [_perkDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
        _perkDescriptionLabel.numberOfLines = 0;

        _perkDescriptionLabel.text = _perk[@"info"];

        [self.view addSubview:_perkDescriptionLabel];
    }

    return _perkDescriptionLabel;
}

@end

