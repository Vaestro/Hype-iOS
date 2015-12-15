//
//  THLPerkDetailInteractor.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPerkDetailInteractor;
@class THLPerkDetailPresenter;
@class THLPerkDetailDataManager;
@class THLUser;
@class THLPerkStoreItem;
@class THLPerkStoreItemEntity;



@protocol THLPerkDetailInteractorDelegate <NSObject>

@end


@interface THLPerkDetailInteractor : NSObject
@property (nonatomic, weak) id<THLPerkDetailInteractorDelegate> delegate;
@property (nonatomic, readonly, weak) THLPerkDetailDataManager *dataManager;
@property (nonatomic, readonly, weak) THLPerkDetailPresenter *presenter;

- (instancetype)initWithDataManager:(THLPerkDetailDataManager *)dataManager;

- (void)handlePurchasewithPerkItemEntity:(THLPerkStoreItemEntity *)perkEntity;

@end
