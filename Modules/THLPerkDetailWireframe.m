//
//  THLPerkDetailWireframe.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailWireframe.h"
#import "THLPerkDetailInteractor.h"
#import "THLPerkDetailPresenter.h"
#import "THLPerkDetailViewController.h"
#import "THLPerksViewController.h"


@interface THLPerkDetailWireframe()
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) THLPerkDetailPresenter *presenter;
@property (nonatomic, strong) THLPerkDetailInteractor *interactor;
@property (nonatomic, strong) THLPerkDetailViewController *view;
@end


@implementation THLPerkDetailWireframe
- (instancetype)initWithPerkItemStoreService:(id<THLPerkItemStoreServiceInterface>)perkItemStoreService
                                entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _perkItemStoreService = perkItemStoreService;
        _entityMapper = entityMapper;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _view = [[THLPerkDetailViewController alloc] initWithNibName:nil bundle:nil];
    _interactor = [[THLPerkDetailInteractor alloc] init];
    _presenter = [[THLPerkDetailPresenter alloc] initWithInteractor:_interactor wireframe:self];
}

- (void)presentPerkDetailonViewController:(UIViewController *)viewController {
    _controller = viewController;
    [_presenter configureView:_view];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_view];
    [_controller presentViewController:navigationController animated:YES completion:NULL];
}

- (void)dismissInterface {
    [_view.navigationController dismissViewControllerAnimated:YES completion:^{
        [_presenter.moduleDelegate dismissPerkDetailWireframe];
    }];
}

- (id<THLPerkDetailModuleInterface>)moduleInterface {
    return _presenter;
}
@end
