//
//  THLEventDiscoveryViewController.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLEventDiscoveryView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface THLEventDiscoveryViewController : UIViewController<
THLEventDiscoveryView,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end
