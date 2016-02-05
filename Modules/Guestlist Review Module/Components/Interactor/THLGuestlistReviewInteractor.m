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
#import "THLEventEntity.h"
#import "THLLocationEntity.h"
#import "AFNetworking.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "THLUser.h"
#import "THLHostEntity.h"
#import "THLBeacon.h"
#import "THLBeaconEntity.h"



#define kServerBaseURL @"https://hypelistnyc.parseapp.com"
#define kTokenEndpoint @"authenticate"

static NSString *const kTHLGuestlistReviewModuleViewKey = @"kTHLGuestlistReviewModuleViewKey";
//@class THLGuestlistInviteEntity;

@interface THLGuestlistReviewInteractor()
<
ESTBeaconManagerDelegate
>
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
//@property (nonatomic, strong) CLRegion *venueRegion;
//@property (nonatomic, strong) CLLocation *venueLocation;
@end

@implementation THLGuestlistReviewInteractor
- (instancetype)initWithDataManager:(THLGuestlistReviewDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        self.beaconManager = [ESTBeaconManager new];
        _beaconManager.delegate = self;
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
        
    }
    return self;
}

- (void)setGuestlistEntity:(THLGuestlistEntity *)guestlistEntity {
    _guestlistEntity = guestlistEntity;
}

- (void)setGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite {
    _guestlistInvite = guestlistInvite;
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
            THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
//            TODO: Temporary fix for owner's guestlist invite showing up twice
            if ([guestlistInviteEntity.guestlist.objectId isEqualToString:_guestlistEntity.objectId]
                && guestlistInviteEntity.response != THLStatusDeclined) {
                return [NSString stringWithFormat:@"kTHLGuestlistId:%@", _guestlistEntity.objectId];
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

- (void)generateToken {
    WEAKSELF();
    STRONGSELF();
    NSURL *baseURL = [NSURL URLWithString:kServerBaseURL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:baseURL];
    
    [manager GET:kTokenEndpoint parameters:@{@"clientName": [THLUser currentUser].phoneNumber} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SSELF.delegate interactor:SSELF didGetToken:responseObject[@"token"]];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
}

#pragma mark - Handle Location Check In
- (void)checkInForGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite {
    
    _guestlistInvite = guestlistInvite;
    switch ([ESTBeaconManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self askForPermission];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            [self setUpGeofences];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showSorryAlert];
            break;
    }

}

-(void)askForPermission {
    if ([self.beaconManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.beaconManager requestAlwaysAuthorization];
    } else {
        [self setUpGeofences];
    }
}

- (void)setUpGeofences {
    
    
    self.beaconRegion = [[CLBeaconRegion alloc]
     initWithProximityUUID:[[NSUUID alloc]
                            initWithUUIDString:_guestlistEntity.event.host.beacon.UUID]
     major:_guestlistEntity.event.host.beacon.major.integerValue
     minor:_guestlistEntity.event.host.beacon.minor.integerValue
     identifier:@"beacon"];
    
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

//    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
}

- (void)showSorryAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"Need to enable location services in your settings"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}




- (void)beaconManager:(id)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
   CLBeacon *nearestBeacon = beacons.firstObject;
    
    if (nearestBeacon.proximity == CLProximityImmediate) {
        [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
        [self updateGuestlistInvite:_guestlistInvite withCheckInStatus:YES];
    } else {
         [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
         [self updateGuestlistInvite:_guestlistInvite withCheckInStatus:NO];
    }
    
}


- (void)beaconManager:(id)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"%@", error);
}


//- (void)beaconManager:(id)manager didStartMonitoringForRegion:(CLBeaconRegion *)region {
//    NSLog(@"%@", region);
//    [self.beaconManager stopMonitoringForRegion:_beaconRegion];
//}



#pragma mark - Handle Presenter Events
- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager updateGuestlistInvite:guestlistInvite withResponse:response] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInviteResponse:task.error to:response];
        return nil;
    }];
}


- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withCheckInStatus:(BOOL)status {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager updateGuestlistInvite:guestlistInvite withCheckInStatus:status] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInviteCheckInStatus:task.error to:status];
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
