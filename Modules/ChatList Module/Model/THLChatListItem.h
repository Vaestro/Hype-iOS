//
//  THLChatListItem.h
//  Hype
//
//  Created by Александр on 13.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PubNub+History.h>

@interface THLChatListItem : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *lastMessage;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *unReadMessage;
@property (nonatomic, strong) NSString *channel;

- (instancetype)initWithResult:(PNHistoryResult *)data;
- (instancetype)initWithChannel:(NSString *)channel andTitle:(NSString *)title;

@end
