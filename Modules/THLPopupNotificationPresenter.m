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
#import "THLPopupNotificationView.h"

#import "THLEventEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestEntity.h"

static NSString *const kPushInfoKeyNotficationText = @"notificationText";

@interface THLPopupNotificationPresenter()
<
THLPopupNotificationInteractorDelegate
>
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, copy) NSString *notificationText;
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
    return [[_interactor handleNotificationData:pushInfo] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (!task.faulted) {
            _notificationText = pushInfo[kPushInfoKeyNotficationText];
            _guestlistInviteEntity = task.result;
            _eventEntity = _guestlistInviteEntity.guestlist.promotion.event;
            [_wireframe presentInterface];
        }
        return task;
    }];
}

- (void)configureView:(THLPopupNotificationView *)view {
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handlePopupAcceptAction];
        return [RACSignal empty];
    }];
    
    [view setNotificationText:_notificationText];
    [view setNotificationImageURL:_guestlistInviteEntity.guestlist.owner.imageURL];
    [view setAcceptCommand:acceptCommand];
}

- (void)handlePopupAcceptAction {
    [self.moduleDelegate popupNotificationModule:self userDidAcceptReviewForEvent:_eventEntity];
}

@end

