//
//  THLMessageListService.h
//  HypeUp
//
//  Created by Александр on 08.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListServiceInterface.h"
#import "THLPubnubQueryFactory.h"

@interface THLMessageListService : NSObject<THLMessageListServiceInterface>

@property (nonatomic, readonly) THLPubnubQueryFactory *queryFactory;
- (instancetype)initWithQueryFactory:(THLPubnubQueryFactory *)queryFactory;
@end
