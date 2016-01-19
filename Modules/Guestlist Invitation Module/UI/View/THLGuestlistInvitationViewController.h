//
//  THLGuestlistInvitationViewController.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLGuestlistInvitationView.h"
#import "THContactPickerView.h"
#import "FXBlurView.h"

@protocol THContactPickerDelegate;
@protocol THLGuestlistInvitationView;
@class THContactPickerView;
@class RACCommand;

@interface THLGuestlistInvitationViewController : UIViewController
<
THLGuestlistInvitationView,
UITableViewDelegate,
THContactPickerDelegate
>
//@property (nonatomic, strong) id<THLGuestlistInvitationViewEventHandler> eventHandler;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, strong) UIView *invitationDetailsView;
@property (nonatomic, strong) UILabel *invitationDetailsLabel;

@property (nonatomic) BOOL newAdditions;
@property (nonatomic, strong) NSMutableSet *addedGuests;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *commitButton;
@property (nonatomic, strong) RACCommand *cancelCommand;
@property (nonatomic, strong) RACCommand *commitCommand;
@end
