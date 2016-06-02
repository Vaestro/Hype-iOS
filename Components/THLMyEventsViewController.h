//
//  THLMyEventsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/23/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "UIScrollView+EmptyDataSet.h"

@protocol THLMyEventsViewDelegate <NSObject>
- (void)usersWantsToLogin;
- (void)didSelectViewEventTicket:(PFObject *)guestlistInvite;
@end

@interface THLMyEventsViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, weak) id<THLMyEventsViewDelegate> delegate;

@end
