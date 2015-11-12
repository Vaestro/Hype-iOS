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
#import "THLPromotionEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestEntity.h"

static NSString *const kPushInfoKeyNotficationText = @"notificationText";
static NSString *const kPushInfoKeyImageURL = @"imageURL";

@interface THLPopupNotificationPresenter()
<
THLPopupNotificationInteractorDelegate
>
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
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
    return [[_interactor handleNotificationData:pushInfo] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if (!task.faulted) {
            WSELF.notificationText = pushInfo[kPushInfoKeyNotficationText];
            WSELF.imageURL = pushInfo[kPushInfoKeyImageURL];
            WSELF.guestlistInviteEntity = task.result;
            WSELF.eventEntity = WSELF.guestlistInviteEntity.guestlist.promotion.event;
            [WSELF.wireframe presentInterface];
        }
        return task;
    }];
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
    }
    else {
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

