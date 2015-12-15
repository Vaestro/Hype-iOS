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
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:nil];
        
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [WSELF handleLogoutAction];
                                                              }];
        NSString *message = NSStringWithFormat(@"Are you sure you want to logout of Hype?");

        [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, confirmAction, nil]];

        return [RACSignal empty];
    }];
    
    [_view setLogoutCommand:logoutCommmand];
    [_view setContactCommand:contactCommmand];

    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([THLUser currentUser].type == THLUserTypeGuest) {
            [self.moduleDelegate presentPerkInterfaceInWindow];

        } else {
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                              handler:nil];
            
            NSString *message = NSStringWithFormat(@"Hosts cannot access Rewards");
            
            [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:okAction, nil]];
        }
    }
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
}

- (void)handleContactAction {
    [self.view showMailView];
}

- (void)handleLogoutAction {
    [self.moduleDelegate logOutUser];
}
@end
