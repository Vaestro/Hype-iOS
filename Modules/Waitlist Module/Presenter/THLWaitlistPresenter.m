//
//  THLWaitlistPresenter.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistPresenter.h"
#import "THLWaitlistModel.h"
#import "THLWaitlistSignupViewController.h"
#import "THLWaitlistPositionViewController.h"
#import "THLWaitlistEntry.h"
#import "THLWaitlistCodeEntryViewController.h"
#import "THLWaitlistHomeViewController.h"

@interface THLWaitlistPresenter()
<
THLWaitlistModelDelegate,
THLWaitlistSignupViewDelegate,
THLWaitlistCodeEntryViewDelegate,
THLWaitlistHomeViewDelegate
>
@property (nonatomic, strong) UIViewController *baseController;

@property (nonatomic, strong) THLWaitlistModel *model;
@property (nonatomic, strong) THLWaitlistHomeViewController *homeView;
@property (nonatomic, strong) THLWaitlistSignupViewController *signupView;
@property (nonatomic, strong) THLWaitlistPositionViewController *positionView;
@property (nonatomic, strong) THLWaitlistCodeEntryViewController *codeEntryView;
@end

@implementation THLWaitlistPresenter
- (instancetype)init {
	if (self = [super init]) {
		_model = [[THLWaitlistModel alloc] init];
		_model.delegate = self;
        _homeView = [[THLWaitlistHomeViewController alloc] initWithNibName:nil bundle:nil];
        _homeView.delegate = self;
		_signupView = [[THLWaitlistSignupViewController alloc] initWithNibName:nil bundle:nil];
		_signupView.delegate = self;
		_positionView = [[THLWaitlistPositionViewController alloc] initWithNibName:nil bundle:nil];
		_codeEntryView = [[THLWaitlistCodeEntryViewController alloc] initWithNibName:nil bundle:nil];
		_codeEntryView.delegate = self;
	}
	return self;
}

#pragma mark - Interface
- (void)presentInterfaceInWindow:(UIWindow *)window {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_homeView];
	window.rootViewController = navigationController;
	[window makeKeyAndVisible];
	[_model checkForExisitngLocalWaitlistEntry];
}

- (void)returnFromInterface {
	[_homeView dismissViewControllerAnimated:YES completion:NULL];
}

- (void)presentPositionView {
	[_model getWaitlistPosition];
	[_signupView dismissViewControllerAnimated:NO completion:NULL];
	[_homeView presentViewController:_positionView animated:NO completion:NULL];
    [_model checkForApprovedWaitlistEntry];
}

- (void)presentSignupView {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_signupView];
	[_homeView presentViewController:navigationController animated:NO completion:NULL];
}

- (void)presentCodeEntryView {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_codeEntryView];
    [_homeView presentViewController:navigationController animated:NO completion:NULL];
}

- (void)approveUserForApp {
    [self returnFromInterface];
    [_delegate didApproveUserForApp];
}

#pragma mark - THLWaitlistModelDelegate
- (void)model:(THLWaitlistModel *)model didGetWaitlistPosition:(NSInteger)position error:(NSError *)error {
	[_positionView displayPosition:position];
}

- (void)modelDidCreateEntry:(THLWaitlistModel *)model error:(NSError *)error {
	[self presentPositionView];
}

- (void)model:(THLWaitlistModel *)model didCheckForExistingEntry:(BOOL)entryExists error:(NSError *)error {
    if (entryExists) {
        [self presentPositionView];
    }
}

- (void)model:(THLWaitlistModel *)model didCheckForApprovedEntry:(BOOL)entryApproved error:(NSError *)error {
    if (entryApproved) {
        [self approveUserForApp];
    }
}

#pragma mark - THLWaitlistHomeViewDelegate
- (void)didSelectUseInvitationCode {
    [self presentCodeEntryView];
}

- (void)didSelectRequestInvitation {
    [self presentSignupView];
}

#pragma mark - THLWaitlistSignupViewDelegate
- (void)signupView:(THLWaitlistSignupViewController *)view userDidSubmitEmail:(NSString *)email {
	[_model createWaitlistEntryForEmail:email];
}

#pragma mark - THLWaitlistCodeEntryViewDelegate
- (void)view:(THLWaitlistCodeEntryViewController *)codeEntryView didRecieveCode:(NSString *)code {
	[self validateCode:code];
}

- (void)validateCode:(NSString *)code {
    [_model isValidCode:code];
}
@end
