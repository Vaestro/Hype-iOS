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

@interface THLEventDetailViewController()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) THLEventDetailsLocationInfoView *locationInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventDetailsPromotionInfoView *promotionInfoView;
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

- (void)viewDidLoad {
	[super viewDidLoad];
	[self constructView];
	[self layoutView];
	[self bindView];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)constructView {
	_scrollView = [self newScrollView];
	_promotionInfoView = [self newPromotionInfoView];
	_locationInfoView = [self newLocationInfoView];
	_mapView = [self newMapView];
}

- (void)layoutView {
	self.view.nuiClass = kTHLNUIBackgroundView;

	[self.view addSubviews:@[_scrollView]];
	[_scrollView makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.insets(kTHLEdgeInsetsHigh());
		make.top.bottom.insets(kTHLEdgeInsetsNone());
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
}

- (void)bindView {
	RAC(self.promotionInfoView, promotionInfo) = [RACObserve(self, promoInfo) map:^id(NSString *value) {
		if (value.length) {
			return value;
		} else {
			return @"No info";
		}
	}];

	RAC(self.promotionInfoView, promoImageURL) = RACObserve(self, promoImageURL);

	RAC(self.locationInfoView, locationInfo) = RACObserve(self, locationInfo);

	RAC(self.mapView, locationName) = RACObserve(self, locationName);
	RAC(self.mapView, locationAddress) = RACObserve(self, locationAddress);
	RAC(self.mapView, locationPlacemark) = RACObserve(self, locationPlacemark);
}

#pragma mark - Constructors
- (ORStackScrollView *)newScrollView {
	ORStackScrollView *scrollView = [ORStackScrollView new];
	scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
	return scrollView;
}

- (THLEventDetailsLocationInfoView *)newLocationInfoView {
	THLEventDetailsLocationInfoView *infoView = [THLEventDetailsLocationInfoView new];
	infoView.title = NSLocalizedString(@"VENUE", nil);
	infoView.translatesAutoresizingMaskIntoConstraints = NO;
	return infoView;
}

- (THLEventDetailsMapView *)newMapView {
	THLEventDetailsMapView *mapView = [THLEventDetailsMapView new];
	mapView.title = NSLocalizedString(@"ADDRESS", nil);
	mapView.translatesAutoresizingMaskIntoConstraints = NO;
	return mapView;
}

- (THLEventDetailsPromotionInfoView *)newPromotionInfoView {
	THLEventDetailsPromotionInfoView *promoInfoView = [THLEventDetailsPromotionInfoView new];
	promoInfoView.title = NSLocalizedString(@"DETAILS", nil);
	promoInfoView.translatesAutoresizingMaskIntoConstraints = NO;
	return promoInfoView;
}
@end
