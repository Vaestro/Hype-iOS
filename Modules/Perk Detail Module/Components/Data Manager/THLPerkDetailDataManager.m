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
#import "THLPerkStoreItemEntity.h"
#import "THLUser.h"
#import "Parse.h"



@implementation THLPerkDetailDataManager : NSObject
- (instancetype)initWithPerkStoreItemService:(id<THLPerkItemStoreServiceInterface>)perkStoreItemService entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _perkStoreItemService = perkStoreItemService;
        _entityMapper = entityMapper;
    }
    return self;
}

- (BFTask *)purchasePerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItem {
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [PFCloud callFunctionInBackground:@"purchasePerkStoreItem"
                       withParameters:@{@"perkStoreItemId" : perkStoreItem.objectId,
                                        @"perkStoreItemCost" : [[NSNumber alloc] initWithFloat:perkStoreItem.credits]
                                        }
                                block:^(id object, NSError *error) {
                                    if (!error){
                                        [completionSource setResult:nil];
                                    } else {
                                        [completionSource setError:error];
                                    }}];

    return completionSource.task;
}

@end
