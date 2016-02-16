//
//  THLPubnubManager.h
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pubnub.h>
#import "Pubnub+History.h"
#import "THLPubnubManagerDelegate.h"
#import "THLMessage.h"


@interface THLPubnubManager : NSObject

+ (id)sharedInstance;

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, weak) id<THLPubnubManagerDelegate> delegate;

- (void)setup;
- (NSArray *)fetchAllChannels;
- (NSArray *)fetchHistory;
- (void)didRegisterForRemoteToken:(NSData *)deviceToken;
- (void)fetchHistoryWithCompletion:(void (^)(NSArray *))success;
- (void)fetchHistoryForChannel:(NSString *)channel withCompletion:(void (^)(PNHistoryResult *))success;

- (void)publishMessage:(THLMessage *)message withChannel:(NSString *)channel withCompletion:(void (^)(NSString *))success;
- (void)publishFirstMessageFromChannel:(NSString *)channel withUser:(NSString *)userID;
- (void)subscribeWithChannels:(NSArray *)channels;

@end
