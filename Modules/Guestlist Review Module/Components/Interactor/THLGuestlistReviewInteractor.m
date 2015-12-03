//
//  THLGuestlistReviewInteractor.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewInteractor.h"
#import "THLGuestlistReviewDataManager.h"
#import "THLViewDataSourceFactoryInterface.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestEntity.h"

static NSString *const kTHLGuestlistReviewModuleViewKey = @"kTHLGuestlistReviewModuleViewKey";
@class THLGuestlistInviteEntity;

@interface THLGuestlistReviewInteractor()
@end

@implementation THLGuestlistReviewInteractor
- (instancetype)initWithDataManager:(THLGuestlistReviewDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
    }
    return self;
}

- (void)setGuestlistEntity:(THLGuestlistEntity *)guestlistEntity {
    _guestlistEntity = guestlistEntity;
}

- (void)updateGuestlistInvites {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager fetchGuestlistInvitesForGuestlist:_guestlistEntity] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
//        Store guests in Memory In case User wants to Add more Guests
        [SSELF collectGuestsPhoneNumbers:task.result];
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInvites:task.error];
        return nil;
    }];
}

- (void)collectGuestsPhoneNumbers:(NSSet *)guestlistInvites {
    NSArray *invitesArray = [guestlistInvites allObjects];
    _guests = [invitesArray linq_select:^id(THLGuestlistInviteEntity *guestlistInvite) {
        return guestlistInvite.guest.phoneNumber;
    }];
}

- (THLViewDataSource *)generateDataSource {
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:[NSString stringWithFormat:@"kTHLGuestlistId:%@", _guestlistEntity.objectId]];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestlistInviteEntity class]]) {
            if ([[[entity valueForKey:@"guestlist"] valueForKey:@"objectId"] isEqualToString:_guestlistEntity.objectId]) {
                return collection;
            }
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLGuestlistInviteEntity *guestlistInvite1 = (THLGuestlistInviteEntity *)entity1;
        THLGuestlistInviteEntity *guestlistInvite2 = (THLGuestlistInviteEntity *)entity2;
        return [[NSNumber numberWithInteger:guestlistInvite2.response] compare:[NSNumber numberWithInteger:guestlistInvite1.response]];
    }];
}

#pragma mark - Handle Presenter Events
- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager updateGuestlistInvite:guestlistInvite withResponse:response] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInviteResponse:task.error to:response];
        return nil;
    }];
}

- (void)updateGuestlist:(THLGuestlistEntity *)guestlist withReviewStatus:(THLStatus)reviewStatus {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager updateGuestlist:guestlist withReviewStatus:reviewStatus] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistReviewStatus:task.error to:reviewStatus];
        return nil;
    }];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
