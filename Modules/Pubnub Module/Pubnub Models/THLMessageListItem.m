//
//  THLMessageListItem.m
//  Hype
//
//  Created by Александр on 07.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListItem.h"

@implementation THLMessageListItem

@dynamic lastMessage;

//+ (void)load {
//    [self registerSubclass];
//}

+ (NSString *)parseClassName {
    return @"MessageListItem";
}

@end
