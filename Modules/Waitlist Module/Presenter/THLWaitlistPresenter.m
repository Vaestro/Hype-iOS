//
//  THLWaitlistPresenter.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistPresenter.h"
#import "THLWaitlistModel.h"
#import "THLWaitlistPositionViewController.h"
#import "THLWaitlistEntry.h"
#import "THLWaitlistHomeViewController.h"
#import "THLTextEntryViewController.h"

@interface THLWaitlistPresenter()
<
THLWaitlistModelDelegate,
THLTextEntryViewDelegate,
THLWaitlistHomeViewDelegate
>
@property (nonatomic, strong) UIViewController *baseController;

@property (nonatomic, strong) THLWaitlistModel *model;
@property (nonatomic, strong) THLWaitlistHomeViewController *homeView;
@property (nonatomic, strong) THLWaitlistPositionViewController *positionView;
@property (nonatomic, strong) THLTextEntryViewController *signupView;
@property (nonatomic, strong) THLTextEntryViewController *invitationCodeEntryView;
@end

@implementation THLWaitlistPresenter
- (instancetype)init {
	if (self = [super init]) {
		_model = [[THLWaitlistModel alloc] init];
		_model.delegate = self;
        _homeView = [[THLWaitlistHomeViewController alloc] initWithNibName:nil bundle:nil];
        _homeView.delegate = self;
        _positionView = [[THLWaitlistPositionViewController alloc] initWithNibName:nil bundle:nil];

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
    THLTextEntryViewController *signupView  = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
    signupView.delegate = self;
    signupView.titleText = @"Join the waitlist";
    signupView.descriptionText = @"Please enter your email address to request early access";
    signupView.buttonText = @"Request Invitation";
    signupView.type = THLTextEntryTypeEmail;
    [_homeView.navigationController pushViewController:signupView animated:YES];
}

- (void)presentCodeEntryView {
    THLTextEntryViewController *invitationCodeEntryView = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
    invitationCodeEntryView.delegate = self;
    invitationCodeEntryView.titleText = @"Welcome";
    invitationCodeEntryView.descriptionText = @"Enter your invite code to get in";
    invitationCodeEntryView.buttonText = @"Submit Code";
    invitationCodeEntryView.textLength = 6;
    invitationCodeEntryView.type = THLTextEntryTypeCode;
    [_homeView.navigationController pushViewController:invitationCodeEntryView animated:YES];
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

- (void)model:(THLWaitlistModel *)model didGetMatchingCode:(BOOL)matchingCode error:(NSError *)error {
    if (matchingCode) {
        [self approveUserForApp];
    } else {
        [self codeError];
    }
}

- (void)codeError {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"Invalid code");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
    
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [_homeView presentViewController:alert animated:YES completion:nil];
}

#pragma mark - THLWaitlistHomeViewDelegate
- (void)didSelectUseInvitationCode {
    [self presentCodeEntryView];
}

- (void)didSelectRequestInvitation {
    [self presentSignupView];
}

#pragma mark - THLWaitlistSignupViewDelegate
- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email {
	[_model createWaitlistEntryForEmail:email];
}

#pragma mark - THLWaitlistCodeEntryViewDelegate
- (void)codeEntryView:(THLTextEntryViewController *)view userDidSubmitCode:(NSString *)code {
	[self validateCode:code];
}

- (void)validateCode:(NSString *)code {
    [_model isValidCode:code];
}


@end
