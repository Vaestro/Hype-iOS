//
//  THLDashboardWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardModuleInterface.h"
#import "THLDashboardViewController.h"

@protocol THLGuestlistServiceInterface;
@protocol THLViewDataSourceFactoryInterface;
@class THLEntityMapper;
@class THLDataStore;

@interface THLDashboardWireframe : NSObject
@property (nonatomic, readonly) id<THLDashboardModuleInterface> moduleInterface;
@property (nonatomic, strong) THLDashboardViewController *view;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                          entityMapper:(THLEntityMapper *)entityMapper
                   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
                               dataStore:(THLDataStore *)dataStore;

- (void)presentInterfaceInNavigationController:(UINavigationController *)navigationController;
@end
