//
//  THLCheckoutViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/15/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLCheckoutViewController.h"
#import "THLAppearanceConstants.h"
#import "THLEventEntity.h"
#import "THLLocationEntity.h"
#import "Parse.h"
#import "THLActionButton.h"
#import "THLPurchaseDetailsView.h"

@interface THLCheckoutViewController ()
@property (nonatomic) THLEventEntity *event;
@property (nonatomic, strong) THLActionButton *purchaseButton;
@property (nonatomic, strong) THLPurchaseDetailsView *purchaseDetailsView;

@end

@implementation THLCheckoutViewController


#pragma mark - Life cycle

- (id)initWithEvent:(THLEventEntity *)event
{
    if (self = [super init]) {
        self.event = event;
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
    
    [_purchaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.bottom.right.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_purchaseDetailsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
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
    [button addTarget:self action:@selector(charge:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (THLPurchaseDetailsView *)newPurchaseDetailsView {
    THLPurchaseDetailsView *purchaseDetailsView = [THLPurchaseDetailsView new];
    purchaseDetailsView.title = NSLocalizedString(@"Purchase Details",@"Purchase Details");
    return purchaseDetailsView;
}





#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)charge:(id)sender
{
    
}




@end
