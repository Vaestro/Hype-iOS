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
	[[_dataManager fetchPlacemarkForAddress:locationEntity.fullAddress] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<CLPlacemark *> *task) {
		[_delegate interactor:self didGetPlacemark:task.result forLocation:locationEntity error:task.error];
		return nil;
	}];
}

//Get One Promotion for Event (MVP ONLY)
- (void)getPromotionForEvent:(NSString *)eventId {
    [[_dataManager fetchPromotionsForEvent:eventId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [_delegate interactor:self didGetPromotion:task.result[0] forEvent:eventId error:task.error];
        return nil;
    }];
}

//- (void)getGuestlistForGuest:(NSString *)guestId forEvent:(NSString *)eventId {
//    [[_dataManager fetchGuestlistForGuest:guestId forEvent:eventId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
//        [_delegate interactor:self didGetGuestlist:task.result[0] forGuest:guestId forEvent:eventId error:task.error];
//        return nil;
//    }];
//}

- (void)getGuestlistForGuest:(NSString *)guestId forEvent:(NSString *)eventId {
    [[_dataManager fetchGuestlistForGuest:guestId forEvent:eventId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if ([task.result count] == 0) {
            [_delegate interactor:self didGetGuestlist:nil forGuest:guestId forEvent:eventId error:task.error];
        } else {
            [_delegate interactor:self didGetGuestlist:task.result[0] forGuest:guestId forEvent:eventId error:task.error];
        }
        return nil;
    }];
}


@end
