//
//  THLEventDetailsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventDetailsViewController.h"
#import "ORStackScrollView.h"
#import "Parse.h"
//Subviews
#import "THLEventDetailsMapView.h"
#import "THLNeedToKnowInfoView.h"

#import "THLAppearanceConstants.h"
#import "THLPromotionInfoView.h"
#import "THLEventNavigationBar.h"
#import "THLActionButton.h"
#import "THLAlertView.h"
#import "THLUser.h"
#import "THLCheckoutViewController.h"
#import "THLImportantInformationView.h"
#import "THLTitledContentView.h"
#import "THLLocationService.h"
#import "THLLocation.h"
#import "THLGuestlistInvite.h"
#import "THLEvent.h"

@interface THLEventDetailsViewController ()
@property (nonatomic, strong) ORStackScrollView *scrollView;
@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) THLTitledContentView *locationInfoView;
@property (nonatomic, strong) THLImportantInformationView *needToKnowInfoView;
@property (nonatomic, strong) THLTitledContentView *musicTypesView;
@property (nonatomic, strong) THLActionButton *bottomBar;
@property (nonatomic) BOOL showPromotionInfoView;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventNavigationBar *navBar;
@property (nonatomic) PFObject *venue;
@property (nonatomic) PFObject *event;
@property (nonatomic) BOOL showNavigationBar;
@property (nonatomic, strong) UIImageView *eventImageView;
@property (nonatomic, strong) THLLocationService *locationService;
@property (nonatomic, strong) PFObject *guestlistInvite;

@end

@implementation THLEventDetailsViewController

#pragma mark - Life cycle

- (id)initWithVenue:(PFObject *)venue event:(PFObject *)event guestlistInvite:(PFObject *)guestlistInvite showNavigationBar:(BOOL)showNavigationBar {
    if (self = [super init]) {
        self.venue = venue;
        self.event = event;
        self.guestlistInvite = guestlistInvite;
        self.locationService = [THLLocationService new];
        self.showNavigationBar = showNavigationBar;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;
    
    if (_showNavigationBar == TRUE) {
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.insets(kTHLEdgeInsetsNone());
        }];
        
        self.scrollView.delegate = (id<UIScrollViewDelegate>)self.navBar.behaviorDefiner;
        
        [self.scrollView.stackView addSubview:self.locationInfoView
                          withPrecedingMargin:self.navBar.frame.size.height + 2*kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
        UIView *buttonBackground = [UIView new];
        buttonBackground.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [self.view addSubview:buttonBackground];
        
        WEAKSELF();
        [buttonBackground makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.insets(kTHLEdgeInsetsNone());
            make.top.equalTo(WSELF.scrollView.mas_bottom);
            make.height.equalTo(80);
        }];
        
        [buttonBackground addSubview:self.bottomBar];
        [self.bottomBar makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(kTHLEdgeInsetsHigh());
        }];
        
    } else {
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(kTHLEdgeInsetsNone());
        }];
    
        
        [self.scrollView.stackView addSubview:self.eventImageView
                          withPrecedingMargin:2*kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
        
        [self.scrollView.stackView addSubview:self.locationInfoView
                          withPrecedingMargin:kTHLPaddingHigh()
                                   sideMargin:4*kTHLPaddingHigh()];
    }

    [self.scrollView.stackView addSubview:self.musicTypesView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];
    
    [self.scrollView.stackView addSubview:self.mapView
                  withPrecedingMargin:kTHLPaddingHigh()
                           sideMargin:kTHLPaddingNone()];
    
    [self.scrollView.stackView addSubview:self.needToKnowInfoView
                  withPrecedingMargin:2*kTHLPaddingHigh()
                           sideMargin:4*kTHLPaddingHigh()];

    
    THLLocation *location = (THLLocation *)_venue;
    
    [self getPlacemarkForLocation:location.fullAddress];
}

- (void)viewDidLayoutSubviews
{
    //    [super viewDidLayoutSubviews]
    [self.navBar addGradientLayer];
}


#pragma mark -
#pragma mark Accessors

- (THLEventNavigationBar *)navBar
{
    if (!_navBar && _showNavigationBar) {
        _navBar = [[THLEventNavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, SCREEN_HEIGHT - 80)];
        NSString *eventTitle = _event[@"title"];
        if (eventTitle == nil || [eventTitle isEqualToString:@""]) {
            _navBar.titleLabel.text = _venue[@"name"];
        } else {
            _navBar.titleLabel.text = _event[@"title"];
        }
        if (_event) {
            _navBar.dateLabel.text = [NSString stringWithFormat:@"%@, %@", ((NSDate *)_event[@"date"]).thl_weekdayString, ((NSDate *)_event[@"date"]).thl_timeString];
        }

        [_navBar.dismissButton addTarget:self
                     action:@selector(dismissCommand)
          forControlEvents:UIControlEventTouchUpInside];
        if (_event[@"promoImage"]) {
            _navBar.locationImageURL = [NSURL URLWithString:((PFFile *)_event[@"promoImage"]).url];
        } else {
            _navBar.locationImageURL =  [NSURL URLWithString:((PFFile *)_venue[@"image"]).url];
        }

        [self.view addSubview:_navBar];
        [self.view bringSubviewToFront:_navBar];
    }
    return _navBar;
}

