//
//  THLEventDetailsViewController.m
//  Hype
//
//  Created by Daniel Aksenov on 5/27/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLEventDetailsViewController.h"
#import "THLCheckoutViewController.h"
#import "BLKDelegateSplitter.h"

#import <Parse/Parse.h>
#import "THLUser.h"
#import "THLLocationService.h"
#import "THLLocation.h"
#import "THLGuestlistInvite.h"
#import "THLEvent.h"

//Subviews
#import "THLEventNavigationBar.h"
#import "THLEventDetailsMapView.h"
#import "THLActionButton.h"
#import "THLAlertView.h"
#import "THLImportantInformationView.h"
#import "THLTitledContentView.h"

#import "THLAppearanceConstants.h"


@interface THLEventDetailsViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UILabel *eventNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) THLTitledContentView *locationInfoView;
@property (nonatomic, strong) THLImportantInformationView *needToKnowInfoView;
@property (nonatomic, strong) THLTitledContentView *musicTypesView;
@property (nonatomic, strong) THLActionButton *bottomBar;
@property (nonatomic, strong) THLEventDetailsMapView *mapView;
@property (nonatomic, strong) THLEventNavigationBar *navBar;
@property (nonatomic) PFObject *venue;
@property (nonatomic) PFObject *event;
@property (nonatomic) BOOL showNavigationBar;
@property (nonatomic, strong) UIImageView *eventImageView;
@property (nonatomic, strong) THLLocationService *locationService;
@property (nonatomic, strong) PFObject *guestlistInvite;

@property (nonatomic) BLKDelegateSplitter *delegateSplitter;

@end

@implementation THLEventDetailsViewController

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"YA BOY %@ DEALLOCATED", [self class]);
}

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
    
    self.scrollView.contentInset = UIEdgeInsetsMake(self.navBar.maximumBarHeight, 0.0, 0.0, 0.0);

    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.insets(kTHLEdgeInsetsNone());
    }];
    
    // Configure a separate UITableViewDelegate and UIScrollViewDelegate (optional)
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:(id<UIScrollViewDelegate>)self.navBar.behaviorDefiner secondDelegate:self];
    self.scrollView.delegate = (id<UIScrollViewDelegate>)self.delegateSplitter;

    WEAKSELF();
    
    [self.bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.scrollView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
    }];
    
    [self generateContent];
}


- (void)generateContent {
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    WEAKSELF();

    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF.scrollView);
        make.width.equalTo(WSELF.scrollView);
    }];
    

    [contentView addSubviews:@[self.locationInfoView, self.musicTypesView, self.mapView, self.needToKnowInfoView]];
    
    [self.locationInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.musicTypesView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.locationInfoView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.musicTypesView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.needToKnowInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.mapView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.needToKnowInfoView.mas_bottom);
    }];
    
    [self.view bringSubviewToFront:_navBar];

    [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.top.offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    THLLocation *venue = (THLLocation *)_venue;
    [self getPlacemarkForLocation:venue.fullAddress];
}

#pragma mark -
#pragma mark Event Handlers

- (void)dismissCommand{
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

-(void)handleViewCheckout {
    if (_guestlistInvite) {
        NSDictionary *paymentInfo = @{@"guestlistInviteId": _guestlistInvite.objectId};
        [self.delegate eventDetailsWantsToPresentCheckoutForEvent:_event paymentInfo:paymentInfo];
    } else {
        [self.delegate eventDetailsWantsToPresentCheckoutForEvent:_event paymentInfo:nil];
    }
}

#pragma mark -
#pragma mark Accessors

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

- (THLEventNavigationBar *)navBar
{
    if (!_navBar && _showNavigationBar) {
        THLEvent *event = (THLEvent *)_event;
        THLLocation *venue = (THLLocation *)_venue;

        _navBar = [[THLEventNavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 80) event:event venue:venue];
        _navBar.minimumTitleLabel.text = _venue[@"name"];
        NSString *eventTitle = _event[@"title"];
        if (eventTitle == nil || [eventTitle isEqualToString:@""]) {
            _navBar.titleLabel.text = _venue[@"name"];
        } else {
            _navBar.titleLabel.text = _event[@"title"];
        }
        if (_event) {
            _navBar.dateLabel.text = [NSString stringWithFormat:@"%@, %@", ((NSDate *)_event[@"date"]).thl_weekdayString, ((NSDate *)_event[@"date"]).thl_timeString];
        }

        [self.view addSubview:_navBar];
    }
    return _navBar;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
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

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc]init];
        _dismissButton.frame = CGRectMake(0, 0, 50, 50);
        [_dismissButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self
                               action:@selector(dismissCommand)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dismissButton];
        
    }
    
    return _dismissButton;
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



@end
