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
#import <EstimoteSDK/EstimoteSDK.h>
#import "THLUser.h"
#import "THLHostEntity.h"
#import "THLBeacon.h"
#import "THLBeaconEntity.h"
#import "THLParseQueryFactory.h"
#import <KVNProgress/KVNProgress.h>
#import "THLEntityMapper.h"
#import "THLGuestlist.h"



#define kServerBaseURL @"https://hypelistnyc.parseapp.com"
#define kTokenEndpoint @"authenticate"

static NSString *const kTHLGuestlistReviewModuleViewKey = @"kTHLGuestlistReviewModuleViewKey";
//@class THLGuestlistInviteEntity;

@interface THLGuestlistReviewInteractor()
<
ESTBeaconManagerDelegate,
CLLocationManagerDelegate
>
//@property (nonatomic) ESTBeaconManager *beaconManager;
//@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) int counter;
@property (nonatomic, strong) CLRegion *venueRegion;
@property (nonatomic, strong) CLLocation *venueLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *center;
@end

@implementation THLGuestlistReviewInteractor
- (instancetype)initWithDataManager:(THLGuestlistReviewDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        self.locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        
        
//        self.beaconManager = [ESTBeaconManager new];
//        _beaconManager.delegate = self;
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
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self setUpGeofences];
    }
}

- (void)setUpGeofences {
    
//    _counter = 0;
    
    _center = [[CLLocation alloc]initWithLatitude:_guestlistEntity.event.location.latitude longitude:_guestlistEntity.event.location.longitude];

    
    [KVNProgress showWithStatus:@"Checking In"];
    
    [self.locationManager startUpdatingLocation];
}

- (void)showSorryAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                    message:@"Need to enable location services in your settings"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocationDistance meters = [locations[0] distanceFromLocation:_center];
    
        if (meters < 70) {
            [self.locationManager stopUpdatingLocation];
            [self updateGuestlistInvite:_guestlistInvite withCheckInStatus:YES];
        } else {
            [self.locationManager stopUpdatingLocation];
            [self updateGuestlistInvite:_guestlistInvite withCheckInStatus:NO];
       }
};


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Make sure your location settings are properly enabled"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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

- (void)unSubscribeChannelsForUser:(THLUser *)userId withGuestlist:(THLGuestlistEntity *)guestlistEntity {
    THLGuestlist *guestlist = [THLGuestlist objectWithoutDataWithObjectId:guestlistEntity.objectId];
    THLParseQueryFactory *factory = [[THLParseQueryFactory alloc] init];
    PFQuery *query = [factory queryChannelsForGuestID:userId withGuestList:guestlist];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            [PFObject deleteAllInBackground:objects];
        }
    }];
}

- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withCheckInStatus:(BOOL)status {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager updateGuestlistInvite:guestlistInvite withCheckInStatus:status] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInviteCheckInStatus:task.error to:status];
        return nil;
    }];
    [KVNProgress dismissWithCompletion:^{
        // Things you want to do after the HUD is gone.
        if (status) {
            [self updateGuestlistInvites];
        }
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
