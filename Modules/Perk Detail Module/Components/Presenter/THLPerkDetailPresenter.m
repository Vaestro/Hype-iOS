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
    
    RACCommand *purchaseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handlePurchaseAction];
        return [RACSignal empty];
    }];
    
    
    [_view setDismissCommand:dismissCommand];
    [_view setPurchaseCommand:purchaseCommand];

}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}


- (void)continueWithPurchaseFlow {
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [_interactor handlePurchasewithPerkItemEntity:_perkStoreItemEntity];
                                                      }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
    
    NSString *message = NSStringWithFormat(@"Are you sure you want to use your credits to pucharse this reward for %i ?", (int)_perkStoreItemEntity.credits);

    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:yesAction, noAction, nil]];
    
}

- (void)errorWithPurchase {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    NSString *message = NSStringWithFormat(@"You dont have enough credits to redeem this reward");
    
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

- (void)handlePurchaseAction {
    float userCredit = [THLUser currentUser].credits;
    float perkStoreItemCost = _perkStoreItemEntity.credits;
    
    userCredit >= perkStoreItemCost ? [self continueWithPurchaseFlow] : [self errorWithPurchase];
}

- (void)interactor:(THLPerkDetailInteractor *)interactor didPurchasePerkStoreItem:(NSError *)error {
    [_wireframe dismissInterface];
}

@end
