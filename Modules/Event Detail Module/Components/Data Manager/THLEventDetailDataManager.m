//
//  THLEventDetailDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailDataManager.h"

//Services
#import "THLLocationServiceInterface.h"
#import "THLPromotionServiceInterface.h"
#import "THLGuestlistServiceInterface.h"
#import "THLEntityMapper.h"

#import "THLUser.h"
#import "THLEventEntity.h"
#import "THLYapDatabaseManager.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistEntity.h"

@interface THLEventDetailDataManager()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@property (nonatomic, strong) YapDatabaseConnection *roConnection;

@end

@implementation THLEventDetailDataManager
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper
                        databaseManager:(THLYapDatabaseManager *)databaseManager{
	if (self = [super init]) {
		_locationService = locationService;
		_promotionService = promotionService;
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        _databaseManager = databaseManager;
	}
	return self;
}

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address {
	return [_locationService geocodeAddress:address];
}

- (BFTask *)fetchPromotionForEvent:(NSString *)eventId {
    WEAKSELF();
	return [[_promotionService fetchPromotionForEvent:eventId] continueWithSuccessBlock:^id(BFTask *task) {
		THLPromotion *fetchedPromotion = task.result;
		THLPromotionEntity *mappedPromotion = [WSELF.entityMapper mapPromotion:fetchedPromotion];
		return mappedPromotion;
	}];
}

- (YapDatabaseConnection *)rwConnection {
    if (!_rwConnection) {
        _rwConnection = [_databaseManager newDatabaseConnection];
    }
    return _rwConnection;
}

- (YapDatabaseConnection *)roConnection {
    if (!_roConnection) {
        _roConnection = [_databaseManager newDatabaseConnection];
    }
    return _roConnection;
}

- (BFTask *)fetchGuestlistInviteForUser:(THLUser *)user atEvent:(THLEventEntity *)event {
    WEAKSELF();
//    STRONGSELF();
//    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
//    __block THLGuestlistInviteEntity *guestlistInvite;
//    [self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
//        [transaction enumerateKeysAndObjectsInCollection:@"kTHLGuestlistInviteEntityDataStoreKey" usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
//            NSLog(@"Object is:%@", object);
//            if ([[(THLGuestlistInviteEntity *)object guestlist].eventId isEqualToString:event.objectId]) {
//                guestlistInvite = (THLGuestlistInviteEntity *)object;
//            }
//        }];
//    }];
//    [completionSource setResult:guestlistInvite];
//    return completionSource.task;
    
    return [[_guestlistService fetchGuestlistInviteForUser:user atEvent:event] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInvite *fetchedGuestlistInvite = task.result;
        THLGuestlistInviteEntity *mappedGuestlistInvite = [WSELF.entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
        // Add an object
        [self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction setObject:mappedGuestlistInvite forKey:mappedGuestlistInvite.objectId inCollection:@"kTHLGuestlistInviteEntityDataStoreKey"];
        }];
        
        // Read it back
        [self.roConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            NSLog(@"%@ World", [transaction objectForKey:mappedGuestlistInvite.objectId inCollection:@"kTHLGuestlistInviteEntityDataStoreKey"]);
        }];
        
        return mappedGuestlistInvite;
    }];
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
