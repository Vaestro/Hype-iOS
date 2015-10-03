//
//  THLGuestlistInvitationViewController.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THContactPickerView;
@protocol THLGuestlistInvitationView;
@protocol THContactPickerDelegate;

@interface THLGuestlistInvitationViewController : UIViewController
<
THLGuestlistInvitationView,
UITableViewDelegate,
UITableViewDataSource,
THContactPickerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) THContactPickerView *contactPickerView;

@end
