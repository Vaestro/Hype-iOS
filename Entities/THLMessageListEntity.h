//
//  THLMessageListEntity.h
//  Hype
//
//  Created by Александр on 04.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "THLMessageListEntity.h"

@interface THLMessageListEntity : THLEntity
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lastMessage;
@property (nonatomic, copy) NSString *time;
@property (nonatomic) NSInteger unreadMessageCount;
@property (nonatomic, copy) NSURL *image;
//@property (nonatomic, strong) THLUser *user;
@end
