//
//  THLPerkItemStoreService.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkItemStoreService.h"
#import "THLParseQueryFactory.h"


@implementation THLPerkItemStoreService

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
