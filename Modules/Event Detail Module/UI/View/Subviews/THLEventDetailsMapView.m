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
@property (nonatomic, strong) UITextView *textView;
@end

@implementation THLEventDetailsMapView

- (void)constructView {
    [super constructView];
    _mapView = [self newMapView];
    _textView = [self newTextView];
}

- (void)layoutView {
    [super layoutView];
    [self.contentView addSubviews:@[_mapView,
                                    _textView]];
    
    WEAKSELF();
    [_mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsNone());
        make.left.right.equalTo(kTHLEdgeInsetsLow());
//        make.height.equalTo(_mapView.mas_width).dividedBy(kTHLGoldenRatio);
        make.height.equalTo([WSELF mapView].mas_width).dividedBy(3);
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF mapView].mas_bottom).insets(kTHLEdgeInsetsLow());
    }];
}

- (void)bindView {
    WEAKSELF();
    [super bindView];
    
//    [RACObserve(self, locationAddress) subscribeNext:^(id x) {
//        
//    }];
    
    RAC(self.textView, text) = RACObserve(self, locationAddress);
    
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
- (MKMapView *)newMapView {
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.clipsToBounds = YES;
    mapView.userInteractionEnabled = NO;
    return mapView;
}

- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.tintColor = kTHLNUIPrimaryFontColor;
    return textView;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
