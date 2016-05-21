 //
//  THLLoginPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginPresenter.h"
#import "THLLoginInteractor.h"
#import "THLLoginWireframe.h"
#import "THLOnboardingViewInterface.h"
#import "THLLoginViewInterface.h"

#import "THLFacebookPictureModuleDelegate.h"
#import "THLNumberVerificationModuleDelegate.h"
#import "THLUserPhotoVerificationViewController.h"
//#import "OLFacebookImagePickerController.h"
#import "THLTextEntryViewController.h"

@interface THLLoginPresenter()
<
THLLoginInteractorDelegate,
THLUserPhotoVerificationViewDelegate,
THLFacebookPictureModuleDelegate,
THLNumberVerificationModuleDelegate
>
@property (nonatomic, strong) THLUserPhotoVerificationViewController *userPhotoVerificationView;
@property (nonatomic, strong) THLTextEntryViewController *emailVerificationView;
@property (nonatomic, strong) UIViewController *baseViewController;

@property (nonatomic, weak) id<THLOnboardingViewInterface> onboardingView;
@property (nonatomic, weak) id<THLLoginViewInterface> loginView;
@property (nonatomic) BOOL busy;
@property (nonatomic) THLActivityStatus activityStatus;
@end

@implementation THLLoginPresenter
@synthesize moduleDelegate;

#pragma mark - Interface
- (instancetype)initWithWireframe:(THLLoginWireframe *)wireframe
					   interactor:(THLLoginInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
        _interactor.delegate = self;
	}
	return self;
}

- (void)presentUserProfileInterfaceInNavigationController:(UINavigationController *)navigationController {
    [_wireframe presentLoginInterfaceOnNavigationController:navigationController];
}

- (void)presentLoginModuleInterfaceWithOnboardingInWindow:(UIWindow *)window {
    [_wireframe presentOnboardingInterfaceInWindow:window];
}

- (void)presentLoginModuleInterfaceOnViewController:(UIViewController *)viewController {
    [_wireframe presentLoginInterfaceOnViewController:viewController];
}

- (void)presentUserVerificationInterfaceInWindow:(UIWindow *)window {
    [_wireframe presentUserVerificationInterfaceInWindow:window];
}

- (void)configureBaseView:(UIViewController *)baseView {
    _baseViewController = baseView;
}

#pragma mark - View Decoration
- (void)configureOnboardingView:(id<THLOnboardingViewInterface>)onboardingView {
    _onboardingView = onboardingView;
    
    WEAKSELF();
    STRONGSELF();
	RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
		[WSELF handleUserLoginAction];
		return [RACSignal empty];
	}];
    RACCommand *skipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleSkipAction];
        return [RACSignal empty];
    }];
    [RACObserve(self, activityStatus) subscribeNext:^(NSNumber *x) {
        [SSELF.onboardingView setShowActivityIndicator:x];
    }];
    
    [_onboardingView setSkipCommand:skipCommand];
	[_onboardingView setLoginCommand:loginCommand];
    _baseViewController = (UIViewController *)_onboardingView;
}

- (void)configureLoginView:(id<THLLoginViewInterface>)loginView {
    _loginView = loginView;
    
    WEAKSELF();
    STRONGSELF();
    RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
        [WSELF handleUserLoginAction];
        return [RACSignal empty];
    }];
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF dismissInterface];
        return [RACSignal empty];
    }];
    [RACObserve(self, activityStatus) subscribeNext:^(NSNumber *x) {
        [SSELF.onboardingView setShowActivityIndicator:x];
    }];
    [_loginView setDismissCommand:dismissCommand];
    [_loginView setLoginCommand:loginCommand];
    _baseViewController = (UIViewController *)_loginView;
}

#pragma mark - Action Handling
- (void)handleError:(NSError *)error {
	DLog(@"Error: %@", error);
	[self reroute];
}

