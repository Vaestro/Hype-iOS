//
//  THLChannelService.h
//  HypeUp
//
//  Created by Александр on 14.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLChannelService : NSObject

- (void)createChannelForGuest:(NSString *)guestId withGuestlist:(NSString *)guestlistId expireEvent:(NSDate *)date;
- (void)createChannelForOwner:(NSString *)ownerId andHost:(NSString *)hostId
                withGuestlist:(NSString *)guestlistId expireEvent:(NSDate *)date;

@end
