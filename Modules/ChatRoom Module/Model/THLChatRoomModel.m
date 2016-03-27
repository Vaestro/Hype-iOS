//
//  THLChatRoomModel.m
//  Hype
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatRoomModel.h"

NSString *const kDataMessagesNotification = @"kDataMessageNotification";

@interface THLChatRoomModel ()

@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation THLChatRoomModel

+ (id)sharedManager {
    static THLChatRoomModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)setupData:(NSString *)channel {
    [[THLPubnubManager sharedInstance] fetchHistoryForChannel:channel withCompletion:^(PNHistoryResult *result) {
        self.messages = [[NSMutableArray alloc] init];
        for (NSDictionary *item in result.data.messages) {
            THLMessage *message;
            if ([item isKindOfClass:[NSDictionary class]]) {
                message = [[THLMessage alloc] initWithResult:item];
            } else if ([item isKindOfClass:[NSString class]]) {
                message = [[THLMessage alloc] initWithText:(NSString *)item];
            }
            [self.messages addObject:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kDataMessagesNotification object:nil];
    }];
}

- (void)requestDataWithChannel:(NSString *)channel {
    [self setupData:channel];
}

- (void)updateDataWithResult:(PNMessageResult *)result {
    if (result.data.message != nil) {
        THLMessage *message = [[THLMessage alloc] initWithResult:result.data.message];
        [self.messages insertObject:message atIndex:self.messages.count];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataUpdateMessageNotification" object:nil];
}

- (NSInteger)itemsCount {
    if (self.messages != nil) {
        return self.messages.count;
    }
    return 0;
}

- (THLMessage *)itemAtIndex:(NSUInteger)index {
    return self.messages[index];
}

@end
