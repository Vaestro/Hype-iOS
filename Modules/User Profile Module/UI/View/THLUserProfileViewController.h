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
@interface THLUserProfileViewController : UIViewController
<
THLUserProfileView,
UITableViewDelegate,
UITableViewDataSource,

UIWebViewDelegate,
MFMailComposeViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;


@end
