//
//  THLPerkStoreItemService.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreItemService.h"
#import "THLParseQueryFactory.h"

@implementation THLPerkStoreItemService

- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
    if (self = [super init]) {
        _queryFactory = queryFactory;
    }
    return self;
}

- (BFTask *)fetchAllPerkStoreItems {
    return [[_queryFactory queryForAllPerkStoreItems] findObjectsInBackground];
}


@end
