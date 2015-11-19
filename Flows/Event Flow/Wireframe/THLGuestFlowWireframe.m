//
//  THLGuestFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLGuestFlowDependencyManager.h"

#import "THLGuestFlowWireframe.h"

#import "THLEventDiscoveryWireframe.h"
#import "THLDashboardWireframe.h"
#import "THLUserProfileWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistReviewWireframe.h"
#import "THLGuestFlowNavigationController.h"

typedef NS_OPTIONS(NSInteger, THLGuestlistReviewOptions) {
    THLGuestlistReviewOptionsAcceptDeclineGuestlistInvite = 0,
    THLGuestlistReviewOptionsLeaveGuestlist,
    THLGuestlistReviewOptionsAddRemoveGuests,
    THLGuestlistReviewOptionsAcceptDeclineGuestlist,
    THLGuestlistReviewOptionsConfirmGuestlistInvites,
    THLGuestlistReviewOptions_Count
};

@interface THLGuestFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLDashboardModuleDelegate,
THLUserProfileModuleDelegate,
THLEventDetailModuleDelegate,
THLGuestlistInvitationModuleDelegate,
THLGuestlistReviewModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, nonatomic) UIViewController *containerVC;
@property (nonatomic, strong) THLGuestFlowNavigationController *navigationController;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLDashboardWireframe *dashboardWireframe;
@property (nonatomic, strong) THLUserProfileWireframe *userProfileWireframe;
@property (nonatomic, strong) THLEventDetailWireframe  *eventDetailWireframe;
@property (nonatomic, strong) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@end

@implementation THLGuestFlowWireframe
@synthesize moduleDelegate;
- (instancetype)initWithDependencyManager:(id<THLGuestFlowDependencyManager>)dependencyManager {
	if (self = [super init]) {
		_dependencyManager = dependencyManager;
	}
	return self;
}

- (void)presentGuestFlowInWindow:(UIWindow *)window {
    _window = window;
//    _containerVC = [self newContainerVC];
    UIViewController *discovery = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *profile = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *dashboard = [[UIViewController alloc] initWithNibName:nil bundle:nil];

    [self presentEventDiscoveryInterfaceInViewController:discovery];
    [self presentDashboardInterfaceInViewController:dashboard];
    [self presentUserProfileInterfaceInViewController:profile];
    
    _navigationController = [[THLGuestFlowNavigationController alloc] initWithMainViewController:discovery
                                                                          leftSideViewController:dashboard
                                                                         rightSideViewController:profile];
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
}

//- (UIViewController *)newContainerVC {
//    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//    
//}
- (void)presentGuestFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity {
    /**
     *  Prevents popup notification from instantiating another event detail module if one is already instantiated
     */
    [_navigationController popToRootViewControllerAnimated:NO];
    [self presentEventDetailInterfaceForEvent:eventEntity];
}

- (id<THLGuestFlowModuleInterface>)moduleInterface {
    return self;
}

- (void)presentEventDiscoveryInterfaceInViewController:(UIViewController *)viewController {
	_eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
	[_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
	[_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInViewController:viewController];
}

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController {
    _dashboardWireframe = [_dependencyManager newDashboardWireframe];
    _currentWireframe = _dashboardWireframe;
    [_dashboardWireframe.moduleInterface setModuleDelegate:self];
    [_dashboardWireframe.moduleInterface presentDashboardInterfaceInViewController:viewController];
}

- (void)presentUserProfileInterfaceInViewController:(UIViewController *)viewController {
    _userProfileWireframe = [_dependencyManager newUserProfileWireframe];
    _currentWireframe = _userProfileWireframe;
    [_userProfileWireframe.moduleInterface setModuleDelegate:self];
    [_userProfileWireframe.moduleInterface presentUserProfileInterfaceInViewController:viewController];
}


- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity {
	_eventDetailWireframe = [_dependencyManager newEventDetailWireframe];
    _currentWireframe = _eventDetailWireframe;
    [_eventDetailWireframe.moduleInterface setModuleDelegate:self];
	[_eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:eventEntity inWindow:_window];
}


- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity inController:(UIViewController *)controller {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    _currentWireframe = _guestlistInvitationWireframe;
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
	[_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForPromotion:promotionEntity inController:controller];
}

- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests inController:(UIViewController *)controller {
    _guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    _currentWireframe = _guestlistInvitationWireframe;
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForPromotion:promotionEntity withGuestlistId:guestlistId andGuests:guests inController:controller];
}
     
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    _currentWireframe = _guestlistReviewWireframe;
    [_guestlistReviewWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistReviewWireframe.moduleInterface presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller];
}

#pragma mark - THLDashboardModuleDelegate
- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewEvent:(THLEventEntity *)event {
    [self presentEventDetailInterfaceForEvent:event];
}

#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity {
	[self presentEventDetailInterfaceForEvent:eventEntity];
}

#pragma mark - THLEventDetailModuleDelegate

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module promotion:(THLPromotionEntity *)promotionEntity presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller{
    [self presentGuestlistInvitationInterfaceForPromotion:promotionEntity inController:controller];
}

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module guestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller {
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller];
}

- (void)dismissEventDetailWireframe {
    _eventDetailWireframe = nil;
}

#pragma mark - THLGuestlistInvitationModuleDelegate
- (void)dismissGuestlistInvitationWireframe {
    _guestlistInvitationWireframe = nil;
}

#pragma mark - THLGuestlistReviewModuleDelegate
- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module promotion:(THLPromotionEntity *)promotionEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller {
    [self presentGuestlistInvitationInterfaceForPromotion:promotionEntity withGuestlistId:guestlistId andGuests:guests inController:controller];
}

- (void)dismissGuestlistReviewWireframe {
    _guestlistReviewWireframe = nil;
}

#pragma mark - THLUserProfileModuleDelegate
- (void)logOutUser {
    [self.moduleDelegate logOutUser];
}
@end
