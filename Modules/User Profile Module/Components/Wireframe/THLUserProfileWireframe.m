//
//  THLUserProfileWireframe.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileWireframe.h"
#import "THLUserProfilePresenter.h"
#import "THLUserProfileViewController.h"

@interface THLUserProfileWireframe()
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) THLUserProfilePresenter *presenter;
@property (nonatomic, strong) THLUserProfileViewController *view;
@end

@implementation THLUserProfileWireframe
- (instancetype)init {
    if (self = [super init]) {
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _view = [[THLUserProfileViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLUserProfilePresenter alloc] initWithWireframe:self];
}

- (void)presentInterfaceInViewController:(UIViewController *)viewController {
    _viewController = viewController;
    [_presenter configureView:_view];
    [_viewController addChildViewController:_view];
    _view.view.frame = _viewController.view.bounds;
    [_viewController.view addSubview:_view.view];
    [_view didMoveToParentViewController:_viewController];
}

- (id<THLUserProfileModuleInterface>)moduleInterface {
    return _presenter;
}
@end
