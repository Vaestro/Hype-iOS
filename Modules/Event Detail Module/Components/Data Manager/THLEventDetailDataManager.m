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

@implementation THLEventDetailDataManager
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper {
	if (self = [super init]) {
		_locationService = locationService;
		_promotionService = promotionService;
        _guestlistService = guestlistService;
		_entityMapper = entityMapper;
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

- (BFTask *)checkValidGuestlistInviteForEvent:(NSString *)eventId {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistInviteForEvent:eventId] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInvite *fetchedGuestlistInvite = task.result;
        THLGuestlistInviteEntity *mappedGuestlistInvite = [WSELF.entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
        return mappedGuestlistInvite;
    }];
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
