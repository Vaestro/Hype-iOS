//
//  THLHostDashboardWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostDashboardModuleInterface.h"

@protocol THLGuestlistServiceInterface;
@protocol THLViewDataSourceFactoryInterface;
@class THLEntityMapper;
@class THLDataStore;

@interface THLHostDashboardWireframe : NSObject
@property (nonatomic, readonly) id<THLHostDashboardModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                           entityMappper:(THLEntityMapper *)entityMapper
                   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
                               dataStore:(THLDataStore *)dataStore;

- (void)presentInterfaceInNavigationController:(UINavigationController *)navigationController;
@end