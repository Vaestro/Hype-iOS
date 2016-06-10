//
//  THLTableReservationViewController.m
//  Hype
//
//  Created by Edgar Li on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTableReservationViewController.h"
#import "THLTablePackageDetailsViewController.h"
#import "THLAppearanceConstants.h"
#import "THLGuestlistInvite.h"
#import "THLPurchaseDetailsView.h"

@interface THLTableReservationViewController()<THLTablePackageControllerDelegate>
@property (nonatomic, strong) THLTablePackageDetailsViewController *tablePackageDetailsViewController;
@property (nonatomic, strong) THLPurchaseDetailsView *purchaseDetailsView;

@property (nonatomic) PFObject *guestlistInvite;
@property (nonatomic) PFObject *admissionOption;

@property (nonatomic) PFObject *event;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *instructionsLabel;

@end

@implementation THLTableReservationViewController
- (instancetype)initWithGuestlistInvite:(PFObject *)guestlistInvite {
    self = [super init];
    if (!self) return nil;

    self.guestlistInvite = guestlistInvite;
    PFObject *guestlist = _guestlistInvite[@"Guestlist"];
    self.admissionOption = guestlist[@"admissionOption"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    
    _tablePackageDetailsViewController = [[THLTablePackageDetailsViewController alloc] initWithEvent:_guestlistInvite[@"event"] admissionOption:_admissionOption showActionButton:NO];
//    _tablePackageDetailsViewController.pullToRefreshEnabled = NO;
    _tablePackageDetailsViewController.delegate = self;
    
    
    WEAKSELF();
    [self.instructionsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.view addSubview:_tablePackageDetailsViewController.view];
    
    [_tablePackageDetailsViewController.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.instructionsLabel.mas_bottom);
        make.left.right.bottom.equalTo(UIEdgeInsetsZero);
    }];
    
}

- (UILabel *)instructionsLabel
{
    if (!_instructionsLabel) {
        _instructionsLabel = [UILabel new];
        _instructionsLabel.text = [NSString stringWithFormat:@"When you arrive at the venue, tell them you have a table reservation under %@", [THLUser currentUser].firstName];
        _instructionsLabel.textColor = kTHLNUIAccentColor;
        _instructionsLabel.numberOfLines = 0;
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.view addSubview:_instructionsLabel];
    
    return _instructionsLabel;
}

- (THLPurchaseDetailsView *)purchaseDetailsView {
    if (!_purchaseDetailsView) {
        _purchaseDetailsView = [THLPurchaseDetailsView new];
        _purchaseDetailsView.titleLabel.text = @"Purchase Details";
        
        NSString *purchaseTitleText = _admissionOption[@"name"];
        
        if ([_admissionOption[@"price"] floatValue] > 0) {
            _purchaseDetailsView.purchaseTitleLabel.text = purchaseTitleText;
//            _purchaseDetailsView.subtotalLabel.text = [NSString stringWithFormat:@"$%.2f", _subTotal];
//            _purchaseDetailsView.serviceChargeLabel.text = [NSString stringWithFormat:@"$%.2f", _serviceCharge];
//            _purchaseDetailsView.totalLabel.text = [NSString stringWithFormat:@"$%.2f", _total];
        } else {
            _purchaseDetailsView.purchaseTitleLabel.text = purchaseTitleText;
            _purchaseDetailsView.subtotalLabel.text = @"FREE";
            _purchaseDetailsView.serviceChargeLabel.text = @"FREE";
            _purchaseDetailsView.totalLabel.text = @"FREE";
        }
    }
    
    return _purchaseDetailsView;
}
@end
