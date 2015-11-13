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
    
    
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {

}
@end
