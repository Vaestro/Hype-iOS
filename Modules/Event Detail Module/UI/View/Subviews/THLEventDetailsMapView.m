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

	[_mapView makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(kTHLEdgeInsetsNone());
		make.height.equalTo(_mapView.mas_width).dividedBy(kTHLGoldenRatio);
	}];

	[_textView makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.insets(kTHLEdgeInsetsNone());
		make.top.equalTo(_mapView.mas_bottom).insets(kTHLEdgeInsetsLow());
	}];
}

- (void)bindView {
	[super bindView];

	[RACObserve(self, locationAddress) subscribeNext:^(id x) {

	}];

	RAC(self.textView, text) = RACObserve(self, locationAddress);
}

#pragma mark - Constructors
- (MKMapView *)newMapView {
	MKMapView *mapView = [[MKMapView alloc] init];
	return mapView;
}

- (UITextView *)newTextView {
	UITextView *textView = THLNUITextView(kTHLNUIUndef);
	[textView setScrollEnabled:NO];
	return textView;
}
@end
