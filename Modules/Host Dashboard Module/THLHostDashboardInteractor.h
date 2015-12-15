//
//  THLHostDashboardInteractor.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLHostDashboardDataManager;
@class THLHostDashboardInteractor;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLHostDashboardInteractorDelegate <NSObject>
- (void)interactor:(THLHostDashboardInteractor *)interactor didUpdateGuestlists:(NSError *)error;
@end

@interface THLHostDashboardInteractor : NSObject
@property (nonatomic, weak) id<THLHostDashboardInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLHostDashboardDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;

- (instancetype)initWithDataManager:(THLHostDashboardDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)updateGuestlists;
- (THLViewDataSource *)getDataSource;
@end
