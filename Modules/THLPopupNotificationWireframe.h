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

@protocol THLGuestlistServiceInterface;

@interface THLPopupNotificationWireframe : NSObject
@property (nonatomic, readonly) id<THLPopupNotificationModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                        entityMapper:(THLEntityMapper *)entityMapper;

- (void)presentInterface;
@end