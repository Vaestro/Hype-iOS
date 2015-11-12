//
//  THLPopupNotificationWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationWireframe.h"
#import "THLPopupNotificationInteractor.h"
#import "THLPopupNotificationPresenter.h"
#import "THLPopupNotificationDataManager.h"
#import "THLPopupNotificationView.h"

@interface THLPopupNotificationWireframe()
@property (nonatomic, strong) THLPopupNotificationDataManager *dataManager;
@property (nonatomic, strong) THLPopupNotificationInteractor *interactor;
@property (nonatomic, strong) THLPopupNotificationPresenter *presenter;
@property (nonatomic, strong) THLPopupNotificationView *view;
@end

@implementation THLPopupNotificationWireframe
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                                  entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLPopupNotificationDataManager alloc] initWithGuestlistService:_guestlistService entityMapper:_entityMapper];
    _interactor = [[THLPopupNotificationInteractor alloc] initWithDataManager:_dataManager];
    _presenter = [[THLPopupNotificationPresenter alloc] initWithWireframe:self interactor:_interactor];
}

#pragma mark - Interface
- (id<THLPopupNotificationModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)presentInterface {
    _view = [THLPopupNotificationView new];
    [_presenter configureView:_view];
    KLCPopup *popup = [KLCPopup popupWithContentView:_view
                                                   showType:KLCPopupShowTypeBounceIn
                                                dismissType:KLCPopupDismissTypeBounceOut
                                                   maskType:KLCPopupMaskTypeDimmed
                                   dismissOnBackgroundTouch:YES
                                      dismissOnContentTouch:YES];
    popup.dimmedMaskAlpha = 0.8;
    [popup show];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end