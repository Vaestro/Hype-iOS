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
#import "THLActionBarButton.h"

#import "THLAppearanceConstants.h"
//#import "FXBlurView.h"

@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
//@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
//@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) THLActionBarButton *bottomBar;
//@property (nonatomic, strong) FXBlurView *blurView;

@property (nonatomic) BOOL showPromotionInfoView;
@end


@implementation THLEventDetailViewController
@synthesize locationImageURL;
@synthesize promoImageURL;
@synthesize eventName;
@synthesize promoInfo;
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
//    _locationInfoView = [self newLocationInfoView];
//    _mapView = [self newMapView];
    _bottomBar = [self newBottomBar];
}

- (void)showDetailsView:(UIView *)detailView {
    [self.parentViewController.view addSubview:detailView];
    [detailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.insets(kTHLEdgeInsetsNone());
    }];
    [self.parentViewController.view bringSubviewToFront:detailView];
}

- (void)hideDetailsView:(UIView *)detailView {
    [detailView removeFromSuperview];
}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    [self.view addSubviews:@[_scrollView, _bottomBar]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.insets(kTHLEdgeInsetsHigh());
    }];
    
    for (UIView *view in @[_promotionInfoView]) {
        [_scrollView.stackView addSubview:view
                      withPrecedingMargin:2*kTHLPaddingHigh()
                               sideMargin:2*kTHLPaddingHigh()];
        //		[view makeConstraints:^(MASConstraintMaker *make) {
        //			make.left.right.insets(kTHLEdgeInsetsHigh());
        //		}];
        //		prevView = view;
    }
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo(_scrollView.mas_bottom);
    }];
}

//- (void)updateBottomBarText {
//    NSString *barText;
//    if (actionBarButtonStatus == 0) {
//        barText =  @"JOIN A GUESTLIST";
//    } else {
//        barText =  @"VIEW YOUR GUESTLIST";
//    }
//    
//    [_bottomBar.morphingLabel setTextWithoutMorphing:barText];
//}

- (void)bindView {
    WEAKSELF();
    RAC(self.promotionInfoView, promotionInfo) = RACObserve(self, promoInfo);
    RAC(self.promotionInfoView, promoImageURL) = RACObserve(self, promoImageURL);
    
//    RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);
//    
//    RAC(self.mapView, locationName) = RACObserve(self, locationName);
//    RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
//    RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
    
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
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIAccentColor;
            break;
            
        default:
            [[WSELF bottomBar].morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
            [WSELF bottomBar].backgroundColor = kTHLNUIAccentColor;
            break;
    }
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}
//
//- (THLEventDetailsLocationInfoView *)newLocationInfoView {
//    THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
//    infoView.title = NSLocalizedString(@"VENUE DESCRIPTION", nil);
//    infoView.translatesAutoresizingMaskIntoConstraints = NO;
//    infoView.dividerColor = [UIColor whiteColor];
//    return infoView;
//}
//
//- (THLEventDetailsMapView *)newMapView {
//    THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
//    mapView.title = NSLocalizedString(@"ADDRESS", nil);
//    mapView.translatesAutoresizingMaskIntoConstraints = NO;
//    mapView.dividerColor = [UIColor whiteColor];
//    return mapView;
//}

- (THLEventDetailsPromotionInfoView *)newPromotionInfoView {
    THLEventDetailsPromotionInfoView *promoInfoView = [THLEventDetailsPromotionInfoView new];
    promoInfoView.title = NSLocalizedString(@"EVENT DETAILS", nil);
    promoInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    promoInfoView.dividerColor = [UIColor whiteColor];
    return promoInfoView;
}

- (THLActionBarButton *)newBottomBar {
    THLActionBarButton *bottomBar = [THLActionBarButton new];
//    [bottomBar.morphingLabel setTextWithoutMorphing:NSLocalizedString(actionBarButtonStatus, nil)];
    return bottomBar;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
