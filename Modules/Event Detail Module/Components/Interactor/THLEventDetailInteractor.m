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

@implementation THLEventDetailInteractor
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
	}
	return self;
}

- (void)getPlacemarkForLocation:(THLLocationEntity *)locationEntity {
    WEAKSELF();
	[[_dataManager fetchPlacemarkForAddress:locationEntity.fullAddress] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<CLPlacemark *> *task) {
		[_delegate interactor:WSELF didGetPlacemark:task.result forLocation:locationEntity error:task.error];
		return nil;
	}];
}

//Get One Promotion for Event (MVP ONLY)
- (void)getPromotionForEvent:(NSString *)eventId {
    [[_dataManager fetchPromotionForEvent:eventId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        WEAKSELF();
        [_delegate interactor:WSELF didGetPromotion:task.result forEvent:eventId error:task.error];
        return nil;
    }];
}

- (void)checkValidGuestlistInviteForUser:(THLUser *)user atEvent:(NSString *)eventId {
    WEAKSELF();
    [[_dataManager fetchGuestlistInviteForUser:user atEvent:eventId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [_delegate interactor:WSELF didGetGuestlistInvite:task.result forEvent:eventId error:task.error];
        return nil;
    }];
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}

@end
