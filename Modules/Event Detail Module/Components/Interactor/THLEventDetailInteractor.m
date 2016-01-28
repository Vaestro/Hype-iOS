//
//  THLEventDetailInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailInteractor.h"
#import "THLEventDetailDataManager.h"
#import "THLLocationEntity.h"
#import "THLGuestlistInviteEntity.h"

@interface THLEventDetailInteractor()<THLEventDetailDataManagerDelegate>

@end

@implementation THLEventDetailInteractor
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
        _dataManager.delegate = self;
	}
	return self;
}

- (void)getPlacemarkForLocation:(THLLocationEntity *)locationEntity {
    WEAKSELF();
	[[_dataManager fetchPlacemarkForAddress:locationEntity.fullAddress] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<CLPlacemark *> *task) {
		[WSELF.delegate interactor:WSELF didGetPlacemark:task.result forLocation:locationEntity error:task.error];
		return nil;
	}];
}

- (void)checkValidGuestlistInviteForEvent:(THLEventEntity *)event {
    WEAKSELF();
    [[_dataManager fetchGuestlistInviteForEvent:event] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [WSELF.delegate interactor:WSELF didGetGuestlistInvite:task.result forEvent:event error:task.error];
        return nil;
    }];
}

- (void)dataManager:(THLEventDetailDataManager *)dataManager didGetNotifiedAboutNewGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(THLEventEntity *)event error:(NSError *)error {
    [self.delegate interactor:self didGetGuestlistInvite:guestlistInvite forEvent:event error:error];
}
@end
