//
//  THLChatListTableView.h
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLChatListTableView;
@class THLChatListItem;

@protocol THLChatListTableViewDataSource <NSObject>

- (NSUInteger)numberOfItemsInTableView:(THLChatListTableView *)tableView;
- (NSUInteger)numberOfSectionInTableView:(THLChatListTableView *)tableView;
- (THLChatListItem *)tableView:(THLChatListTableView *)tableView itemAtIndex:(NSUInteger)index;
//- (CGFloat)heightForRowAtIndex:(NSInteger)index;

@end

@protocol THLChatListTableViewDelegate <NSObject>

- (NSUInteger)numberOfItemsInTableView:(THLChatListTableView *)tableView;
- (void)tableView:(THLChatListTableView *)tableView didSelectItemAtIndex:(NSUInteger)index;

@end

@interface THLChatListTableView : UIView

@property (nonatomic, weak) id <THLChatListTableViewDataSource> dataSource;
@property (nonatomic, weak) id <THLChatListTableViewDelegate> delegate;

- (void)reloadData;

@end
