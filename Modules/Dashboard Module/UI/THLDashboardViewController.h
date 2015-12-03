//
//  THLDashboardViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLDashboardView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface THLDashboardViewController : UIViewController
<
THLDashboardView,
UICollectionViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end
