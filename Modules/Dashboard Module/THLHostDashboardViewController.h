//
//  THLHostDashboardViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLHostDashboardView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface THLHostDashboardViewController : UIViewController
<
THLHostDashboardView,
UICollectionViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end
