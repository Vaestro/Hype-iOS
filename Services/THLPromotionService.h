//
//  THLPromotionService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPromotionServiceInterface.h"

@class THLParseQueryFactory;
@interface THLPromotionService : NSObject<THLPromotionServiceInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLParseQueryFactory *queryFactory;
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory;


@end
