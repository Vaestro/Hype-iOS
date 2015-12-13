//
//  THLPerkDetailDataManager.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailDataManager.h"
#import "THLPerkItemStoreServiceInterface.h"
#import "THLEntityMapper.h"
#import "THLUser.h"



@implementation THLPerkDetailDataManager : NSObject
- (instancetype)initWithPerkStoreItemService:(id<THLPerkItemStoreServiceInterface>)perkStoreItemService entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _perkStoreItemService = perkStoreItemService;
        _entityMapper = entityMapper;
    }
    return self;
}

@end
