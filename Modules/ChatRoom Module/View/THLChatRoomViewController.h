//
//  THLChatRoomViewController.h
//  HypeUp
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLChatRoomTableView.h"
#import "THLChatRoomInputTextView.h"
#import "THLChatListItem.h"

@interface THLChatRoomViewController : UIViewController

- (instancetype)initWithChannel:(THLChatListItem *)chatItem;
- (void)presentInterfaceInWindow:(UIWindow *)window;

@end
