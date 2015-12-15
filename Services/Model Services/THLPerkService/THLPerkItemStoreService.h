//
//  THLPerkItemStoreService.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkItemStoreServiceInterface.h"

@class THLParseQueryFactory;

@interface THLPerkItemStoreService : NSObject<THLPerkItemStoreServiceInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLParseQueryFactory *queryFactory;
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory;
@end
