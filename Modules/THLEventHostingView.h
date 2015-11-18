//
//  THLEventHostingView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;

@protocol THLEventHostingView <NSObject>
@property (nonatomic, strong) THLViewDataSource *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RACCommand *selectedIndexPathCommand;
@property (nonatomic, strong) RACCommand *refreshCommand;
@property (nonatomic) BOOL showRefreshAnimation;
- (void)showDetailsView:(UIView *)detailView;
- (void)hideDetailsView:(UIView *)detailView;
@end
