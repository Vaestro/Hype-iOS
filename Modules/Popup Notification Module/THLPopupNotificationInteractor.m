//
//  THLPopupNotificationInteractor.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationInteractor.h"
#import "THLPopupNotificationDataManager.h"

static NSString *const kPushInfoKeyGuestlistInviteId = @"guestlistInviteId";

@interface THLPopupNotificationInteractor()

@end

@implementation THLPopupNotificationInteractor
- (instancetype)initWithDataManager:(THLPopupNotificationDataManager *)dataManager {
    if (self = [super init]) {
        _dataManager = dataManager;
    }
    return self;
}

- (BFTask *)handleNotificationData:(NSDictionary *)pushInfo {
    NSString *guestlistInviteId = pushInfo[kPushInfoKeyGuestlistInviteId];
    return [_dataManager fetchGuestlistInviteWithId:guestlistInviteId];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end