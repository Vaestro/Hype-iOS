//
//  THLPerkInteractor.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLPerkDataManager;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@class THLPerkInteractor;
@protocol THLPerkInteractorDelegate <NSObject>
- (void)interactor:(THLPerkInteractor *)interactor didUpdatePerks:(NSError *)error;
@end

@interface THLPerkInteractor : NSObject
@property (nonatomic, weak) id<THLPerkInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLPerkDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLPerkDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)updatePerks;
- (THLViewDataSource *)generateDataSource;
@end
