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

@interface THLWaitlistPresenter()
<
THLWaitlistModelDelegate,
THLWaitlistSignupViewDelegate
>
@property (nonatomic, strong) UIViewController *baseController;

@property (nonatomic, strong) THLWaitlistModel *model;
@property (nonatomic, strong) THLWaitlistSignupViewController *signupView;
@property (nonatomic, strong) THLWaitlistPositionViewController *positionView;
@end

@implementation THLWaitlistPresenter
- (instancetype)init {
	if (self = [super init]) {
		_model = [[THLWaitlistModel alloc] init];
		_model.delegate = self;
		_signupView = [[THLWaitlistSignupViewController alloc] initWithNibName:nil bundle:nil];
		_signupView.delegate = self;
		_positionView = [[THLWaitlistPositionViewController alloc] initWithNibName:nil bundle:nil];
	}

	return self;
}

#pragma mark - Interface
- (void)presentInterfaceInWindow:(UIWindow *)window {
	_baseController = [UIViewController new];
	window.rootViewController = _baseController;
	[window makeKeyAndVisible];
	
	[_model checkForExisitngLocalWaitlistEntry];
}

#pragma mark - THLWaitlistModelDelegate
- (void)model:(THLWaitlistModel *)model didGetWaitlistPosition:(NSInteger)position error:(NSError *)error {
	[_positionView displayPosition:position];
}

- (void)modelDidCreateEntry:(THLWaitlistModel *)model error:(NSError *)error {
	[self presentPositionView];
}

- (void)presentPositionView {
	[_model getWaitlistPosition];
	[_signupView dismissViewControllerAnimated:NO completion:NULL];
	[_baseController presentViewController:_positionView animated:NO completion:NULL];
}

- (void)model:(THLWaitlistModel *)model didCheckForExistingEntry:(BOOL)entryExists error:(NSError *)error {
	if (entryExists) {
		[self presentPositionView];
	} else {
		[self presentSignupView];
	}
}

- (void)presentSignupView {
	[_baseController presentViewController:_signupView animated:NO completion:NULL];
}

#pragma mark - THLWaitlistSignupViewDelegate
- (void)signupView:(THLWaitlistSignupViewController *)view userDidSubmitEmail:(NSString *)email {
	[_model createWaitlistEntryForEmail:email];
}
@end
