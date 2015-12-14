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
#import "THLGuestEntity.h"

@interface THLEventDetailDataManager()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@property (nonatomic, strong) YapDatabaseConnection *roConnection;
@property (nonatomic, strong) YapDatabaseConnection *connection;
@property (nonatomic, strong) THLEventEntity *event;
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
        [self addGuestlistInviteObserver];
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

- (YapDatabaseConnection *)connection {
    if (!_connection) {
        _connection = [_databaseManager newDatabaseConnection];
    }
    return _connection;
}

- (BFTask *)fetchGuestlistInviteForEvent:(THLEventEntity *)event {
    _event = event;
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    __block THLGuestlistInviteEntity *guestlistInvite;
    [self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        [transaction enumerateKeysAndObjectsInCollection:@"kUserDataStoreKey" usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            if ([[(THLGuestlistInviteEntity *)object guestlist].eventId isEqualToString:event.objectId] &&
                [[(THLGuestlistInviteEntity *)object guest].objectId isEqualToString:[THLUser currentUser].objectId]) {
                guestlistInvite = (THLGuestlistInviteEntity *)object;
            }
        }];
    }];
    [completionSource setResult:guestlistInvite];
    return completionSource.task;
    
//    return [[_guestlistService fetchGuestlistInviteForUser:user atEvent:event] continueWithSuccessBlock:^id(BFTask *task) {
//        THLGuestlistInvite *fetchedGuestlistInvite = task.result;
//        THLGuestlistInviteEntity *mappedGuestlistInvite = [WSELF.entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
//        // Add an object
//        [self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
//            [transaction setObject:mappedGuestlistInvite forKey:mappedGuestlistInvite.objectId inCollection:@"kTHLGuestlistInviteEntityDataStoreKey"];
//        }];
//        
//        // Read it back
//        [self.roConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
//            NSLog(@"%@ World", [transaction objectForKey:mappedGuestlistInvite.objectId inCollection:@"kTHLGuestlistInviteEntityDataStoreKey"]);
//        }];
//        
//        return mappedGuestlistInvite;
//    }];
}

- (void)addGuestlistInviteObserver {
    [self.connection beginLongLivedReadTransaction];
    
    // Register for notifications of changes to the database.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yapDatabaseModified:)
                                                 name:YapDatabaseModifiedNotification
                                               object:_connection.database];
}

- (void)yapDatabaseModified:(NSNotification *)notification
{
    // Jump to the most recent commit.
    // End & Re-Begin the long-lived transaction atomically.
    // Also grab all the notifications for all the commits that I jump.
    NSArray *notifications = [_connection beginLongLivedReadTransaction];
    WEAKSELF();
    STRONGSELF();
    // Update views if needed
    if ([_connection hasChangeForCollection:@"kUserDataStoreKey" inNotifications:notifications]) {
        [[self fetchGuestlistInviteForEvent:_event] continueWithSuccessBlock:^id(BFTask *task) {
            [SSELF.delegate dataManager:SSELF didGetNotifiedAboutNewGuestlistInvite:task.result forEvent:_event error:task.error];
            return nil;
        }];
    }
    
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
