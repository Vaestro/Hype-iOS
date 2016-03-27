//
//  THLChatRoomModel.h
//  Hype
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubNub.h"
#import "Pubnub+History.h"
#import "THLPubnubManager.h"
#import "THLMessage.h"

@interface THLChatRoomModel : NSObject

+ (id)sharedManager;
- (void)requestDataWithChannel:(NSString *)channel;
- (void)updateDataWithResult:(PNMessageResult *)result;
- (void)setupData:(NSString *)channel;
- (NSInteger)itemsCount;
- (THLMessage *)itemAtIndex:(NSUInteger)index;

@property (nonatomic, strong) NSArray * data;
@property (nonatomic, strong) PNHistoryResult *history;

@end
