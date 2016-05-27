//
//  THLMyEventsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/23/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@protocol THLMyEventsViewDelegate <NSObject>
- (void)didSelectViewEventTicket:(PFObject *)guestlistInvite;
@end

@interface THLMyEventsViewController : PFQueryCollectionViewController
@property (nonatomic, weak) id<THLMyEventsViewDelegate> delegate;

@end
