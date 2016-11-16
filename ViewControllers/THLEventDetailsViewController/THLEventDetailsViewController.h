//
//  THLEventDetailsViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@protocol THLEventDetailsViewControllerDelegate <NSObject>
- (void)eventDetailsWantsToPresentAdmissionsForEvent:(PFObject *)event venue:(PFObject *)venue;
- (void)eventDetailsWantsToPresentPartyForEvent:(PFObject *)guestlistInvite;
@end

@interface THLEventDetailsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<THLEventDetailsViewControllerDelegate> delegate;

- (id)initWithVenue:(PFObject *)venue event:(PFObject *)event guestlistInvite:(PFObject *)guestlistInvite showNavigationBar:(BOOL)showNavigationBar;
@end

