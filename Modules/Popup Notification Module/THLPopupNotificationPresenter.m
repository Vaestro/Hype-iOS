//
//  THLPopupNotificationPresenter.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationPresenter.h"
#import "THLPopupNotificationInteractor.h"
#import "THLPopupNotificationWireframe.h"
#import "THLPopupNotificationViewModel.h"

#import "THLEventEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestEntity.h"
#import "THLUserManager.h"

static NSString *const kPushInfoKeyNotficationText = @"notificationText";
static NSString *const kPushInfoKeyImageURL = @"imageURL";

@interface THLPopupNotificationPresenter()
<
THLPopupNotificationInteractorDelegate
>
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, weak) id<THLPopupNotificationViewModel> view;
@property (nonatomic, copy) NSString *notificationText;
@property (nonatomic, copy) NSURL *imageURL;
@end

@implementation THLPopupNotificationPresenter
@synthesize moduleDelegate;

#pragma mark - Interface
- (instancetype)initWithWireframe:(THLPopupNotificationWireframe *)wireframe
                       interactor:(THLPopupNotificationInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

- (BFTask *)presentPopupNotificationModuleInterfaceWithPushInfo:(NSDictionary *)pushInfo {
    WEAKSELF();
    STRONGSELF();
    return [[_interactor handleNotificationData:pushInfo] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id(BFTask *task) {
        if (!task.faulted) {
            SSELF.notificationText = pushInfo[kPushInfoKeyNotficationText];
            SSELF.imageURL = pushInfo[kPushInfoKeyImageURL];
            if ([THLUserManager userIsGuest]) {
                SSELF.guestlistInviteEntity = task.result;
                SSELF.eventEntity = SSELF.guestlistInviteEntity.guestlist.event;
            } else if ([THLUserManager userIsHost]) {
                SSELF.guestlistEntity = task.result;
                SSELF.eventEntity = SSELF.guestlistEntity.event;
            }
            [SSELF presentPopupNotificationInterface];
        }
        return task;
    }];
}

- (void)presentPopupNotificationInterface {
    [_wireframe presentInterface];
}

- (void)configureView:(id<THLPopupNotificationViewModel>)view {
    _view = view;
    
    WEAKSELF();
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handlePopupAcceptAction];
        return [RACSignal empty];
    }];
    
    if (_guestlistInviteEntity != nil) {
        [[WSELF view] setImageURL:_guestlistInviteEntity.guestlist.owner.imageURL];
    } else if (_guestlistEntity != nil) {
        [[WSELF view] setImageURL:_guestlistEntity.owner.imageURL];
    } else {
        [[WSELF view] setImage:[[UIImage imageNamed:@"Hypelist-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    [_view setNotificationText:_notificationText];
    [_view setAcceptCommand:acceptCommand];
}

- (void)handlePopupAcceptAction {
    [self.moduleDelegate popupNotificationModule:self userDidAcceptReviewForEvent:_eventEntity];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end

