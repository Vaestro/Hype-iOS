//
//  THLLoginService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLoginService.h"
#import "PFFacebookUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SDWebImageManager.h"
#import "THLUser.h"
#import <DigitsKit/DigitsKit.h>

#import "THLTextEntryViewController.h"
#import "THLPermissionRequestViewController.h"

#import "THLAppearanceConstants.h"

@interface THLLoginService()
<
THLTextEntryViewDelegate,
THLPermissionRequestViewControllerDelegate
>
@property (nonatomic, strong) DGTAppearance *digitsAppearance;
@property (nonatomic, strong) THLTextEntryViewController *userInfoVerificationViewController;
@property (nonatomic, strong) THLPermissionRequestViewController *permissionRequestViewController;

@end

@implementation THLLoginService

- (void)checkForCompletedProfile {
    if ([self userShouldAddPhoneNumber]) {
        [self presentNumberVerificationInterfaceInViewController];
    } else if ([self userShouldAddEmail]) {
        [self presentUserInfoVerificationView];
    } else if ([self userShouldRegisterForNotifications]) {
        [self presentPermissionRequestViewController];
    } else {
        [self createMixpanelAlias];
        [self.delegate loginServiceDidLoginUser];
    }
}

#pragma mark -
#pragma mark - Email Signup
- (void)signUpWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName sex:(THLSex)sex {
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    WEAKSELF();
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            THLUser *currentUser = [THLUser currentUser];
            currentUser.firstName = firstName;
            currentUser.lastName = lastName;
            currentUser.sex = sex;
            currentUser.type = THLUserTypeGuest;
            [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
                [WSELF checkForCompletedProfile];
                return nil;
            }];
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Signing Up"
                                                            message:errorString
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - Email Login

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            [self checkForCompletedProfile];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Email or Password"
                                                            message:@"The email or password you have entered does not match a valid account. Please check that you have entered your information correctly and try again"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}


#pragma mark - 
#pragma mark - Facebook Sign Up

- (void)signUpWithFacebook {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Touched facebook signup button"];
    
    WEAKSELF();
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[self facebookLoginPermissions] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            [WSELF saveFacebookUserInformation];
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Existing account"
                                                            message:@"You already have an account. Please login instead"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

#pragma mark - Facebook Login

- (void)loginWithFacebook {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Touched facebook login button"];
    
    WEAKSELF();
    [PFFacebookUtils logInInBackgroundWithReadPermissions:[self facebookLoginPermissions] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You do not have an account. Please sign up"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            if ([self userShouldAddFacebookInformation]) {
                [self saveFacebookUserInformation];
            } else {
                [self checkForCompletedProfile];
            }
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

- (void)saveFacebookUserInformation {
    WEAKSELF();
    [[self getFacebookUserDictionary] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSDictionary *userDictionary = task.result;
        THLUser *currentUser = [THLUser currentUser];
        currentUser.fbId = userDictionary[@"id"];
        currentUser.firstName = userDictionary[@"first_name"];
        currentUser.lastName = userDictionary[@"last_name"];
        currentUser.fbEmail = userDictionary[@"email"];
        currentUser.sex = ([userDictionary[@"gender"] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:userDictionary[@"picture"][@"data"][@"url"]]];
        PFFile *profilePicture = [PFFile fileWithName:@"profile_picture.png" data:imageData];
        [profilePicture save];
        currentUser.image = profilePicture;
        //TODO: Add Location and Birthday upon Facebook Approval
        //        [WSELF user].fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[@"birthday"]] date];
        //        [WSELF user].location = userDictionary[@"location"];
        if (userDictionary[@"verified"]) {
            currentUser.fbVerified = TRUE;
        }
        else {
            currentUser.fbVerified = FALSE;
        }
        currentUser.type = THLUserTypeGuest;
        [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
            [WSELF checkForCompletedProfile];
            return nil;
        }];
        return task;
    }];
}

- (BFTask *)getFacebookUserDictionary {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:@{@"fields": @"id,first_name,last_name,name,gender,verified,email, picture.type(large)"}
                                  HTTPMethod:@"GET"];
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [completionSource setResult:result];
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}


#pragma mark -
#pragma mark - Phone Number Verification

- (void)presentNumberVerificationInterfaceInViewController {
    WEAKSELF();
    STRONGSELF();
    DGTAuthenticationConfiguration *configuration = [DGTAuthenticationConfiguration new];
    
    configuration.title = NSLocalizedString(@"Number Verification", nil);
    configuration.appearance = self.digitsAppearance;
    [[Digits sharedInstance] authenticateWithViewController:[self topViewController] configuration:configuration completion:^(DGTSession *session, NSError *error) {
        if (!error) {
            [SSELF handleNumberVerificationSuccess:session];
        }
    }];
}

