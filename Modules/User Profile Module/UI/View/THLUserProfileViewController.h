//
//  THLUserProfileViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "THLUserProfileView.h"
#import "THLUserProfileInfoView.h"

@protocol THLUserProfileView;
@protocol THLUserProfileViewControllerDelegate <NSObject>
- (void)userProfileViewControllerWantsToLogout;
- (void)userProfileViewControllerWantsToPresentPaymentViewController;

@end

@interface THLUserProfileViewController : UIViewController
<
THLUserProfileView,
UITableViewDelegate,
UITableViewDataSource,
UIWebViewDelegate,
MFMailComposeViewControllerDelegate
>
@property (nonatomic, weak) id<THLUserProfileViewControllerDelegate> delegate;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *contactCommand;
@property (nonatomic, strong) RACCommand *logoutCommand;
@property (nonatomic, strong) NSURL *userImageURL;
@property (nonatomic, strong) NSString *userName;
-(void)showMailView;

@end
