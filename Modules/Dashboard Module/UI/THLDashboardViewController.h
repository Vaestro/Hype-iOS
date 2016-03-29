//
//  THLDashboardViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@class THLViewDataSource;

@interface THLDashboardViewController : UIViewController
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic, strong) THLViewDataSource *dataSource;
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic) BOOL showRefreshAnimation;
@property (nonatomic) NSNumber *unopenedInviteCount;
@property (nonatomic) BOOL viewAppeared;

@end
