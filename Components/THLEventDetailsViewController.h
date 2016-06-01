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

@end

@interface THLEventDetailsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<THLEventDetailsViewControllerDelegate> delegate;

- (id)initWithEvent:(PFObject *)event andShowNavigationBar:(BOOL)showNavigationBar;
- (id)initWithEvent:(PFObject *)event andGuestlistInvite:(PFObject *)guestlistInvite;
@end

