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

@protocol THLDashboardView;

@interface THLDashboardViewController : UIViewController
<
THLDashboardView,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

@end