- (void)handleNumberVerificationSuccess:(DGTSession *)session {
    THLUser *currentUser = [THLUser currentUser];
    currentUser.phoneNumber = session.phoneNumber;
    WEAKSELF();
    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF checkForCompletedProfile];
        return nil;
    }];
}

#pragma mark -
#pragma mark - Email Verification

- (void)presentUserInfoVerificationView {
    [[self topViewController].navigationController pushViewController:self.userInfoVerificationViewController animated:YES];
}

- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email {
    THLUser *currentUser = [THLUser currentUser];
    currentUser.email = email;
    WEAKSELF();
    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF checkForCompletedProfile];
        return nil;
    }];
}

#pragma mark -
#pragma mark - Mixpanel

- (void)createMixpanelAlias {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    THLUser *user = [THLUser currentUser];
    // mixpanel identify: must be called before
    // people properties can be set
    [mixpanel createAlias:user.objectId
            forDistinctID:mixpanel.distinctId];
    // You must call identify if you haven't already
    // (e.g., when your app launches).
    [mixpanel identify:mixpanel.distinctId];
    
    NSString *userSex;
    if (user.sex == THLSexMale) {
        userSex = @"Male";
    } else if (user.sex == THLSexFemale) {
        userSex = @"Female";
    }
    [mixpanel registerSuperPropertiesOnce:@{@"Gender": userSex}];
    [mixpanel.people set:@{@"$first_name": user.firstName,
                           @"$last_name": user.lastName,
                           @"$email": user.email,
                           @"$phone": user.phoneNumber,
                           @"$created": user.createdAt,
                           @"Gender": userSex
                           }];
}

- (void)createMixpanelPeopleProfile {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    THLUser *user = [THLUser currentUser];
    
    NSString *userSex;
    if (user.sex == THLSexMale) {
        userSex = @"Male";
    } else if (user.sex == THLSexFemale) {
        userSex = @"Female";
    }
    [mixpanel registerSuperPropertiesOnce:@{@"Gender": userSex}];
    [mixpanel.people set:@{@"$first_name": user.firstName,
                           @"$last_name": user.lastName,
                           @"$email": user.email,
                           @"$phone": user.phoneNumber,
                           @"$created": user.createdAt,
                           @"Gender": userSex
                           }];
}


#pragma mark -
#pragma mark - Helpers

- (BOOL)shouldLogin {
    return [THLUser currentUser] == nil;
}

- (BOOL)userShouldAddFacebookInformation {
    return [THLUser currentUser].fbId == nil;
}

- (BOOL)userShouldAddPhoneNumber {
    return [THLUser currentUser].phoneNumber == nil || [[THLUser currentUser].phoneNumber isEqualToString:@""];
}

- (BOOL)userShouldAddEmail {
    return [THLUser currentUser].email == nil || [[THLUser currentUser].email isEqualToString:@""];
}

- (BOOL)userShouldRegisterForNotifications {
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] == false;
}

- (NSArray *)facebookLoginPermissions {
    //TODO:Add User Location and Birthday after getting approval from Facebook
    //           @"user_location",
    //			 @"user_birthday",

    return @[@"public_profile",
             @"user_photos",
             @"email",
             @"user_friends"];
}

- (void)applicationDidRegisterForRemoteNotifications {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Registered for push notification permission"];
    [self checkForCompletedProfile];
}

- (void)permissionViewControllerDeclinedPermission {
    [self.delegate loginServiceDidLoginUser];
}

- (void)presentPermissionRequestViewController {
    [[self topViewController].navigationController pushViewController:self.permissionRequestViewController animated:YES];
}

#pragma mark - Accessors
- (THLPermissionRequestViewController *)permissionRequestViewController {
    if (!_permissionRequestViewController) {
        _permissionRequestViewController  = [[THLPermissionRequestViewController alloc] initWithNibName:nil bundle:nil];
        _permissionRequestViewController.delegate = self;
    }
    return _permissionRequestViewController;
}

- (THLTextEntryViewController *)userInfoVerificationViewController {
    if (!_userInfoVerificationViewController) {
        _userInfoVerificationViewController  = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
        _userInfoVerificationViewController.delegate = self;
        _userInfoVerificationViewController.titleText = @"Confirm Info";
        _userInfoVerificationViewController.descriptionText = @"We use your email and phone number to send you confirmations and receipts";
        _userInfoVerificationViewController.buttonText = @"Continue";
        _userInfoVerificationViewController.type = THLTextEntryTypeEmail;
    }
    return _userInfoVerificationViewController;
}

- (DGTAppearance *)digitsAppearance {
    if (!_digitsAppearance) {
        _digitsAppearance = [DGTAppearance new];
        _digitsAppearance.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _digitsAppearance.accentColor = kTHLNUIAccentColor;
        _digitsAppearance.logoImage = [UIImage imageNamed:@"Hypelist-Icon"];
    }
    return _digitsAppearance;
}

#pragma mark TopViewController Helper

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
@end
