//
//  THLDashboardWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardModuleInterface.h"

@class THLEntityMapper;
@protocol THLGuestlistServiceInterface;

@interface THLDashboardWireframe : NSObject
@property (nonatomic, readonly) id<THLDashboardModuleInterface> moduleInterface;
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                          entityMappper:(THLEntityMapper *)entityMapper;

- (void)presentInterfaceInViewController:(UIViewController *)viewController;
@end
