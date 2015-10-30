//
//  THLEventDetailViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailViewController.h"
#import "ORStackScrollView.h"
#import "THLAppearanceConstants.h"

#import "THLEventDetailsLocationInfoView.h"
#import "THLEventDetailsMapView.h"
#import "THLEventDetailsPromotionInfoView.h"
#import "THLActionBarButton.h"

@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
@property (nonatomic, strong) THLActionBarButton *bottomBar;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self updateBottomBarText];

}

- (void)constructView {
    _scrollView = [self newScrollView];
    _promotionInfoView = [self newPromotionInfoView];
    _locationInfoView = [self newLocationInfoView];
    _mapView = [self newMapView];
    _bottomBar = [self newBottomBar];
}

- (void)layoutView {
    self.view.nuiClass = kTHLNUIBackgroundView;
    
    [self.view addSubviews:@[_scrollView, _bottomBar]];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.top.insets(kTHLEdgeInsetsHigh());
    }];
    
    for (UIView *view in @[_promotionInfoView,
                           _locationInfoView,
                           _mapView]) {
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
    
    RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);
    
    RAC(self.mapView, locationName) = RACObserve(self, locationName);
    RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
    RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
//    RAC(self, bottomBar) = RACObserve(self, actionBarButtonStatus);
    [RACObserve(WSELF, actionBarButtonStatus) subscribeNext:^(NSNumber *val) {
        BOOL guestlistStatus = [val boolValue];
        if (guestlistStatus) {
            [_bottomBar.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"VIEW YOUR GUESTLIST", nil)];
        } else {
            [_bottomBar.morphingLabel setTextWithoutMorphing:NSLocalizedString(@"CREATE A GUESTLIST", nil)];
        }
    }];
    RAC(self.bottomBar, rac_command) = RACObserve(self, actionBarButtonCommand);

}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (THLEventDetailsLocationInfoView *)newLocationInfoView {
    THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
    infoView.title = NSLocalizedString(@"VENUE DESCRIPTION", nil);
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    infoView.dividerColor = [UIColor whiteColor];
    return infoView;
}

- (THLEventDetailsMapView *)newMapView {
    THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
    mapView.title = NSLocalizedString(@"ADDRESS", nil);
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    mapView.dividerColor = [UIColor whiteColor];
    return mapView;
}

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
@end
