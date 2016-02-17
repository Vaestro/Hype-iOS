//
//  THLPubnubManager.m
//  HypeUp
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLPubnubManager.h"
#import "THLUser.h"
#import "THLHostEntity.h"

@interface THLPubnubManager ()<PNObjectEventListener>

@property (nonatomic, strong) PubNub *client;
@property (nonatomic, strong) PNConfiguration *configuration;

@end

@implementation THLPubnubManager

+ (id)sharedInstance {
    static THLPubnubManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)setup {
    self.configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-a6ad6c13-a9fc-4f6b-aa5c-12b115d5f030" subscribeKey:@"sub-c-9551fcaa-c380-11e5-8a35-0619f8945a4f"];
    self.configuration.uuid = [THLUser currentUser].objectId;
    self.client = [PubNub clientWithConfiguration:self.configuration];
    
    UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound |
                                    UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [self.client addListener:self];
    self.results = [[NSMutableArray alloc] init];
}

- (void)didRegisterForRemoteToken:(NSData *)deviceToken {
    NSData *oldToken = [[NSUserDefaults standardUserDefaults] dataForKey:@"DeviceToken"];
    if (oldToken && [oldToken isEqualToData:deviceToken]) {
        
        // registration token hasn't changed - carry on
        return;
    }
    
    // remove old token from all PubNub channels for push notifications
    [self.client removeAllPushNotificationsFromDeviceWithPushToken:oldToken
                                                     andCompletion:^(PNAcknowledgmentStatus *status) {
                                                         
                                                         NSLog(@"status: %@", status);
                                                         // Check whether request successfully completed or not.
                                                         // if (status.isError) // Handle modification error.
                                                         // Check 'category' property to find out possible issue because
                                                         // of which request did fail. Request can be resent using: [status retry];
                                                     }];
    
    [self.client addPushNotificationsOnChannels:self.client.channels
                            withDevicePushToken:deviceToken andCompletion:^(PNAcknowledgmentStatus *status) {
                                
                                NSLog(@"status: %@", status);
                                if (!status.isError) {
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DeviceToken"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                else {
                                    // Handle modification error. 
                                    // Check 'category' property to find out possible issue because
                                    // of which request did fail. Request can be resent using: [status retry];
                                }
                            }];
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    [self.delegate didReceiveMessage:self withMessage:message];
}

#pragma mark - get methods

- (NSArray *)fetchAllChannels {
    return self.client.channels;
}

- (void)historyForChannel:(NSString *)channel {
    [self.client historyForChannel:channel withCompletion:^(PNHistoryResult *result, PNErrorStatus *status) {
        [self.results addObject:result];
    }];
}

- (void)fetchHistoryWithCompletion:(void (^)(NSArray *))success {
    NSArray *channels = self.client.channels;
    NSMutableArray *history = [[NSMutableArray alloc] init];

    dispatch_sync(dispatch_queue_create("com.meh.sometask", NULL), ^{
        [channels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.client historyForChannel:obj withCompletion:^(PNHistoryResult *result, PNErrorStatus *status) {
                NSDictionary *channelDict = @{@"channel": obj,
                                              @"history": result};
                [history addObject:channelDict];
                if (stop) {
                    success(history);
                }
            }];
        }];
    });
    
    
}

- (void)fetchHistoryForChannel:(NSString *)channel withCompletion:(void (^)(PNHistoryResult *))success {
    [self.client historyForChannel:channel withCompletion:^(PNHistoryResult *result, PNErrorStatus *status) {
        success(result);
    }];
}

- (NSArray *)fetchHistory {
    return [[NSArray alloc] init];
}

- (void)publishMessage:(THLMessage *)message withChannel:(NSString *)channel withCompletion:(void (^)(NSString *))success {
//    [self.client publish:[message toObject] toChannel:channel compressed:YES withCompletion:^(PNPublishStatus *status) {
//        if (status) {
//            success(@"ok");
//        } else {
//            success(@"error");
//        }
//    }];
    
    [self.client publish:[message toObject] toChannel:channel mobilePushPayload:@{@"aps":@{@"alert":message.text}} compressed:YES withCompletion:^(PNPublishStatus *status) {
        //
    }];
}

- (void)publishFirstMessageFromChannel:(NSString *)channel withUser:(THLHostEntity *)user {
    //THLUser *user = [THLUser objectWithoutDataWithObjectId:userID];
    THLMessage *message = [[THLMessage alloc] initWithText:@"Hello, I am host" andHost:user];
    
    [self.client publish:[message toObjectWithUser:user] toChannel:channel mobilePushPayload:@{@"aps":@{@"alert":message.text}} compressed:YES withCompletion:^(PNPublishStatus *status) {
        //
    }];
    
//    [self.client publish:[message toObjectWithUser:user] toChannel:channel compressed:YES withCompletion:^(PNPublishStatus *status) {
//    }];
}

- (void)subscribeWithChannels:(NSArray *)channels {
    [self.client unsubscribeFromAll];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self.client subscribeToChannels:channels withPresence:NO];
}

//- (NSArray *)fetchAllChannels {
//    return self.client.channels;
//}

@end
