//
//  THLDiscoveryViewController.h
//  Hype
//
//  Created by Daniel Aksenov on 5/26/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryCollectionViewController.h>
#import "UIScrollView+EmptyDataSet.h"

@protocol THLDiscoveryViewControllerDelegate <NSObject>
- (void)eventDiscoveryViewControllerWantsToPresentDetailsForEvent:(PFObject *)event venue:(PFObject *)venue;
- (void)eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent:(PFObject *)event venue:(PFObject *)venue invite:(PFObject *)invite;
@end

@interface THLDiscoveryViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@property (nonatomic, weak) id<THLDiscoveryViewControllerDelegate> delegate;

@end
