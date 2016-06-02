//
//  THLEventDetailsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFObject.h>


@protocol THLEventDetailsViewControllerDelegate <NSObject>
- (void)eventDetailsWantsToPresentAdmissionsForEvent:(PFObject *)event;
- (void)eventDetailsWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo;
- (void)eventDetailsWantsToPresentPartyForEvent:(PFObject *)guestlistInvite;

@end

@interface THLEventDetailsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<THLEventDetailsViewControllerDelegate> delegate;

- (id)initWithEvent:(PFObject *)event guestlistInvite:(PFObject *)guestlistInvite showNavigationBar:(BOOL)showNavigationBar;
@end

