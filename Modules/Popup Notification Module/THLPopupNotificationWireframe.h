//
//  THLPopupNotificationWireframe.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPopupNotificationModuleInterface.h"
@class THLEntityMapper;
@class THLDataStore;

@protocol THLGuestlistServiceInterface;

@interface THLPopupNotificationWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLPopupNotificationModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                        entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore;

- (void)presentInterface;
@end