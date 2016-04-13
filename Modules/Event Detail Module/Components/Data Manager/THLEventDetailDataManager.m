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
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper
                        databaseManager:(THLYapDatabaseManager *)databaseManager{
	if (self = [super init]) {
		_locationService = locationService;
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
        [transaction enumerateKeysAndObjectsInCollection:@"kTHLGuestlistInviteEntityDataStoreKey" usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            if ([[(THLGuestlistInviteEntity *)object guestlist].event.objectId isEqualToString:event.objectId]
                && [[(THLGuestlistInviteEntity *)object guest].objectId isEqualToString:[THLUser currentUser].objectId]
                && [(THLGuestlistInviteEntity *)object isAccepted]) {
                guestlistInvite = (THLGuestlistInviteEntity *)object;
            }
        }];
    }];
    [completionSource setResult:guestlistInvite];
    return completionSource.task;
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
    if ([_connection hasChangeForCollection:@"kTHLGuestlistInviteEntityDataStoreKey" inNotifications:notifications]) {
        [[self fetchGuestlistInviteForEvent:_event] continueWithSuccessBlock:^id(BFTask *task) {
            if ([[(THLGuestlistInviteEntity *)task.result guestlist].event.objectId isEqualToString:_event.objectId]
                && [[(THLGuestlistInviteEntity *)task.result guest].objectId isEqualToString:[THLUser currentUser].objectId]
                && [(THLGuestlistInviteEntity *)task.result isAccepted]) {
                [SSELF.delegate dataManager:SSELF didGetNotifiedAboutNewGuestlistInvite:task.result forEvent:WSELF.event error:task.error];
            }
            return nil;
        }];
    }
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
