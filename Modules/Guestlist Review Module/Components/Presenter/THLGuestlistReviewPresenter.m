//
//  THLGuestlistReviewPresenter.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewPresenter.h"
#import "THLGuestlistReviewWireframe.h"
#import "THLGuestlistReviewInteractor.h"
#import "THLGuestlistReviewView.h"
#import "THLGuestlistReviewHeaderView.h"
#import "THLMenuView.h"
#import "THLAppearanceConstants.h"
#import "Parse.h"

#import "THLViewDataSource.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistReviewCellViewModel.h"
#import "THLGuestlistEntity.h"
#import "THLGuestEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLConfirmationView.h"
#import "THLUserManager.h"
#import "THLHostEntity.h"
#import "THLUser.h"

//phone kit
#import "AFNetworking.h"
#import "UIView+FrameAccessor.h"
#import "PKTPhone.h"
#import "PKTCallViewController.h"
#import "NSString+PKTHelpers.h"

@interface THLGuestlistReviewPresenter()
<
THLGuestlistReviewInteractorDelegate
>
@property (nonatomic, weak) id<THLGuestlistReviewView> view;
@property (nonatomic, strong) THLMenuView *menuView;
@property (nonatomic, strong) THLConfirmationView *confirmationView;
@property (nonatomic, strong) PKTCallViewController *callViewController;

@property (nonatomic) BOOL refreshing;
@property (nonatomic) THLGuestlistReviewerStatus reviewerStatus;
@property (nonatomic) THLActivityStatus activityStatus;
@property (nonatomic, strong) RACCommand *responseCommand;

@property (nonatomic, strong) NSString *callToken;

@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@end

@implementation THLGuestlistReviewPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLGuestlistReviewWireframe *)wireframe
                       interactor:(THLGuestlistReviewInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

#pragma mark - THLGuestlistReviewModuleInterface
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller {
    _interactor.guestlistEntity = guestlistEntity;
    _guestlistInviteEntity = guestlistInviteEntity;
    _guestlistEntity = _guestlistInviteEntity.guestlist;
    [self updateGuestReviewStatus];
    [_wireframe presentInterfaceInController:controller];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity inController:(UIViewController *)controller {
    _interactor.guestlistEntity = guestlistEntity;
    _guestlistEntity = guestlistEntity;
    [self updateHostReviewStatus];
    [_wireframe presentInterfaceInController:controller];
}

#pragma mark - View Configuration
- (void)configureView:(id<THLGuestlistReviewView>)view {
    _view = view;
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLGuestlistReviewCellViewModel alloc] initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)item];
    };
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleAcceptAction];
        return [RACSignal empty];
    }];
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDeclineAction];
        return [RACSignal empty];
    }];
    _responseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        THLConfirmationView *confirmationView = [THLConfirmationView new];
        [self configureResponseView:confirmationView];
        [WSELF handleResponseAction];
        return [RACSignal empty];
    }];
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [_interactor updateGuestlistInvites];
    }];
    
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    [RACObserve(self, reviewerStatus) subscribeNext:^(NSNumber *x) {
        [WSELF.view setReviewerStatus:x];
    }];
    
    [_view setDataSource:dataSource];
    [_view setAcceptCommand:acceptCommand];
    [_view setDeclineCommand:declineCommand];
    [_view setResponseCommand:_responseCommand];
    [_view setRefreshCommand:refreshCommand];
    
    THLMenuView *menuView = [THLMenuView new];
    [self configureMenuView:menuView];
    
    RACCommand *showMenuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view showGuestlistMenuView:menuView];
        return [RACSignal empty];
    }];

    
    [_view setHeaderViewImage:_guestlistEntity.promotion.event.location.imageURL];
    NSString *userName = _guestlistEntity.owner.firstName;
    NSString *venueLocation = _guestlistEntity.promotion.event.location.name;
    [_view setTitle:[NSString stringWithFormat:@"%@'s List For %@", userName, venueLocation]];
    [_view setDismissCommand:dismissCommand];
    [_view setShowMenuCommand:showMenuCommand];
    [_view setFormattedDate: [NSString stringWithFormat:@"%@, %@", _guestlistEntity.promotion.event.date.thl_weekdayString, _guestlistEntity.promotion.event.date.thl_timeString]];
    
    [_view setGuestlistReviewStatus: _guestlistEntity.reviewStatus];
    switch (_guestlistEntity.reviewStatus) {
        case THLStatusNone: {
            break;
        }
        case THLStatusPending: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Pending"];
            break;
        }
        case THLStatusAccepted: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Accepted"];
            
            break;
        }
        case THLStatusDeclined: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Declined"];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)configureResponseView:(THLConfirmationView *)view {
    self.confirmationView = view;
    
    WEAKSELF();
    RACCommand *confirmationAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleAcceptAction];
        return [RACSignal empty];
    }];
    
    RACCommand *confirmationDeclineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDeclineAction];
        return [RACSignal empty];
    }];
    
    RACCommand *viewDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [_wireframe dismissInterface];
        return [RACSignal empty];
    }];
    
    RACCommand *confirmationDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.confirmationView dismiss];
        return [RACSignal empty];
    }];
    
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF configureConfirmationView:WSELF.confirmationView title:@"Accept Invite" message:@"Are you sure you want to accept your invite?" acceptCommand:confirmationAcceptCommand declineCommand:WSELF.responseCommand dismissCommand:confirmationDismissCommand];
        return [RACSignal empty];
    }];
    
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF configureConfirmationView:WSELF.confirmationView title:@"Decline Invite" message:@"Are you sure you want to decline your invite?" acceptCommand:confirmationDeclineCommand declineCommand:WSELF.responseCommand dismissCommand:viewDismissCommand];
        return [RACSignal empty];
    }];

    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:confirmationDismissCommand];
}

