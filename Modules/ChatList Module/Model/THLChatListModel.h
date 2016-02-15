//
//  THLChatListModel.h
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLChatListItem.h"

@interface THLChatListModel : NSObject

+ (id)sharedManager;

- (NSInteger)itemsCount;
- (THLChatListItem *)itemAtIndex:(NSUInteger)index;
//- (NSString *)channelAtIndex:(NSUInteger)index;
- (void)getChannelsList;
- (void)requestGetChannels;

@end
