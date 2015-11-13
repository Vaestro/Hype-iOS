//
//  THLUserProfileViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLUserProfileView.h"
#import "THLUserProfileInfoView.h"

@protocol THLUserProfileView;
@interface THLUserProfileViewController : UIViewController
<
THLUserProfileView,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;


@end