- (void)configureConfirmationView:(THLConfirmationView *)view title:(NSString *)title message:(NSString *)message acceptCommand:(RACCommand *)acceptCommand declineCommand:(RACCommand *)declineCommand dismissCommand:(RACCommand *)dismissCommand {
    [view showConfirmationWithTitle:title message:message];
    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:dismissCommand];
}

// -----------------------------------------
#pragma mark - MenuView Configuration
// -----------------------------------------
- (void)configureMenuView:(THLMenuView *)menuView {
    self.menuView = menuView;
    
    if (self.reviewerStatus != THLGuestlistOwner) {
        [_menuView guestLayoutUpdate];
    }
    
    if (self.reviewerStatus == THLGuestlistOwner) {
        [_menuView hostLayoutUpdate];
    }
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        return [RACSignal empty];
    }];
    
    RACCommand *addGuestsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        [WSELF handleAddGuestsAction];
        return [RACSignal empty];
    }];
    
    RACCommand *leaveGuestlistCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        THLConfirmationView *confirmationView = [THLConfirmationView new];
        [self configureResponseView:confirmationView];
        [WSELF handleResponseAction];
        return [RACSignal empty];
    }];
    
    RACCommand *showEventDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    
    RACCommand *callHostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_interactor generateToken];
        return [RACSignal empty];
    }];
    
    [_menuView setHostName:_guestlistEntity.promotion.host.firstName];
    [_menuView setHostImageURL:_guestlistEntity.promotion.host.imageURL];

    [_menuView setDismissCommand:dismissCommand];
    [_menuView setMenuAddGuestsCommand:addGuestsCommand];
    [_menuView setMenuLeaveGuestCommand:leaveGuestlistCommand];
    [_menuView setMenuEventDetailsCommand:showEventDetailsCommand];
    [_menuView setMenuContactHostCommand:callHostCommand];
    
}

//TODO: Create Configure Review Options
- (void)manageReviewer {
    if ([THLUserManager userIsGuest]) {
        [self updateGuestReviewStatus];
    } else {
        [self updateHostReviewStatus];
    }
}

