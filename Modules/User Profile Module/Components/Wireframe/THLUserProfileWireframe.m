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
@property (nonatomic, strong) UINavigationController *navigationController;
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

- (void)presentInterfaceInNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    [_presenter configureView:_view];
    [_navigationController addChildViewController:_view];
}

- (id<THLUserProfileModuleInterface>)moduleInterface {
    return _presenter;
}
@end
