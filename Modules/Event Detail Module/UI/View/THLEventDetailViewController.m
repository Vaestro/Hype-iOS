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
#import "THLActionBarButton.h"

#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"

@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
@property (nonatomic, strong) THLNeedToKnowInfoView *needToKnowInfoView;
@property (nonatomic, strong) THLActionBarButton *bottomBar;
@property (nonatomic) BOOL showPromotionInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;

@end

@implementation THLEventDetailViewController
@synthesize locationImageURL;
@synthesize promoImageURL;
@synthesize eventName;
@synthesize eventDate;
@synthesize promoInfo;
@synthesize ratioInfo;
@synthesize coverInfo;
@synthesize locationName;
@synthesize locationInfo;
@synthesize locationAddress;
@synthesize dismissCommand;
@synthesize locationPlacemark;
@synthesize actionBarButtonStatus;
@synthesize actionBarButtonCommand;
@synthesize viewAppeared;

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

- (void)constructView {
    _scrollView = [self newScrollView];
    _promotionInfoView = [self newPromotionInfoView];
    _needToKnowInfoView = [self newNeedToKnowInfoView];
    _locationInfoView = [self newLocationInfoView];
    _eventNameLabel = [self newEventNameLabel];
    _dateLabel = [self newDateLabel];
    _bottomBar = [self newBottomBar];
    _mapView = [self newMapView];

}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView, _bottomBar]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.top.insets(kTHLEdgeInsetsHigh());
    }];
    
    [_scrollView.stackView addSubview:_eventNameLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_dateLabel
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_promotionInfoView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_needToKnowInfoView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_locationInfoView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_mapView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(_scrollView.mas_bottom);
    }];
}

- (void)bindView {
    WEAKSELF();
    RAC(self.eventNameLabel, text, @"") = RACObserve(self, eventName);
    RAC(self.dateLabel, text, @"") = RACObserve(self, eventDate);
    
    RAC(self.promotionInfoView, promotionInfo) = RACObserve(self, promoInfo);
    RAC(self.promotionInfoView, promoImageURL) = RACObserve(self, promoImageURL);
    RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);

    RAC(self.needToKnowInfoView, ratioText) = RACObserve(self, ratioInfo);
    RAC(self.needToKnowInfoView, coverFeeText) = RACObserve(self, coverInfo);
    
    RAC(self.mapView, locationName) = RACObserve(self, locationName);
    RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
    RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
    
    [RACObserve(WSELF, actionBarButtonStatus) subscribeNext:^(id _) {
        [WSELF updateBottomBar];
    }];
    
    RAC(self.bottomBar, rac_command) = RACObserve(self, actionBarButtonCommand);
}

- (void)updateBottomBar {
    WEAKSELF();
    switch (actionBarButtonStatus) {
        case THLGuestlistStatusPendingInvite:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        case THLGuestlistStatusPendingHost:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW PENDING GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        case THLGuestlistStatusAccepted:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW YOUR GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIAccentColor;
            break;
            
        case THLGuestlistStatusDeclined:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"Declined Guestlist", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIRedColor;
            break;
        
        case THLGuestlistStatusUnavailable:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"UNAVAILABLE", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIPendingColor;
            break;
            
        default:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIActionColor;
            break;
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
    promoInfoView.dividerColor = [UIColor whiteColor];
    return promoInfoView;
}

- (THLNeedToKnowInfoView *)newNeedToKnowInfoView {
    THLNeedToKnowInfoView *needToKnowInfoView = [THLNeedToKnowInfoView new];
    needToKnowInfoView.title = NSLocalizedString(@"NEED TO KNOW", nil);
    needToKnowInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    needToKnowInfoView.dividerColor = [UIColor whiteColor];
    return needToKnowInfoView;
}

- (THLEventDetailsLocationInfoView *)newLocationInfoView {
    THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
    infoView.title = NSLocalizedString(@"WHY WE LIKE IT", nil);
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    infoView.dividerColor = [UIColor whiteColor];
    return infoView;
}

- (THLActionBarButton *)newBottomBar {
    THLActionBarButton *bottomBar = [THLActionBarButton new];
//    [bottomBar.morphingLabel setTextWithoutMorphing:NSLocalizedString(actionBarButtonStatus, nil)];
    return bottomBar;
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

- (THLEventDetailsMapView *)newMapView {
    THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
    //    mapView.title = NSLocalizedString(@"ADDRESS", nil);
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    //    mapView.dividerColor = [UIColor whiteColor];
    return mapView;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
