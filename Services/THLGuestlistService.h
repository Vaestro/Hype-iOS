//
//  THLGuestlistService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistServiceInterface.h"

@class THLParseQueryFactory;
@interface THLGuestlistService : NSObject<THLGuestlistServiceInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLParseQueryFactory *queryFactory;
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory;

@end
