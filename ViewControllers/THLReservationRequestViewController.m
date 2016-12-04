//
//  THLReservationRequestViewController.m
//  Hype
//
//  Created by Edgar Li on 7/29/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//


#import "THLReservationRequestViewController.h"
#import "Parse.h"
#import "THLAppearanceConstants.h"
#import "SVProgressHUD.h"
#import "THLUser.h"
#import "THLActionButton.h"
#import "Hype-Swift.h"
#import "THLSelectView.h"
#import "THLTablePackageDetailsViewController.h"
#import "THLAdmissionOption.h"
#import "THLCollectionReusableView.h"


@interface THLReservationRequestViewController()
<
THLSelectViewDelegate
>
@property(nonatomic, strong) THLActionButton *checkoutButton;
@property (nonatomic, strong) PFObject *admissionOption;
@property (nonatomic, strong) PFObject *event;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) THLTablePackageDetailsViewController *tablePackageDetailsViewController;

@property (nonatomic, strong) THLSelectView *numberOfPeopleSelectView;
@property (nonatomic, strong) THLSelectView *arrivalTimeSelectView;


@property (nonatomic, strong) UILabel *totalAmountLabel;
@property (nonatomic, strong) UILabel *perPersonAmountLabel;

@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) THLActionButton *continueButton;
@property (nonatomic, strong) THLCollectionReusableView *collectionViewHeader;
@end

@implementation THLReservationRequestViewController


- (instancetype)initWithEvent:(PFObject *)event admissionOption:(PFObject *)admissionOption {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    self.admissionOption = admissionOption;
    self.event = event;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [[THLEventNavBarTitleView alloc] initWithVenueName:_event[@"location"][@"name"] date:_event[@"date"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Help"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    
    WEAKSELF();

    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.checkoutButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.scrollView.mas_bottom);
        make.right.bottom.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.totalAmountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.checkoutButton);
        make.left.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.perPersonAmountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.checkoutButton);
        make.left.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self generateContent];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    self.tablePackageDetailsViewController.view.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 150.0f);
//}

- (void)generateContent {
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    WEAKSELF();
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF.scrollView);
        make.width.equalTo(WSELF.scrollView);
    }];
    
    self.tablePackageDetailsViewController = [[THLTablePackageDetailsViewController alloc] initWithEvent:_event admissionOption:_admissionOption showActionButton:NO];

    [contentView addSubviews:@[self.collectionViewHeader, self.tablePackageDetailsViewController.view, self.numberOfPeopleSelectView, self.arrivalTimeSelectView]];
    
    [self.collectionViewHeader makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.left.right.equalTo(UIEdgeInsetsZero);
    }];
    
    [self.tablePackageDetailsViewController.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.collectionViewHeader.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.equalTo(kTHLEdgeInsetsHigh());
        make.height.equalTo(150.0f);
    }];

    [self.numberOfPeopleSelectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.tablePackageDetailsViewController.view.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(150.0f);
        
    }];

    [self.arrivalTimeSelectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.numberOfPeopleSelectView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(150.0f);
    }];


    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.arrivalTimeSelectView.mas_bottom);
    }];
    
}

- (NSInteger)splitTotalByNumber:(NSInteger)number {
    return [self.admissionOption[@"price"] integerValue] / number;
}

- (THLSelectView *)numberOfPeopleSelectView {
    if (!_numberOfPeopleSelectView) {
        NSMutableArray *people = [NSMutableArray array];
        THLAdmissionOption *admissionOption = (THLAdmissionOption *)self.admissionOption;
        for (NSInteger i = 1; i <=  [admissionOption.partySize integerValue]; i++)
            [people addObject:[[NSNumber numberWithInteger:i] stringValue]];
        _numberOfPeopleSelectView = [[THLSelectView alloc] initWithValues:people];
        _numberOfPeopleSelectView.titleLabel.text = @"Number of people paying for the reservation";
        _numberOfPeopleSelectView.descriptionLabel.text = @"The table will not be reserved until all guests agree to pay";
    }
    return _numberOfPeopleSelectView;
}

- (THLSelectView *)arrivalTimeSelectView {
    if (!_arrivalTimeSelectView) {

        NSMutableArray * timeArray = [NSMutableArray array];
        NSDate *startTime = (NSDate *)self.event[@"date"];
        for( NSUInteger interval = 0; interval < 12; interval++ ){
            if (interval > 0) {
                startTime = [startTime dateByAddingTimeInterval:60*15];
            }
            [timeArray addObject:startTime.thl_timeString];
        }
        
        _arrivalTimeSelectView = [[THLSelectView alloc] initWithValues:timeArray];
        _arrivalTimeSelectView.titleLabel.text = @"What time will you be arriving?";

    }
    return _arrivalTimeSelectView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (THLActionButton *)checkoutButton {
    if (!_checkoutButton) {
        _checkoutButton = [[THLActionButton alloc] initWithDefaultStyle];
        [_checkoutButton setTitle:@"Continue"];
        [self.view addSubview:_checkoutButton];
    }
    return _checkoutButton;
}

- (UILabel *)navBarTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@ \n %@",_event[@"location"][@"name"], ((NSDate *)_event[@"date"]).thl_weekdayString];
    [label sizeToFit];
    return label;
}

- (UILabel *)totalAmountLabel
{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [UILabel new];
        _totalAmountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:36.0];
        _totalAmountLabel.textColor = [UIColor whiteColor];
        _totalAmountLabel.text = [NSString stringWithFormat:@"%li", [self.admissionOption[@"price"] integerValue]];
        [self.view addSubview:_totalAmountLabel];

    }
    return _totalAmountLabel;
}

- (UILabel *)perPersonAmountLabel
{
    if (!_perPersonAmountLabel) {
        _perPersonAmountLabel = [UILabel new];
        _perPersonAmountLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:16.0];
        _perPersonAmountLabel.textColor = [UIColor whiteColor];

        NSInteger perPersonAmount = [self splitTotalByNumber:[self.admissionOption[@"partySize"] integerValue]];
        _perPersonAmountLabel.text = [NSString stringWithFormat:@"%li per person", perPersonAmount];
        [self.view addSubview:_perPersonAmountLabel];

    }
    return _perPersonAmountLabel;
}

- (THLCollectionReusableView *)collectionViewHeader
{
    if (!_collectionViewHeader) {
        _collectionViewHeader = [[THLCollectionReusableView alloc] init];
        _collectionViewHeader.label.text = @"Table package includes";
    }
    return _collectionViewHeader;
}

#pragma mark - Event handlers
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)checkout:(id)sender {
    [self.delegate reservationRequestControllerWantsToPresentReviewForReservation:_event andAdmissionOption:_admissionOption];
}


@end
