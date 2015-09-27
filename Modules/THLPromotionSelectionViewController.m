//
//  THLPromotionSelectionViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionSelectionViewController.h"
#import "iCarousel.h"
#import "THLPromotionCardView.h"
#import "THLPromotionSelectionViewModel.h"

@interface THLPromotionSelectionViewController ()
<
iCarouselDataSource,
iCarouselDelegate
>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UIButton *selectionButton;
@property (nonatomic, strong) UIButton *dismissButton;
@end

@implementation THLPromotionSelectionViewController
@synthesize viewModels;
@synthesize chooseHostCommand;
@synthesize dismissCommand;
@synthesize selectedIndex = _selectedIndex;

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	[self constructView];
	[self layoutView];
	[self configureBindings];
}

- (void)constructView {
	_carousel = [self newCarousel];
	_selectionButton = [self newSelectionButton];
}

- (void)layoutView {
	[self.view addSubviews:@[_carousel,
							 _selectionButton]];
	[_carousel makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.insets(UIEdgeInsetsZero);
	}];

	[_selectionButton makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_carousel.mas_bottom);
		make.left.right.bottom.insets(UIEdgeInsetsZero);
	}];
}

- (void)configureBindings {
	RAC(self.selectionButton, rac_command) = RACObserve(self, chooseHostCommand);

	RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);

	[RACObserve(self, viewModels) subscribeNext:^(NSArray *arr) {
		[_carousel reloadData];
	}];
}

#pragma mark - Constructors
- (iCarousel *)newCarousel {
	iCarousel *carousel = [iCarousel new];
	carousel.type = iCarouselTypeLinear;
	carousel.pagingEnabled = YES;
	carousel.dataSource = self;
	carousel.delegate = self;
	carousel.bounces = YES;
	return carousel;
}

- (UIButton *)newSelectionButton {
	UIButton *button = [UIButton new];
	[button setTitle:@"CHOOSE A HOST" forState:UIControlStateNormal];
	return button;
}

#pragma mark - iCarousel <DataSource>
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
	return self.viewModels.count;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
	return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
	return nil;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

	CGRect frame = carousel.frame;
	frame.size.height -= 50;
	frame.size.width -= 50;

	THLPromotionCardView *promotionCardView = [[THLPromotionCardView alloc] initWithFrame:frame];
	THLPromotionSelectionViewModel *model = self.viewModels[index];
	promotionCardView.hostName = model.name;
	promotionCardView.hostThumbnail = model.thumbnail;
	promotionCardView.arrivalTime = model.arrivalTime;
	promotionCardView.guestlistSpace = model.guestlistSpace;
	promotionCardView.hostRating = model.rating;
	promotionCardView.coverCharge = model.coverCharge;
	promotionCardView.femaleRatio = model.femaleRatio;

	return promotionCardView;
}

#pragma mark - iCarousel <Delegate>
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
	[self carousel:carousel didSelectItemAtIndex:carousel.currentItemIndex];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
	_selectedIndex = index;
}
@end
