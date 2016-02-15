//
//  THLChatRoomTableView.h
//  HypeUp
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THLChatRoomTableView;
@class THLMessage;

@protocol THLChatTableVeiwDataSource <NSObject>

- (NSUInteger)numberOfItemsInTableView:(THLChatRoomTableView *)tableView;
- (NSUInteger)numberOfSectionInTableView:(THLChatRoomTableView *)tableView;
- (THLMessage *)tableView:(THLChatRoomTableView *)tableView messageAtIndex:(NSUInteger)index;

@end

@protocol THLChatTableVeiwDelegate <NSObject>

- (NSUInteger)numberOfItemsInTableView:(THLChatRoomTableView *)tableView;

@end

@interface THLChatRoomTableView : UIView

@property (nonatomic, weak) id <THLChatTableVeiwDataSource> dataSource;
@property (nonatomic, weak) id <THLChatTableVeiwDelegate> delegate;

- (void)reloadData;
- (void)reloadSection:(NSUInteger)section;
- (void)scrollToBottomWithAnimated:(BOOL)animated;

@end
