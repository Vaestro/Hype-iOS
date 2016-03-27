//
//  THLChatListModel.m
//  Hype
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChatListModel.h"
#import "THLPubnubManager.h"
#import "THLChatListItem.h"
#import "THLParseQueryFactory.h"
#import "THLUser.h"
#import "THLLocation.h"
#import "THLEvent.h"
#import "THLChannel.h"
#import "THLGuestlist.h"

static NSString *const kChannelListRecievedNotification = @"kDataChannelListSetupNotification";

@interface THLChatListModel ()

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSMutableDictionary *allChannels;

@end

@implementation THLChatListModel

+ (id)sharedManager {
    static THLChatListModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSInteger)itemsCount {
    if (self.list != nil) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (THLChatListItem *item in self.list) {
            if (item.lastMessage != nil) {
                [items addObject:item];
            }
        }
        return items.count;
        //return self.list.count;
    }
    return 0;
}

- (THLChatListItem *)itemAtIndex:(NSUInteger)index {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (THLChatListItem *item in self.list) {
        if (item.lastMessage != nil) {
            [items addObject:item];
        }
    }
    return items[index];
    //return self.list[index];
}

- (void)setupData {
    [[THLPubnubManager sharedInstance] fetchHistoryWithCompletion:^(NSArray *result) {
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in result) {
            PNHistoryResult *it = dict[@"history"];
            THLChatListItem *item = [[THLChatListItem alloc] initWithResult:it];
            item.channel = dict[@"channel"];
            item.title = [self locationNameWithChannelId:item.channel];
            [historyList addObject:item];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        self.list = [historyList sortedArrayUsingDescriptors:@[sort]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataChatListSetupNotification" object:nil];
    }];
}

- (void)getChannelsList {
    [self setupData];
}

- (void)requestGetChannels {
    THLParseQueryFactory *factory = [[THLParseQueryFactory alloc] init];
    PFQuery *query = [factory queryAllChannelsForUserID:[THLUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChannelListRecievedNotification object:error];
        } else {
            [self getChannels:objects];
        }
    }];
}

- (void)getChannels:(NSArray *)channels {
    if ([channels isKindOfClass:[NSArray class]]) {
        [[THLPubnubManager sharedInstance] subscribeWithChannels:[self sortChannelsFromObjects:channels]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kChannelListRecievedNotification object:nil];
    } else {
        //error
    }
}

- (NSArray *)sortChannelsFromObjects:(NSArray *)objects {
    NSString *userID = [THLUser currentUser].objectId;
    self.allChannels = [[NSMutableDictionary alloc] init];
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    for (THLChannel *channel in objects) {
        NSComparisonResult order = [channel.guestlistId.date compare:[NSDate date]];
        if (order == NSOrderedAscending || channel.guestlistId == nil) {
            break;
        }
        [self.allChannels setObject:channel.guestlistId.event forKey:channel.guestlistId.objectId];
        THLUser *guest = channel.guestId;
        THLUser *owner = channel.ownerId;
        THLUser *host = channel.hostId;
        
        if ([guest.objectId isEqualToString:userID]) {
            [channels addObject:[NSString stringWithFormat:@"%@_Group", channel.guestlistId.objectId]];
        } else if ([owner.objectId isEqualToString:userID]) {
            [channels addObject:[NSString stringWithFormat:@"%@_Group", channel.guestlistId.objectId]];
            [channels addObject:[NSString stringWithFormat:@"%@_Host", channel.guestlistId.objectId]];
        } else if ([host.objectId isEqualToString:userID]) {
            [channels addObject:[NSString stringWithFormat:@"%@_Host", channel.guestlistId.objectId]];
        }
    }
    return channels;
}

- (NSString *)locationNameWithChannelId:(NSString *)channelId {
    NSArray *channelComponents = [channelId componentsSeparatedByString:@"_"];
    NSString *channelObject = channelComponents.firstObject;
    NSString *channelType = channelComponents.lastObject;
    THLEvent *event = self.allChannels[channelObject];
    THLLocation *location = event.location;
    NSString *titleChatItem = [NSString stringWithFormat:@"%@ @ %@ %@", channelType, location.name, event.date.thl_dayString];
    return titleChatItem;
}


@end
