//
//  THLEventDetailsMapView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailsMapView.h"
#import "THLAppearanceConstants.h"
@import MapKit;

static CGFloat MAPVIEW_METERS = 1000;

@interface THLEventDetailsMapView()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation THLEventDetailsMapView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutView];
        [self bindView];
    }
    return self;
}


- (void)layoutView {
    WEAKSELF();
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(kTHLEdgeInsetsNone());
        make.left.right.equalTo(kTHLEdgeInsetsLow());
//        make.height.equalTo(_mapView.mas_width).dividedBy(kTHLGoldenRatio);
        make.height.equalTo([WSELF mapView].mas_width).dividedBy(3);
    }];
    
    [self.overlayView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF.mapView);
    }];
    [self.venueNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.mapView.mas_centerY).insets(kTHLEdgeInsetsLow());
        make.left.equalTo(WSELF.mapView).insets(kTHLEdgeInsetsSuperHigh());
        make.right.equalTo(WSELF.mapView);
    }];
    
    [self.addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.mapView.mas_centerY).insets(kTHLEdgeInsetsLow());
        make.left.equalTo(WSELF.venueNameLabel);
        make.right.equalTo(WSELF.mapView);
    }];
}

- (void)bindView {
    WEAKSELF();
    
    [[RACObserve(self, locationPlacemark) filter:^BOOL(id value) {
        return value != nil;
    }] subscribeNext:^(id x) {
        [WSELF displayPlacemark:(CLPlacemark *)x];
    }];
}

- (void)displayPlacemark:(CLPlacemark *)placemark {
    MKPlacemark *locationPlacemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
    [_mapView addAnnotation:locationPlacemark];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(locationPlacemark.coordinate, MAPVIEW_METERS, MAPVIEW_METERS) animated:NO];
}

#pragma mark - Constructors
- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] init];
        _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];

        [self addSubview:_overlayView];
    }
    return _overlayView;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.clipsToBounds = YES;
        _mapView.userInteractionEnabled = NO;
        [self addSubview:_mapView];
    }
    return _mapView;
}

- (UILabel *)venueNameLabel {
    if (!_venueNameLabel) {
        _venueNameLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _venueNameLabel.numberOfLines = 1;
        [self addSubview:_venueNameLabel];
    }
    
    return _venueNameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = THLNUILabel(kTHLNUIDetailTitle);
        _addressLabel.numberOfLines = 1;
        [self addSubview:_addressLabel];
    }

    return _addressLabel;
}
@end
