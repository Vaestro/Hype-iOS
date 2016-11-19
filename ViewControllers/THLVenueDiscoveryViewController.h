//
//  THLVenueDiscoveryViewController.h
//  Hype
//
//  Created by Edgar Li on 6/22/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryCollectionViewController.h>
#import "UIScrollView+EmptyDataSet.h"

@protocol THLVenueDiscoveryViewControllerDelegate <NSObject>
- (void)venueDiscoveryViewControllerWantsToPresentDetailsForVenue:(PFObject *)venue;
@end

@interface THLVenueDiscoveryViewController : PFQueryCollectionViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@property (nonatomic, weak) id<THLVenueDiscoveryViewControllerDelegate> delegate;

@end
