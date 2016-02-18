//
//  THLChatListTableView.m
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatListTableView.h"
#import "THLChatListCell.h"
#import "THLChatListItem.h"
#import <UIScrollView+SVPullToRefresh.h>

const CGFloat kChatListRowHeight = 90.0;
static NSString * const kChatListCellIdentifier = @"THLChatListCell";

@interface THLChatListTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THLChatListTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [self newTableView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)newTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    table.backgroundColor = UIColor.clearColor;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerNib:[UINib nibWithNibName:kChatListCellIdentifier bundle:nil] forCellReuseIdentifier:kChatListCellIdentifier];
    table.dataSource = self;
    table.delegate = self;
    table.estimatedRowHeight = kChatListRowHeight;
    table.rowHeight = UITableViewAutomaticDimension;
    return table;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfSectionInTableView:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kChatListRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THLChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatListCellIdentifier forIndexPath:indexPath];
    THLChatListItem *item = [self.dataSource tableView:self itemAtIndex:indexPath.row];
    [cell configureCell:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.delegate tableView:self didSelectItemAtIndex:indexPath.row];
}

#pragma mark - Data

- (void)reloadData {
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
