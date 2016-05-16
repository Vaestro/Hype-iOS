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

@interface THLCheckoutViewController ()
@property (nonatomic) THLEventEntity *event;
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
}

- (void)constructView
{
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    self.navigationItem.leftBarButtonItem = [self backBarButton];
    self.navigationItem.titleView = [self navBarTitleLabel];
    
    THLActionButton *orderButton = [self completeOrderBar];
    [self.view addSubview:orderButton];
    
    [orderButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.bottom.right.insets(kTHLEdgeInsetsHigh());
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

- (THLActionButton *)completeOrderBar {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"Complete Order"];
    [button addTarget:self action:@selector(charge:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
