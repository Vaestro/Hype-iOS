//
//  THLEventDetailViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailViewController.h"
#import "ORStackScrollView.h"

//Subviews
#import "THLEventDetailsLocationInfoView.h"
#import "THLEventDetailsMapView.h"
#import "THLEventDetailsPromotionInfoView.h"
#import "THLNeedToKnowInfoView.h"

#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"
#import "THLEventDetailMusicTypesView.h"
#import "THLEventNavigationBar.h"
#import "SquareCashStyleBehaviorDefiner.h"
#import "THLActionButton.h"
#import "THLAlertView.h"
#import "THLUser.h"
#import "THLCheckoutViewController.h"


@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
@property (nonatomic, strong) THLNeedToKnowInfoView *needToKnowInfoView;
@property (nonatomic, strong) THLEventDetailMusicTypesView *musicTypesView;
@property (nonatomic, strong) THLActionButton *bottomBar;
@property (nonatomic) BOOL showPromotionInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventNavigationBar *navBar;

@end

@implementation THLEventDetailViewController
@synthesize titleText;
@synthesize locationImageURL;
@synthesize promoImageURL;
@synthesize event;
@synthesize eventName;
@synthesize eventDate;
@synthesize promoInfo;
@synthesize ratioInfo;
@synthesize coverInfo;
@synthesize locationName;
@synthesize locationInfo;
@synthesize locationAddress;
@synthesize locationAttireRequirement;
@synthesize ageRequirement;
@synthesize locationMusicTypes;
@synthesize dismissCommand;
@synthesize locationPlacemark;
@synthesize userHasAcceptedInvite;
@synthesize viewAppeared;
@synthesize exclusiveEvent;
@synthesize actionBarButtonCommand;

#pragma mark VC Lifecycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewAppeared = TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = FALSE;
}


- (void)showAlertView {
    THLAlertView *alertView = [THLAlertView new];
    [alertView setTitle:@"What's Next?"];
    [alertView setMessage:@"Please arrive on time and show your ticket at the door for entrance. Your ticket + guestlist can always be found in the 'My Events' tab. If you have any questions, you can contact the concierge anytime in your messages"];
    
    [self.view addSubview:alertView];
    [self.view bringSubviewToFront:alertView];
    [alertView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}


- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    Gradient on Event Nav Bar needs to be set after views are subviews are laid out
    [_navBar addGradientLayer];
}
- (void)constructView {
    _scrollView = [self newScrollView];
//    _promotionInfoView = [self newPromotionInfoView];
    _needToKnowInfoView = [self newNeedToKnowInfoView];
    _locationInfoView = [self newLocationInfoView];
    _eventNameLabel = [self newEventNameLabel];
    _dateLabel = [self newDateLabel];
    _bottomBar = [self newBottomBar];
    _mapView = [self newMapView];
    _musicTypesView = [self newMusicTypesView];
}

- (void)layoutView {
    _navBar = [[THLEventNavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SCREEN_HEIGHT-80)];
    _navBar.minimumBarHeight = 65;
    _navBar.behaviorDefiner = [SquareCashStyleBehaviorDefiner new];
    
    self.scrollView.delegate = (id<UIScrollViewDelegate>)_navBar.behaviorDefiner;

    [self.view addSubview:_navBar];
    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    [self.view addSubviews:@[_scrollView, _bottomBar]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_scrollView.stackView addSubview:_locationInfoView
                  withPrecedingMargin:_navBar.frame.size.height + 2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];

    [_scrollView.stackView addSubview:_musicTypesView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_mapView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_scrollView.stackView addSubview:_needToKnowInfoView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [self.view bringSubviewToFront:_navBar];
    
    UIView *buttonBackground = [UIView new];
    buttonBackground.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    [self.view addSubview:buttonBackground];
    WEAKSELF();
    [buttonBackground makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(WSELF.scrollView.mas_bottom);
        make.height.equalTo(80);
    }];
    
    [buttonBackground addSubview:_bottomBar];
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.navBar, dateText) = RACObserve(self, eventDate);
    RAC(self.navBar, titleText) = RACObserve(self, titleText);
    RAC(self.navBar, dismissCommand) = RACObserve(self, dismissCommand);
    RAC(self.navBar, locationImageURL) = RACObserve(self, locationImageURL);
    RAC(self.navBar, promotionInfo) = RACObserve(self, promoInfo);
    if (eventName != nil) [self.navBar setEventName:eventName];
    if (exclusiveEvent) [self.navBar setExclusiveEventLabel];
    [self.navBar setLocationImageURL:promoImageURL];

    RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);

    if (ratioInfo != nil) self.needToKnowInfoView.ratioText = ratioInfo;
    RAC(self.needToKnowInfoView, coverFeeText) = RACObserve(self, coverInfo);
    RAC(self.needToKnowInfoView, attireRequirement) = RACObserve(self, locationAttireRequirement);
    RAC(self.needToKnowInfoView, ageRequirement) = RACObserve(self, ageRequirement);

    RAC(self.musicTypesView, musicTypesInfo) = RACObserve(self, locationMusicTypes);

    RAC(self.mapView, locationName) = RACObserve(self, locationName);
    RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
    RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
    
    [RACObserve(self, locationInfo) subscribeNext:^(NSString *info) {
        if ([info length] <= 117) {
            [WSELF.locationInfoView hideReadMoreTextButton];
        }
    }];
    
    [RACObserve(WSELF, userHasAcceptedInvite) subscribeNext:^(id _) {
        [WSELF updateBottomBar];
    }];
    
    RAC(self.bottomBar, rac_command) = RACObserve(self, actionBarButtonCommand);
}

- (void)updateBottomBar {
    WEAKSELF();
    if (userHasAcceptedInvite) {
        [[WSELF bottomBar] setTitle:NSLocalizedString(@"You are on the list", nil)];
        [WSELF bottomBar].backgroundColor = kTHLNUIAccentColor;
    } else {
        [[WSELF bottomBar] setTitle:NSLocalizedString(@"Go", nil)];
    }
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (THLEventDetailsPromotionInfoView *)newPromotionInfoView {
    THLEventDetailsPromotionInfoView *promoInfoView = [THLEventDetailsPromotionInfoView new];
    promoInfoView.title = NSLocalizedString(@"EVENT DETAILS", nil);
    promoInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    return promoInfoView;
}

- (THLNeedToKnowInfoView *)newNeedToKnowInfoView {
    THLNeedToKnowInfoView *needToKnowInfoView = [THLNeedToKnowInfoView new];
    needToKnowInfoView.title = NSLocalizedString(@"NEED TO KNOW", nil);
    needToKnowInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    return needToKnowInfoView;
}

- (THLEventDetailsLocationInfoView *)newLocationInfoView {
    THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
    infoView.title = NSLocalizedString(@"WHAT WE LIKE", nil);
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    return infoView;
}

- (THLEventDetailMusicTypesView *)newMusicTypesView {
    THLEventDetailMusicTypesView *musicTypesView = [THLEventDetailMusicTypesView new];
    musicTypesView.title = NSLocalizedString(@"MUSIC", nil);
    musicTypesView.translatesAutoresizingMaskIntoConstraints = NO;
    return musicTypesView;
}

- (THLActionButton *)newBottomBar {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"GO"];
//    [button addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)newEventNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    return label;
}

- (UILabel *)newDateLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.alpha = 0.67;
    return label;
}

- (THLEventDetailsMapView *)newMapView
{
    THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    return mapView;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Event handlers

-(void)showCheckoutView:(UIViewController *)checkoutView
{
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutView];
    [self presentViewController:navVC animated:YES completion:nil];
}


@end
