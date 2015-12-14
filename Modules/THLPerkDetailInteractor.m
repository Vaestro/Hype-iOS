//
//  THLPerkDetailInteractor.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDetailInteractor.h"
#import "THLUser.h"
#import "THLPerkDetailPresenter.h"
#import "THLPerkDetailDataManager.h"

@implementation THLPerkDetailInteractor

- (instancetype)initWithPresenter:(THLPerkDetailPresenter *)presenter withDataManager:(THLPerkDetailDataManager *)dataManager {
    
    if (self = [super init]) {
        _presenter = presenter;
        _dataManager = dataManager;
    }
    return self;
}

- (void)handlePurchasewithPerkItemEntity:(THLPerkStoreItemEntity *)perkEntity {
    [_dataManager purchasePerkStoreItem:perkEntity];
}

@end
