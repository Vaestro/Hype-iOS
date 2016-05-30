//
//  THLEventDetailsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventDetailsViewController.h"
#import "ORStackScrollView.h"
#import "Parse.h"
//Subviews
#import "THLEventDetailsLocationInfoView.h"
#import "THLEventDetailsMapView.h"
#import "THLEventDetailsPromotionInfoView.h"
#import "THLNeedToKnowInfoView.h"

#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"
#import "THLEventDetailMusicTypesView.h"
#import "THLEventNavigationBar.h"
#import "THLActionButton.h"
#import "THLAlertView.h"
#import "THLUser.h"
#import "THLCheckoutViewController.h"


@interface THLEventDetailsViewController ()
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
@property (nonatomic) PFObject *event;
@property (nonatomic) BOOL showNavigationBar;
@property (nonatomic, strong) UIImageView *eventImageView;

@end

@implementation THLEventDetailsViewController


#pragma mark - Life cycle

- (id)initWithEvent:(PFObject *)event andShowNavigationBar:(BOOL)showNavigationBar {
    if (self = [super init]) {
        self.event = event;
        _showNavigationBar = showNavigationBar;
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    if (_showNavigationBar == TRUE) {
        self.scrollView.delegate = (id<UIScrollViewDelegate>)self.navBar.behaviorDefiner;
        
        [self.scrollView.stackView addSubview:self.locationInfoView
                          withPrecedingMargin:self.navBar.frame.size.height + 2*kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
    } else {
        [self.scrollView.stackView addSubview:self.eventImageView
                          withPrecedingMargin:2*kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
        
        [self.scrollView.stackView addSubview:self.locationInfoView
                          withPrecedingMargin:kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
    }

    [self.scrollView.stackView addSubview:self.musicTypesView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [self.scrollView.stackView addSubview:self.mapView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [self.scrollView.stackView addSubview:self.needToKnowInfoView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    UIView *buttonBackground = [UIView new];
    buttonBackground.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    [self.view addSubview:buttonBackground];
    
    WEAKSELF();
    [buttonBackground makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(WSELF.scrollView.mas_bottom);
        make.height.equalTo(80);
    }];
    
    [buttonBackground addSubview:self.bottomBar];
    [self.bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(kTHLEdgeInsetsHigh());
    }];
    
}


- (void)viewDidLayoutSubviews
{
    //    [super viewDidLayoutSubviews]
    [self.navBar addGradientLayer];
}


#pragma mark -
#pragma mark Accessors

- (THLEventNavigationBar *)navBar
{
    if (!_navBar && _showNavigationBar) {
        _navBar = [[THLEventNavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SCREEN_HEIGHT - 80)];
        _navBar.titleLabel.text = _event[@"location"][@"name"];
        _navBar.dateLabel.text = [NSString stringWithFormat:@"%@, %@", ((NSDate *)_event[@"date"]).thl_weekdayString, ((NSDate *)_event[@"date"]).thl_timeString];
        [_navBar.dismissButton addTarget:self
                     action:@selector(dismissCommand)
          forControlEvents:UIControlEventTouchUpInside];
        if (_event[@"promoImage"]) {
            _navBar.locationImageURL = [NSURL URLWithString:((PFFile *)_event[@"promoImage"]).url];
        } else {
            _navBar.locationImageURL =  [NSURL URLWithString:((PFFile *)_event[@"location"][@"image"]).url];
        }
        if (_event[@"title"] != nil) [_navBar.titleLabel setText:_event[@"title"]];
        [self.view addSubview:_navBar];
        [self.view bringSubviewToFront:_navBar];
    }
    return _navBar;
}


- (ORStackScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [ORStackScrollView new];
        _scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (THLEventDetailsPromotionInfoView *)promotionInfoView
{
    if (!_promotionInfoView) {
        _promotionInfoView = [THLEventDetailsPromotionInfoView new];
        _promotionInfoView.title = NSLocalizedString(@"EVENT DETAILS", nil);
        _promotionInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _promotionInfoView;
}

- (THLNeedToKnowInfoView *)needToKnowInfoView
{
    if (!_needToKnowInfoView) {
        _needToKnowInfoView = [THLNeedToKnowInfoView new];
        _needToKnowInfoView.title = NSLocalizedString(@"NEED TO KNOW", nil);
        _needToKnowInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _needToKnowInfoView;
}

- (THLEventDetailsLocationInfoView *)locationInfoView
{
    
    if (!_locationInfoView) {
        _locationInfoView = [THLEventDetailsLocationInfoView new];
        _locationInfoView.locationInfo = _event[@"location"][@"info"];
        if ([(NSString *)_event[@"location"][@"info"] length] <= 117) [_locationInfoView hideReadMoreTextButton];
        _locationInfoView.title = NSLocalizedString(@"WHAT WE LIKE", nil);
        _locationInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _locationInfoView;
}

- (UIImageView *)eventImageView {
    if (!_eventImageView) {
        _eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _eventImageView.contentMode = UIViewContentModeScaleAspectFill;
        _eventImageView.clipsToBounds = YES;
        [_eventImageView sd_setImageWithURL:[NSURL URLWithString:((PFFile *)_event[@"location"][@"image"]).url]];
        _eventImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_eventImageView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(150);
        }];
    }
    return _eventImageView;
}

- (THLEventDetailMusicTypesView *)musicTypesView
{
    if (!_musicTypesView) {
        _musicTypesView = [THLEventDetailMusicTypesView new];
        _musicTypesView.title = NSLocalizedString(@"MUSIC", nil);
        _musicTypesView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _musicTypesView;
}

- (THLActionButton *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[THLActionButton alloc] initWithInverseStyle];
        [_bottomBar setTitle:@"GO"];
        [self.view addSubview:_bottomBar];
    }
    //    [button addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
    return _bottomBar;
}


- (UILabel *)eventNameLabel
{
    if (!_eventNameLabel) {
        _eventNameLabel = THLNUILabel(kTHLNUIRegularTitle);
    }
    return _eventNameLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = THLNUILabel(kTHLNUIRegularTitle);
        _dateLabel.alpha = 0.67;
    }
    return _dateLabel;
}

- (THLEventDetailsMapView *)mapView
{
    if (!_mapView) {
        _mapView = [THLEventDetailsMapView new];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mapView;
}


- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - event handlers ()

- (void)dismissCommand
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
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

@end