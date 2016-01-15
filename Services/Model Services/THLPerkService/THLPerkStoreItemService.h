//
//  THLPerkStoreItemService.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkStoreItemServiceInterface.h"

@class THLParseQueryFactory;

@interface THLPerkStoreItemService : NSObject<THLPerkStoreItemServiceInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLParseQueryFactory *queryFactory;
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory;
@end
