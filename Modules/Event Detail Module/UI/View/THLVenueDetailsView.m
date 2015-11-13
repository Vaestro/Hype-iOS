//
//  THLVenueDetailsView.m
//  TheHypelist
//
//  Created by Edgar Li on 11/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLVenueDetailsView.h"
#import "THLEventDetailsLocationInfoView.h"
#import "THLEventDetailsMapView.h"
#import "ORStackScrollView.h"
#import "THLAppearanceConstants.h"

static CGRect const kTHLEventNavigationBarDismissButtonFrame = {{33,33},{33,33}};

@interface THLVenueDetailsView()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *locationNameLabel;

@end

@implementation THLVenueDetailsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)constructView {
    _scrollView = [self newScrollView];
    _locationNameLabel = [self newLocationNameLabel];
    _locationInfoView = [self newLocationInfoView];
    _mapView = [self newMapView];
    _dismissButton = [self newDismissButton];
    self.tintColor = [UIColor clearColor];
}

- (void)layoutView {
    [self addSubviews:@[_scrollView, _dismissButton]];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_scrollView.stackView addSubview:_locationNameLabel
                  withPrecedingMargin:50
                           sideMargin:2*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_locationInfoView
                  withPrecedingMargin:25
                           sideMargin:2*kTHLPaddingHigh()];
    
    [_scrollView.stackView addSubview:_mapView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:2*kTHLPaddingHigh()];
    WEAKSELF();
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF scrollView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.offset(0);
    }];
}

- (void)bindView {
//    WEAKSELF();
//    RAC(self.promotionInfoView, promoImageURL) = RACObserve(self, promoImageURL);
    RAC(self.locationNameLabel, text) = RACObserve(self, locationName);

    RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);
    
    
    RAC(self.mapView, locationName) = RACObserve(self, locationName);
    RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
    RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
    
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
    ORStackScrollView *scrollView = [ORStackScrollView new];
    scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
    return scrollView;
}

- (UILabel *)newLocationNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (THLEventDetailsLocationInfoView *)newLocationInfoView {
    THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
//    infoView.title = NSLocalizedString(@"VENUE DESCRIPTION", nil);
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    infoView.dividerColor = [UIColor whiteColor];
    return infoView;
}

- (THLEventDetailsMapView *)newMapView {
    THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
//    mapView.title = NSLocalizedString(@"ADDRESS", nil);
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
//    mapView.dividerColor = [UIColor whiteColor];
    return mapView;
}

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc]initWithFrame:kTHLEventNavigationBarDismissButtonFrame];
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
    return button;
}
@end
