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
        make.top.equalTo(kTHLEdgeInsetsNone());
        make.left.right.equalTo(kTHLEdgeInsetsLow());
//        make.height.equalTo(_mapView.mas_width).dividedBy(kTHLGoldenRatio);
        make.height.equalTo([WSELF mapView].mas_width).dividedBy(3);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF mapView].mas_bottom).insets(kTHLEdgeInsetsLow());
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
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.clipsToBounds = YES;
        _mapView.userInteractionEnabled = NO;
        [self addSubview:_mapView];
    }
    return _mapView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = THLNUITextView(kTHLNUIDetailTitle);
        [_textView setScrollEnabled:NO];
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        _textView.tintColor = kTHLNUIPrimaryFontColor;
        [self addSubview:_textView];
    }

    return _textView;
}
@end
