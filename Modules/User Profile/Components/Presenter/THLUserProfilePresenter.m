//
//  THLUserProfilePresenter.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfilePresenter.h"
#import "THLUserProfileWireframe.h"
#import "THLUserProfileView.h"
#import "THLUser.h"

@interface THLUserProfilePresenter()
@property (nonatomic, weak) id<THLUserProfileView> view;
@end

@implementation THLUserProfilePresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLUserProfileWireframe *)wireframe {
    if (self = [super init]) {
        _wireframe = wireframe;
    }
    return self;
}

- (void)presentUserProfileInterfaceInViewController:(UIViewController *)viewController {
    [_wireframe presentInterfaceInViewController:viewController];
}

- (void)configureView:(id<THLUserProfileView>)view {
    _view = view;
    
    PFFile *image = [THLUser currentUser].image;
    
    [_view setUserImageURL:[NSURL URLWithString:image.url]];
    [_view setUserName:[THLUser currentUser].firstName];
    
    WEAKSELF();
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    
    RACCommand *contactCommmand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleContactAction];
        return [RACSignal empty];
    }];
    
    RACCommand *logoutCommmand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleLogoutAction];
        return [RACSignal empty];
    }];
    [_view setLogoutCommand:logoutCommmand];
    [_view setContactCommand:contactCommmand];

    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
}

- (void)handleContactAction {
    [self.view showMailView];
}

- (void)handleLogoutAction {
    [self.moduleDelegate logOutUser];
}
@end