- (void)updateGuestReviewStatus {
    if ([_guestlistInviteEntity isOwnerInvite]) {
        self.reviewerStatus = THLGuestlistOwner;
    }
    else if ([_guestlistInviteEntity isAccepted]) {
        self.reviewerStatus = THLGuestlistAttendingGuest;
    }
    else if ([_guestlistInviteEntity isPending]) {
        self.reviewerStatus = THLGuestlistPendingGuest;
    }
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)updateHostReviewStatus {
    if ([_guestlistEntity isPending]) {
        self.reviewerStatus = THLGuestlistPendingHost;
    }
    else if ([_guestlistEntity isAccepted]) {
        self.reviewerStatus = THLGuestlistActiveHost;
    }
    else if ([_guestlistEntity isDeclined]) {
        self.reviewerStatus = THLGuestlistDeclinedHost;
    }
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
}

#pragma mark - Event Handling
- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlistInvites];
}

- (void)handleResponseAction {
    NSString *ownerName = _guestlistInviteEntity.guestlist.owner.firstName;
    NSString *eventName =_guestlistInviteEntity.guestlist.promotion.event.location.name;
    NSString *promotionTime =_guestlistInviteEntity.guestlist.promotion.event.date.thl_timeString;
    NSString *promotionDate =_guestlistInviteEntity.guestlist.promotion.event.date.thl_weekdayString;
    
    switch (_reviewerStatus) {
        case THLGuestlistPendingGuest: {
            [_confirmationView showResponseFlowWithTitle:@"Respond Now" message:[NSString stringWithFormat:@"%@ would like you to join their guestlist for %@, %@ at %@", ownerName, eventName, promotionDate, promotionTime]];
            break;
        }
        case THLGuestlistAttendingGuest: {
            WEAKSELF();
            RACCommand *confirmationAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                [WSELF handleAcceptAction];
                return [RACSignal empty];
            }];
            
            RACCommand *confirmationDeclineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                [WSELF.confirmationView dismiss];
                return [RACSignal empty];
            }];
            
            RACCommand *viewDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                [_wireframe dismissInterface];
                return [RACSignal empty];
            }];
            
            [_confirmationView setAcceptCommand:confirmationAcceptCommand];
            [_confirmationView setDeclineCommand:confirmationDeclineCommand];
            [_confirmationView setDismissCommand:viewDismissCommand];

            [_confirmationView showConfirmationWithTitle:@"Leave Guestlist" message:[NSString stringWithFormat:@"Are you sure you want to leave %@'s party for %@?", ownerName, eventName]];
            
            break;
        }
        case THLGuestlistOwner: {
            [self handleAddGuestsAction];
            break;
        }
        case THLGuestlistPendingHost: {
            [_confirmationView showResponseFlowWithTitle:@"Respond Now" message:[NSString stringWithFormat:@"%@'s party would like to join to your guestlist for %@, %@ at %@", _guestlistEntity.owner.firstName, _guestlistEntity.promotion.event.location.name ,_guestlistEntity.promotion.event.date.thl_weekdayString, _guestlistEntity.promotion.event.date.thl_timeString] ];
            break;
        }
        case THLGuestlistActiveHost: {

            break;
        }
        default: {
            break;
        }
    }
}

