//
//  THLMyEventsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/23/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryCollectionViewController.h>
#import "UIScrollView+EmptyDataSet.h"

@protocol THLMyEventsViewDelegate <NSObject>
- (void)usersWantsToLogin;
- (void)didSelectViewEventTicket:(PFObject *)guestlistInvite;
- (void)didSelectViewInquiry:(PFObject *)inquiry;
@end

@interface THLMyEventsViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, weak) id<THLMyEventsViewDelegate> delegate;

@end
