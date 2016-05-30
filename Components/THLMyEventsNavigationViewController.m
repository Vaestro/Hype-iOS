//
//  THLMyEventsNavigationViewController.m
//  Hype
//
//  Created by Edgar Li on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMyEventsNavigationViewController.h"
#import "THLMyEventsViewController.h"
#import "THLAppearanceConstants.h"
#import "THLUserManager.h"
#import "Intercom/intercom.h"

@interface THLMyEventsNavigationViewController()
@property (nonatomic, strong) UIBarButtonItem *intercomBarButton;
@end

@implementation THLMyEventsNavigationViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MY EVENTS";
    self.navigationBar.barTintColor = kTHLNUIPrimaryBackgroundColor; //%%% bartint

    if ([THLUserManager userLoggedIn]) {
        self.navigationItem.leftBarButtonItem = self.intercomBarButton;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    self.selectionBar.backgroundColor = kTHLNUIAccentColor;
}

- (UIBarButtonItem *)intercomBarButton {
    if (!_intercomBarButton) {
        _intercomBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Inbox Icon"] style:UIBarButtonItemStylePlain target:self action:@selector(messageButtonPressed)];
    }
    return _intercomBarButton;
}

- (void)messageButtonPressed
{
    [Intercom presentConversationList];
    
}


@end