- (void)handleAcceptAction {
    /**
     *  Guest Accept Action Options
     */
    if (_reviewerStatus == THLGuestlistAttendingGuest) {
        [_confirmationView showInProgressWithMessage:@"Leaving guestlist..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusDeclined];
    }
    else if (_reviewerStatus == THLGuestlistPendingGuest) {
        [_confirmationView showInProgressWithMessage:@"Accepting your invite..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
    /**
     *  Host Accept Action Options
     */
    else if (_reviewerStatus == THLGuestlistPendingHost) {
        [_confirmationView showInProgressWithMessage:@"Accepting guestlist..."];
        [_interactor updateGuestlist:_guestlistEntity withReviewStatus:THLStatusAccepted];
    }
    else if (_reviewerStatus == THLGuestlistActiveHost) {
        self.activityStatus = THLActivityStatusSuccess;
//        [_interactor checkInGuests:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
}

- (void)handleDeclineAction {
    /**
     *  Guest Decline Action Options
     */
    if (_reviewerStatus == THLGuestlistAttendingGuest) {
        
    }
    else if (_reviewerStatus == THLGuestlistPendingGuest) {
        [_confirmationView showInProgressWithMessage:@"Declining your invite..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusDeclined];
    }
    /**
     *  Host Decline Action Options
     */
    else if (_reviewerStatus == THLGuestlistPendingHost) {
        [_confirmationView showInProgressWithMessage:@"Declining guestlist..."];
        [_interactor updateGuestlist:_guestlistEntity withReviewStatus:THLStatusDeclined];
    }
    else if (_reviewerStatus == THLGuestlistActiveHost) {
        
    }
}

- (void)handleAddGuestsAction {
    [self.moduleDelegate guestlistReviewModule:self promotion:_guestlistInviteEntity.guestlist.promotion withGuestlistId:_guestlistInviteEntity.guestlist.objectId andGuests:[_interactor guests] presentGuestlistInvitationInterfaceOnController:(UIViewController *)self.view];
}

# pragma mark - Phone Kit
- (void)handleCallActionWithCallerdId:(NSString *)twilioNumber toHostNumber:(NSString *)hostNumber {
    [PKTPhone sharedPhone].capabilityToken = _callToken;
    [PKTPhone sharedPhone].callerId = twilioNumber;
    self.callViewController = [PKTCallViewController new];
    [PKTPhone sharedPhone].delegate = self.callViewController;
    [(UIViewController *)self.view presentViewController:self.callViewController animated:YES completion:nil];
    [[PKTPhone sharedPhone] call:hostNumber];
}

- (void)guestError {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"Only a party leader can perform that action");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
}


- (void)partyLeaderError {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"A party leader can't leave their own guestlist");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
    
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
}

#pragma mark - InteractorDelegate
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInvites:(NSError *)error {
    self.refreshing = NO;
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteResponse:(NSError *)error to:(THLStatus)response {
    if (!error && response == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistAttendingGuest;
        [self.confirmationView showSuccessWithTitle:@"Accepted Invite"
                                            Message:@"Please meet the Host at the Venue on time at 11:30pm EST so that we can ensure speedy entry for you and your party. If you have any questions, you can contact the Host in the guestlist menu."];
    } else if (!error && response == THLStatusDeclined) {
        [self.confirmationView showSuccessWithTitle:@"Declined Invite"
                                            Message:@"Your invite has been declined. If you would like to create your own guestlist for this event, you can do so in the event page."];
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistReviewStatus:(NSError *)error to:(THLStatus)reviewStatus {
    if (!error && reviewStatus == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistActiveHost;
        [self.confirmationView showSuccessWithTitle:@"Accepted Guestlist"
                                            Message:@"You have accepted this Guestlist. If your guests have any questions, they will contact you through our phone service."];
        [_view setGuestlistReviewStatus:reviewStatus];
        [_view setGuestlistReviewStatusTitle:@"Guestlist Accepted"];

    } else if (!error && reviewStatus == THLStatusDeclined) {
        self.reviewerStatus = THLGuestlistDeclinedHost;
        [self.confirmationView showSuccessWithTitle:@"Declined Guestlist"
                                            Message:@"You have declined this Guestlist."];
        [_view setGuestlistReviewStatus:reviewStatus];
        [_view setGuestlistReviewStatusTitle:@"Guestlist Declined"];
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didGetToken:(NSString *)token {
    self.callToken = token;
    NSString *twilioNumber = _guestlistInviteEntity.guestlist.promotion.host.twilioNumber;
    NSString *hostNumber = _guestlistInviteEntity.guestlist.promotion.host.phoneNumber;
    [self handleCallActionWithCallerdId:twilioNumber toHostNumber:hostNumber];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
