//
//  THLMessage.m
//  HypeUp
//
//  Created by Александр on 12.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessage.h"
#import "THLUser.h"

@implementation THLMessage

- (instancetype)initWithResult:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if (data[@"text"] != nil) {
            self.text = data[@"text"];
        }
        if (data[@"time"] != nil) {
            self.time = data[@"time"];
        }
        if (data[@"userID"] != nil) {
            self.userID = data[@"userID"];
        }
        
        self.userImageURL = (data[@"userImageURL"] != nil) ? data[@"userImageURL"] : nil;
        self.userName = (data[@"userName"] != nil) ? data[@"userName"] : nil;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.text = text;
        self.time = @"1123456";
        self.userID = @"qwer1";
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text andUser:(THLUser *)user
{
    self = [super init];
    if (self) {
        self.text = text;
        self.time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        self.userID = user.objectId;
        self.userImageURL = user.image.url;
        self.userName = user.username;
    }
    return self;
}

- (NSDictionary *)toObject {
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.text, @"text",
                                                        self.userID, @"userID",
                                                        self.time, @"time",
                                                        [THLUser currentUser].image.url, @"userImageURL",
                                                        self.userName, @"userName", nil];
}


@end
