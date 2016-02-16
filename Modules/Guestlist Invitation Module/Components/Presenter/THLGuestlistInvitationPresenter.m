//
//  THLGuestlistInvitationPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationPresenter.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistInvitationInteractor.h"
#import "THLGuestlistInvitationView.h"
#import "THLGuestlistInvitationViewEventHandler.h"
#import "THLEventEntity.h"

@interface THLGuestlistInvitationPresenter ()
<
THLGuestlistInvitationInteractorDelegate,
THLGuestlistInvitationViewEventHandler
>
@property (nonatomic, weak) id<THLGuestlistInvitationView> view;
@property (nonatomic) BOOL submitting;
@property (nonatomic, weak) NSString *creditsPayout;

@end

@implementation THLGuestlistInvitationPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLGuestlistInvitationWireframe *)wireframe
					   interactor:(THLGuestlistInvitationInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

#pragma mark - THLGuestlistModuleInterface
//For Creating A new Guestlist
- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity inController:(UIViewController *)controller {
    _interactor.eventEntity = eventEntity;
    _creditsPayout = [NSString stringWithFormat:@"Get $%d.00 for every friend you invite that attends this event", eventEntity.creditsPayout];
    [_wireframe presentInterfaceInController:controller];
}

//For Updating An Existing Guestlist
- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray *)guests inController:(UIViewController *)controller {
    _interactor.eventEntity = eventEntity;
    _creditsPayout = [NSString stringWithFormat:@"Get $%d.00 for every friend you invite that attends this event", eventEntity.creditsPayout];
    [_interactor loadGuestlist:guestlistId withCurrentGuests:guests];
    [_wireframe presentInterfaceInController:controller];
}

- (void)configureView:(id<THLGuestlistInvitationView>)view {
	_view = view;
	[_view setEventHandler:self];
	[_view setDataSource:[_interactor getDataSource]];
    [_view setExistingGuests:[_interactor currentGuests]];
    [_view setCreditsPayout:_creditsPayout];
    
    WEAKSELF();
    [RACObserve(self, submitting) subscribeNext:^(NSNumber *b) {
        BOOL isSubmitting = [b boolValue];
        [WSELF.view setShowActivityIndicator:isSubmitting];
    }];
}

#pragma mark - THLGuestlistInvitationInteractorDelegate
- (void)interactor:(THLGuestlistInvitationInteractor *)interactor didCommitChangesToGuestlist:(NSError *)error {
    self.submitting = NO;
    if(!error) {
        [_wireframe dismissInterface];
        
    } else {
        
    }
}

#pragma mark - THLGuestlistInvitationViewEventHandler 
- (void)view:(id<THLGuestlistInvitationView>)view didAddGuest:(THLGuestEntity *)guest {
	[_interactor addGuest:guest];
}

- (void)view:(id<THLGuestlistInvitationView>)view didRemoveGuest:(THLGuestEntity *)guest {
	[_interactor removeGuest:guest];
}

- (void)viewDidCancelInvitations:(id<THLGuestlistInvitationView>)view {
    [_wireframe dismissInterface];
}

- (void)viewDidCommitInvitations:(id<THLGuestlistInvitationView>)view {
    self.submitting = YES;
	[_interactor commitChangesToGuestlist];
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
