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
#import "UIScrollView+EmptyDataSet.h"
#import "THLAppearanceConstants.h"
const CGFloat kChatListRowHeight = 90.0;
static NSString * const kChatListCellIdentifier = @"THLChatListCell";

@interface THLChatListTableView ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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
    table.emptyDataSetSource = self;
    table.emptyDataSetDelegate = self;
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

#pragma mark - EmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    text = @"You do not have any messages";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: kTHLNUIAccentColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @" ";
    text = @"When you join a party for an event, you will see your messages here";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return kTHLNUISecondaryBackgroundColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
