//
//  THLPerkDetailPresenter.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailPresenter.h"
#import "THLPerkDetailWireframe.h"
#import "THLPerkDetailInteractor.h"
#import "THLPerkDetailView.h"
#import "THLUser.h"
#import "THLPerkStoreItemEntity.h"

@interface THLPerkDetailPresenter()
<
THLPerkDetailInteractorDelegate
>
@property (nonatomic, strong) id<THLPerkDetailView> view;
@property (nonatomic, strong) THLPerkStoreItemEntity *perkStoreItemEntity;
@end



@implementation THLPerkDetailPresenter
@synthesize moduleDelegate;

- (instancetype)initWithInteractor:(THLPerkDetailInteractor *)interactor
                         wireframe:(THLPerkDetailWireframe *)wireframe {
    if (self = [super init]) {
        _interactor = interactor;
        _interactor.delegate = self;
        _wireframe = wireframe;
    }
    return self;
}


#pragma mark - Module Interface
- (void)presentPerkDetailInterfaceForPerk:(THLPerkStoreItemEntity *)perkEntity onViewController:(UIViewController *)viewController {
    _perkStoreItemEntity = perkEntity;
    
    [_wireframe presentPerkDetailonViewController:viewController];
}

- (void)configureView:(id<THLPerkDetailView>)view {

    self.view = view;
    
    [self.view setCredits:_perkStoreItemEntity.credits];
    [self.view setPerkStoreItemDescription:_perkStoreItemEntity.itemDescription];
    [self.view setPerkStoreItemImage:_perkStoreItemEntity.image];
    [self.view setPerkStoreItemName:_perkStoreItemEntity.name];
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
        
    }];
    
    [_view setDismissCommand:dismissCommand];

}




- (void)handleDismissAction {
    [_wireframe dismissInterface];
}



@end
