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
@end

@interface THLEventDetailsViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<THLEventDetailsViewControllerDelegate> delegate;

- (id)initWithEvent:(PFObject *)event andShowNavigationBar:(BOOL)showNavigationBar;
@end

