//
//  THLEventHostingInteractor.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventHostingDataManager;
@class THLEventHostingInteractor;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLEventHostingInteractorDelegate <NSObject>
- (void)interactor:(THLEventHostingInteractor *)interactor didUpdateGuestlists:(NSError *)error;
@end

@interface THLEventHostingInteractor : NSObject
@property (nonatomic, weak) id<THLEventHostingInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLEventHostingDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLEventHostingDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLViewDataSource *)generateDataSource;
- (void)updateGuestlists;
@end