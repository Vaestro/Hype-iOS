//
//  THLPromotionSelectionPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionSelectionPresenter.h"
#import "THLPromotionSelectionView.h"
#import "THLPromotionSelectionWireframe.h"
#import "THLPromotionSelectionInteractor.h"

@interface THLPromotionSelectionPresenter ()
<
        THLPromotionSelectionInteractorDelegate
>
@property (nonatomic, strong) id<THLPromotionSelectionView> view;
@property (nonatomic, strong) NSArray *promotions;
@end

@implementation THLPromotionSelectionPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLPromotionSelectionWireframe *)wireframe
					   interactor:(THLPromotionSelectionInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}

	return self;
}

- (void)presentPromotionSelectionInterfaceForEvent:(THLEventEntity *)eventEntity inViewController:(UIViewController *)controller {
	[_wireframe presentInterfaceInViewController:controller];
//	[_interactor getPromotionsForEvent:eventEntity];
}

- (void)configureView:(id<THLPromotionSelectionView>)view {
	_view = view;

	RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];
	[view setDismissCommand:dismissCommand];

	RACCommand *chooseHostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleSelectionAction];
		return [RACSignal empty];
	}];
	[view setChooseHostCommand:chooseHostCommand];
}

#pragma mark - Action Handlers
- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleSelectionAction {
	THLPromotionEntity *selectedPromotionEntity = _promotions[_view.selectedIndex];
	[self.moduleDelegate promotionSelectionModule:self didSelectPromotion:selectedPromotionEntity];
	[_wireframe dismissInterface];
}

#pragma mark - THLChooseHostInteractorDelegate
- (void)interactor:(THLPromotionSelectionInteractor *)interactor didGetPromotions:(NSArray<THLPromotionEntity *> *)promotions forEvent:(THLEventEntity *)eventEntity error:(NSError *)error {
	[_view setViewModels:promotions];
}
@end
