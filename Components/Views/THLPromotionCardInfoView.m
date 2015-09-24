//
//  THLPromotionCardInfoView.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionCardInfoView.h"

#import "THLPromotionCardInfoCell.h"
#import "ORStackViewController.h"
#import "THLAppearanceConstants.h"

@interface THLPromotionCardInfoView()
@property (nonatomic, strong) ORStackView *stackView;

@property (nonatomic, strong) THLPromotionCardInfoCell *arrivalTimeCell;
@property (nonatomic, strong) THLPromotionCardInfoCell *guestlistSpaceCell;
@property (nonatomic, strong) THLPromotionCardInfoCell *coverChargeCell;
@property (nonatomic, strong) THLPromotionCardInfoCell *recommendedRatioCell;
@end

@implementation THLPromotionCardInfoView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self constructView];
		[self layoutView];
		[self bindView];
	}
	return self;
}

- (void)constructView {
	_arrivalTimeCell = [self newArrivalTimeCell];
	_guestlistSpaceCell = [self newGuestlistSpaceCell];
	_coverChargeCell = [self newCoverChargeCell];
	_recommendedRatioCell = [self newRecommendedRatioCell];

	_stackView = [ORStackView new];
	for (UIView *cell in @[_arrivalTimeCell, _guestlistSpaceCell, _coverChargeCell, _recommendedRatioCell]) {
		[_stackView addSubview:cell withPrecedingMargin:kTHLEdgeInsetsLow().top];
	}
}

- (void)layoutView {
	[self addSubview:_stackView];
	[_stackView makeConstraints:^(MASConstraintMaker *make) {
		make.edges.insets(kTHLEdgeInsetsNone());
	}];
}

- (void)bindView {
	RAC(self.arrivalTimeCell, detail) = [RACObserve(self, arrivalTime) map:^id(id value) {
		return value;
	}];

	RAC(self.guestlistSpaceCell, detail) = [RACObserve(self, guestlistSpace) map:^id(id value) {
		return value;
	}];

	RAC(self.coverChargeCell, detail) = [RACObserve(self, coverCharge) map:^id(id value) {
		return [NSString stringWithFormat:@"$%d", [value intValue]];
	}];

	RAC(self.guestlistSpaceCell, detail) = [RACObserve(self, guestlistSpace) map:^id(id value) {
		return [NSString stringWithFormat:@"1 Guy: %d Girls", [value intValue]];
	}];
}

#pragma mark - Constructors
- (THLPromotionCardInfoCell *)newArrivalTimeCell {
	THLPromotionCardInfoCell *cell = [THLPromotionCardInfoCell new];
	cell.title = NSLocalizedString(@"Suggested Time of Arrival", nil);
	cell.icon = nil;
	cell.tag = 1;
	return cell;
}

- (THLPromotionCardInfoCell *)newGuestlistSpaceCell {
	THLPromotionCardInfoCell *cell = [THLPromotionCardInfoCell new];
	cell.title =  NSLocalizedString(@"Space on Guestlist", nil);
	cell.icon = nil;
	cell.tag = 2;
	return cell;
}

- (THLPromotionCardInfoCell *)newCoverChargeCell {
	THLPromotionCardInfoCell *cell = [THLPromotionCardInfoCell new];
	cell.title = NSLocalizedString(@"Cover Charge (males)", nil);
	cell.icon = nil;
	cell.tag = 3;
	return cell;
}

- (THLPromotionCardInfoCell *)newRecommendedRatioCell {
	THLPromotionCardInfoCell *cell = [THLPromotionCardInfoCell new];
	cell.title = NSLocalizedString(@"Recommended Ratio", nil);
	cell.icon = nil;
	cell.tag = 4;
	return cell;
}




@end
