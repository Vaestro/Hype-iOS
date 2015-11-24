//
//  THLEventHostingDataManager.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingDataManager.h"

#import "THLDataStore.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlistEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"

@interface THLEventHostingDataManager()

@end

@implementation THLEventHostingDataManager
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                     entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _dataStore = dataStore;
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
    }
    return self;
}

- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistsForPromotionAtEvent:eventId] continueWithSuccessBlock:^id(BFTask *task) {
        NSSet *entities = [NSSet setWithArray:[WSELF.entityMapper mapGuestlists:task.result]];
        [_dataStore updateOrAddEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
