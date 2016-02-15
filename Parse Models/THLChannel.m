//
//  THLChannel.m
//  HypeUp
//
//  Created by Александр on 13.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChannel.h"

@implementation THLChannel

@dynamic hostId;
@dynamic ownerId;
@dynamic eventId;
@dynamic guestId;
@dynamic guestlistId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Channel";
}

@end