-(void)handleViewCheckout {
    if (_guestlistInvite) {
        NSDictionary *paymentInfo = @{@"guestlistInviteId": _guestlistInvite.objectId};
        [self.delegate eventDetailsWantsToPresentCheckoutForEvent:_event paymentInfo:paymentInfo];
    } else {
        [self.delegate eventDetailsWantsToPresentCheckoutForEvent:_event paymentInfo:nil];
    }
}

- (ORStackScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [ORStackScrollView new];
        _scrollView.stackView.lastMarginHeight = kTHLPaddingHigh();
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (THLImportantInformationView *)needToKnowInfoView
{
    if (!_needToKnowInfoView) {
        _needToKnowInfoView = [THLImportantInformationView new];
        _needToKnowInfoView.titleLabel.text = NSLocalizedString(@"NEED TO KNOW", nil);
        _needToKnowInfoView.importantInformationLabel.text = [NSString
                                                              stringWithFormat:@"Hours: %@ - %@\nDress code: %@\nMust have valid 21+ Photo ID\nFinal admission at doorman’s discretion.", ((NSDate *)_venue[@"openTime"]).thl_timeString, ((NSDate *)_venue[@"closeTime"]).thl_timeString, _venue[@"attireRequirement"]];
        _needToKnowInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _needToKnowInfoView;
}

- (THLTitledContentView *)locationInfoView
{
    if (!_locationInfoView) {
        _locationInfoView = [THLTitledContentView new];
        _locationInfoView.titleLabel.text = @"WHAT WE LIKE";
        [_locationInfoView addContentText:_venue[@"info"]];
        _locationInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _locationInfoView;
}

- (UIImageView *)eventImageView {
    if (!_eventImageView) {
        _eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _eventImageView.contentMode = UIViewContentModeScaleAspectFill;
        _eventImageView.clipsToBounds = YES;
        [_eventImageView sd_setImageWithURL:[NSURL URLWithString:((PFFile *)_venue[@"image"]).url]];
        _eventImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_eventImageView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(150);
        }];
    }
    return _eventImageView;
}

- (THLTitledContentView *)musicTypesView
{
    if (!_musicTypesView) {
        _musicTypesView = [THLTitledContentView new];
        _musicTypesView.titleLabel.text = @"MUSIC";
        NSArray *musicTypesArray = _venue[@"musicTypes"];
        NSString *musicTypes = [NSString stringWithFormat:@"%@", [musicTypesArray componentsJoinedByString:@" | "]];
        [_musicTypesView addContentText:musicTypes];

        _musicTypesView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _musicTypesView;
}

- (THLActionButton *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[THLActionButton alloc] initWithInverseStyle];
        THLGuestlistInvite *invite = (THLGuestlistInvite *)_guestlistInvite;
        if (invite.response == THLStatusAccepted) {
            [_bottomBar setTitle:@"VIEW PARTY"];
            [_bottomBar addTarget:self action:@selector(handleViewParty) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [_bottomBar setTitle:@"VIEW ADMISSIONS"];
            if ([THLUser currentUser]) {
                [_bottomBar addTarget:self action:@selector(handleAdmissions) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [_bottomBar addTarget:self.delegate action:@selector(usersWantsToLogin) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self.view addSubview:_bottomBar];
    }
    return _bottomBar;
}

- (UILabel *)eventNameLabel
{
    if (!_eventNameLabel) {
        _eventNameLabel = THLNUILabel(kTHLNUIRegularTitle);
    }
    return _eventNameLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = THLNUILabel(kTHLNUIRegularTitle);
        _dateLabel.alpha = 0.67;
    }
    return _dateLabel;
}

- (THLEventDetailsMapView *)mapView
{
    if (!_mapView) {
        _mapView = [THLEventDetailsMapView new];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        THLLocation *location = (THLLocation *)_venue;
        _mapView.locationAddress = location.fullAddress;
        _mapView.addressLabel.text = location.fullAddress;
        _mapView.venueNameLabel.text = _venue[@"name"];
    }
    return _mapView;
}

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address {
    return [_locationService geocodeAddress:address];
}

- (void)getPlacemarkForLocation:(NSString *)address {
    WEAKSELF();
    [[self fetchPlacemarkForAddress:address] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<CLPlacemark *> *task) {
        [WSELF.mapView setLocationPlacemark:task.result];
        return nil;
    }];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - event handlers ()

- (void)dismissCommand
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


-(void)handleAdmissions {
    [self.delegate eventDetailsWantsToPresentAdmissionsForEvent:_event venue:_venue];
}

-(void)handleViewParty {
    [self.delegate eventDetailsWantsToPresentPartyForEvent:_guestlistInvite];
}

- (void)showAlertView {
    THLAlertView *alertView = [THLAlertView new];
    [alertView setTitle:@"What's Next?"];
    [alertView setMessage:@"Please arrive on time and show your ticket at the door for entrance. Your ticket + guestlist can always be found in the 'My Events' tab. If you have any questions, you can contact the concierge anytime in your messages"];
    
    [self.view addSubview:alertView];
    [self.view bringSubviewToFront:alertView];
    [alertView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(kTHLEdgeInsetsNone());
    }];
}

@end