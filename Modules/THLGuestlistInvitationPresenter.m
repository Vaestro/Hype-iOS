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

@interface THLGuestlistInvitationPresenter ()<THLGuestlistInvitationInteractorDelegate>

@end

@implementation THLGuestlistInvitationPresenter
- (instancetype)initWithWireframe:(THLGuestlistInvitationWireframe *)wireframe
					   interactor:(THLGuestlistInvitationInteractor *)interactor {
	if (self = [self init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

#pragma mark - THLGuestlistModuleInterface
- (void)presentGuestlistInvitationInterfaceForGuestlist:(NSString *)guestlistId inWindow:(UIWindow *)window {
	[_wireframe presentInterfaceInViewController:window.rootViewController];
	_interactor.guestlistId = guestlistId;
}

- (void)configureView:(id<THLGuestlistInvitationView>)view {
	
}

#pragma mark - THLGuestlistInvitationInteractorDelegate
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSString *)guestlistId error:(NSError *)error {

}

- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didGetInvitableUsers:(NSArray<THLUserEntity *> *)users error:(NSError *)error {

}
@end
