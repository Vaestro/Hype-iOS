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
#import "THLConfirmationView.h"

@interface THLPerkDetailPresenter()
<
THLPerkDetailInteractorDelegate
>
@property (nonatomic, strong) id<THLPerkDetailView> view;
@property (nonatomic, strong) THLPerkStoreItemEntity *perkStoreItemEntity;
@property (nonatomic, strong) THLConfirmationView *confirmationView;
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
    [self.view setPerkStoreItemDescription:_perkStoreItemEntity.info];
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
    THLConfirmationView *confirmationView = [THLConfirmationView new];
    [self configureConfirmationView:confirmationView];
}

- (void)configureConfirmationView:(THLConfirmationView *)view {
    self.confirmationView = view;
    
    WEAKSELF();
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.interactor handlePurchasewithPerkItemEntity:_perkStoreItemEntity];
        [WSELF.confirmationView setInProgressWithMessage:@"Redeeming your reward..."];
        return [RACSignal empty];
    }];
    
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.confirmationView dismiss];
        return [RACSignal empty];
    }];
    
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_wireframe dismissInterface];
        return [RACSignal empty];
    }];
    
    [_confirmationView setAcceptButtonText:@"Yes"];
    [_confirmationView setDeclineButtonText:@"No"];
    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:dismissCommand];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}


- (void)continueWithPurchaseFlow {
    [_confirmationView setConfirmationWithTitle:@"Redeem Reward"
                                         message:[NSString stringWithFormat:@"Are you sure you want to use your credits to pucharse this reward for %i.00 ?", (int)_perkStoreItemEntity.credits] ];
    [_view showConfirmationView:_confirmationView];
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
    [self.confirmationView setSuccessWithTitle:@"Perk Redeemed"
                                        Message:[NSString stringWithFormat:@"You have successfully redeemed your credits for %@. Check your email for further instructions.", _perkStoreItemEntity.name]];
}

@end
