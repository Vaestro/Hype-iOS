//
//  THLDashboardPresenter.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardPresenter.h"
#import "THLDashboardInteractor.h"
#import "THLDashboardWireframe.h"
#import "THLDashboardView.h"
#import "THLGuestlistInviteEntity.h"
#import "THLEventEntity.h"
#import "THLHostEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistEntity.h"

@interface THLDashboardPresenter()
<
THLDashboardInteractorDelegate
>
@property (nonatomic, strong) id<THLDashboardView> view;
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;

@end

@implementation THLDashboardPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLDashboardWireframe *)wireframe
                       interactor:(THLDashboardInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
        [_interactor checkForGuestlistInvites];
    }
    return self;
}

- (void)configureView:(id<THLDashboardView>)view {
    WEAKSELF();
    self.view = view;
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [WSELF reloadInvites];
    }];

}

- (void)reloadInvites {
    [_interactor checkForGuestlistInvites];
}

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController {
    [_wireframe presentInterfaceInViewController:viewController];
}

- (void)handleContactHostAction {
    
}

- (void)handleViewEventAction {
    [self.moduleDelegate dashboardModule:self didClickToViewEvent:_eventEntity];
}

#pragma mark - THLDashboardInteractorDelegate
/**
 *  Temporary - Interactor retrieves only the next Accepted Guestlist Invite
 */
- (void)interactor:(THLDashboardInteractor *)interactor didGetAcceptedGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite error:(NSError *)error {
    if (!error && guestlistInvite) {
        _guestlistInviteEntity = guestlistInvite;
        _guestlistEntity = _guestlistInviteEntity.guestlist;
        _promotionEntity = _guestlistEntity.promotion;
        _eventEntity = _promotionEntity.event;
        
        WEAKSELF();
        RACCommand *contactButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [WSELF handleContactHostAction];
            return [RACSignal empty];
        }];
        RACCommand *actionBarButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [WSELF handleViewEventAction];
            return [RACSignal empty];
        }];
        
        [self.view setLocationImageURL:_eventEntity.location.imageURL];
        [self.view setEventName:_eventEntity.title];
        [self.view setEventDate:[NSString stringWithFormat:@"%@, %@", _eventEntity.date.thl_weekdayString, _eventEntity.date.thl_timeString]];
        [self.view setHostImageURL:_promotionEntity.host.imageURL];
        [self.view setHostName:_promotionEntity.host.firstName];
        [self.view setContactHostCommand:contactButtonCommand];
        [self.view setActionButtonCommand:actionBarButtonCommand];
    }
}
@end
