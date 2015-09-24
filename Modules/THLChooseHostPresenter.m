//
//  THLChooseHostPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLChooseHostPresenter.h"
#import "THLChooseHostView.h"
#import "THLChooseHostWireframe.h"
#import "THLChooseHostInteractor.h"

@interface THLChooseHostPresenter()
<
THLChooseHostInteractorDelegate
>
@property (nonatomic, strong) id<THLChooseHostView> view;
@property (nonatomic, strong) NSArray *promotions;
@end

@implementation THLChooseHostPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLChooseHostWireframe *)wireframe
					   interactor:(THLChooseHostInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}

	return self;
}

- (void)presentChooseHostInterfaceForEvent:(THLEvent *)event inWindow:(UIWindow *)window {
	[_wireframe presentInterfaceInWindow:window];
	[_interactor findPromotionsForEvent:event];
}

- (void)configureView:(id<THLChooseHostView>)view {
	_view = view;

	RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleDismissAction];
		return [RACSignal empty];
	}];
	[view setDismissCommand:dismissCommand];

	RACCommand *chooseHostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleHostSelectionAction];
		return [RACSignal empty];
	}];
	[view setChooseHostCommand:chooseHostCommand];
}

#pragma mark - Action Handlers
- (void)handleDismissAction {
	[_wireframe dismissInterface];
}

- (void)handleHostSelectionAction {
	THLPromotion *selectedPromotion = _promotions[_view.selectedIndex];
	[self.moduleDelegate chooseHostModule:self didSelectHost:selectedPromotion];
	[_wireframe dismissInterface];
}

#pragma mark - THLChooseHostInteractorDelegate
- (void)interactor:(THLChooseHostInteractor *)interactor didFindPromotions:(NSArray *)promotions forEvent:(THLEvent *)event error:(NSError *)error {
	[_view setViewModels:promotions];
}
@end