- (void)handleSkipAction {
    [_wireframe finishOnboarding];
    [self.moduleDelegate skipUserLogin];
}

- (void)handleUserLoginAction {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Touched Facebook Login Button"];
	[_interactor login];
};

#pragma mark - Routing
- (void)reroute {
    if ([_interactor shouldAddFacebookInformation]) {
        [_interactor addFacebookInformation];
    } else if ([_interactor shouldVerifyEmail]) {
        [self routeToEmailVerificationInterface];
    } else if ([_interactor shouldVerifyPhoneNumber]) {
		[self routeToNumberVerificationInterface];
    } else if ([_interactor shouldPickProfileImage]) {
		[self routeToPickProfilePictureInterface];
	} else {
        if (_onboardingView) {
            [_wireframe finishOnboarding];
        } else {
            [_wireframe finishLogin];
        }
	}
}

- (void)routeToEmailVerificationInterface {
    [self presentUserInfoVerificationView];
}

- (void)presentUserInfoVerificationView {
    _emailVerificationView  = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
    _emailVerificationView.delegate = self;
    _emailVerificationView.titleText = @"Confirm Info";
    _emailVerificationView.descriptionText = @"We use your email and phone number to send you confirmations and receipts";
    _emailVerificationView.buttonText = @"Continue";
    _emailVerificationView.type = THLTextEntryTypeEmail;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_emailVerificationView];
    [navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = YES;
    navigationController.view.backgroundColor = [UIColor clearColor];
    
    [_baseViewController presentViewController:navigationController animated:NO completion:NULL];
}

- (void)routeToNumberVerificationInterface {
	[_wireframe presentNumberVerificationInterface:self];
}

- (void)routeToPickProfilePictureInterface {
    [_wireframe presentFacebookPictureInterface:self];
    _userPhotoVerificationView = [[THLUserPhotoVerificationViewController alloc] initWithNibName:nil bundle:nil];
    _userPhotoVerificationView.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_userPhotoVerificationView];
    [_baseViewController presentViewController:navigationController animated:NO completion:NULL];
	
}

- (void)dismissInterface {
    [_wireframe dismissInterface];
}

#pragma mark - THLLoginInteractorDelegate
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self reroute];
	}
}

- (void)interactor:(THLLoginInteractor *)interactor didAddFacebookInformation:(NSError *)error {
    if (error) {
        [self handleError:error];
    } else {
        [_interactor createMixPanelUserProfile];
        [self reroute];
    }
}

- (void)interactor:(THLLoginInteractor *)interactor didAddEmail:(NSError *)error {
    if (error) {
        [self handleError:error];
    } else {
        [_emailVerificationView dismissViewControllerAnimated:FALSE completion:NULL];
        [self reroute];
    }
}

- (void)interactor:(THLLoginInteractor *)interactor didAddVerifiedPhoneNumber:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self reroute];
	}
}

- (void)interactor:(THLLoginInteractor *)interactor didAddProfileImage:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self reroute];
	}
}

#pragma mark - THLTextEntryVerificationDelegate
- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email {
    [_interactor addEmail:email];
}

#pragma mark - FACEBOOK PICTURE -
#pragma mark - THLUserPhotoVerificationDelegate

- (void) userPhotoVerificationView:(THLUserPhotoVerificationViewController *)view userDidConfirmPhoto:(UIImage *) image{
    [_interactor addProfileImage:image];
}

#pragma mark - THLFacebookPictureModuleDelegate
- (void)facebookPictureModule:(id<THLFacebookPictureModuleInterface>)module didSelectImage:(UIImage *)image {
    [_userPhotoVerificationView facebookUserImage:image];
}

#pragma mark - THLNumberVerificationModuleDelegate
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didVerifyNumber:(NSString *)number {
	[_interactor addVerifiedPhoneNumber:number];
}

- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didFailToVerifyNumber:(NSError *)error {
	[self handleError:error];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end
