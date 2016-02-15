//
//  THLChatListItem.m
//  HypeUp
//
//  Created by Александр on 13.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatListItem.h"
#import <PubNub+History.h>
#import <PubNub/PubNub.h>
#import "THLMessage.h"

@implementation THLChatListItem

- (instancetype)initWithResult:(PNHistoryResult *)result
{
    self = [super init];
    if (self) {
        THLMessage * message = [[THLMessage alloc] initWithResult:result.data.messages.lastObject];
        if (message != nil) {
            self.lastMessage = message.text;
            self.imageURL = message.userImageURL;
            self.time = message.time;
        }
    }
    return self;
}

- (instancetype)initWithChannel:(NSString *)channel andTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.channel = channel;
        self.title = title;
    }
    return self;
}

@end
