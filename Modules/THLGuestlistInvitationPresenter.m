//
//  THLGuestlistInvitationPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationPresenter.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistInvitationInteractor.h"
#import "THLGuestlistInvitationView.h"
#import "THLGuestlistInvitationViewEventHandler.h"

@interface THLGuestlistInvitationPresenter ()
<
THLGuestlistInvitationInteractorDelegate,
THLGuestlistInvitationViewEventHandler
>
@property (nonatomic, weak) id<THLGuestlistInvitationView> view;
@end

@implementation THLGuestlistInvitationPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLGuestlistInvitationWireframe *)wireframe
					   interactor:(THLGuestlistInvitationInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

#pragma mark - THLGuestlistModuleInterface
- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity forGuestlist:(NSString *)guestlistId inWindow:(UIWindow *)window {
    _interactor.promotionEntity = promotionEntity;
	_interactor.guestlistId = guestlistId;
	[_wireframe presentInterfaceInWindow:window];
}

- (void)configureView:(id<THLGuestlistInvitationView>)view {
	_view = view;
	[view setEventHandler:self];
	[view setDataSource:[_interactor getDataSource]];
//    RACCommand *cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        [self handleCancelAction];
//        return [RACSignal empty];
//    }];
//    
//    [navBar setDismissCommand:cancelCommand];
}


#pragma mark - THLGuestlistInvitationInteractorDelegate
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSString *)guestlistId error:(NSError *)error {

}

#pragma mark - THLGuestlistInvitationViewEventHandler 
- (void)view:(id<THLGuestlistInvitationView>)view didAddGuest:(THLGuestEntity *)guest {
	[_interactor addGuest:guest];
}

- (void)view:(id<THLGuestlistInvitationView>)view didRemoveGuest:(THLGuestEntity *)guest {
	[_interactor removeGuest:guest];
}

- (void)viewDidCancelInvitations:(id<THLGuestlistInvitationView>)view {
    [_wireframe dismissInterface];
}

- (void)viewDidCommitInvitations:(id<THLGuestlistInvitationView>)view {
	[_interactor commitChangesToGuestlist];
}
@end
