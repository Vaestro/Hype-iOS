//
//  THLChatRoomTableView.m
//  HypeUp
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatRoomTableView.h"
#import "THLChatRoomBubbleCell.h"

NSString * const BUBLE_CELL_IDENTIFIER = @"THLChatRoomBubbleCell";

@interface THLChatRoomTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THLChatRoomTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = UIColor.clearColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:BUBLE_CELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:BUBLE_CELL_IDENTIFIER];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.estimatedRowHeight = 77.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    NSInteger section = [self.dataSource numberOfSectionInTableView:self];
    if (section > 0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:0 inSection: section - 1];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: animated];
    }
}

#pragma mark - Data

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)reloadSection:(NSUInteger)section {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section - 2] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.tableView setFrame:frame];
    [self scrollToBottomWithAnimated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionInTableView:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    THLChatRoomBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:BUBLE_CELL_IDENTIFIER forIndexPath:indexPath];

    [cell setMessage:[self.dataSource tableView:self messageAtIndex:indexPath.section]];
    //[cell setMessage:@"This is long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long TEXT"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}


@end
