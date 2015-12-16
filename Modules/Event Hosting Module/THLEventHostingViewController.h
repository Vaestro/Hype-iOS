//
//  THLEventHostingViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLEventHostingView.h"
#import "UIScrollView+EmptyDataSet.h"

@protocol THLEventHostingView;
@interface THLEventHostingViewController : UIViewController
<
THLEventHostingView,
UITableViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@end
