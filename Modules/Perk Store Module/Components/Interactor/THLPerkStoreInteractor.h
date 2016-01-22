//
//  THLPerkStoreInteractor.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLPerkStoreDataManager;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@class THLPerkStoreInteractor;
@protocol THLPerkStoreInteractorDelegate <NSObject>
- (void)interactor:(THLPerkStoreInteractor *)interactor didUpdatePerks:(NSError *)error;
- (void)interactor:(THLPerkStoreInteractor *)interactor didUpdateUserCredits:(NSError *)error;
@end

@interface THLPerkStoreInteractor : NSObject
@property (nonatomic, weak) id<THLPerkStoreInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLPerkStoreDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLPerkStoreDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)updatePerks;
- (void)refreshUserCredits;
- (THLViewDataSource *)generateDataSource;
@end
