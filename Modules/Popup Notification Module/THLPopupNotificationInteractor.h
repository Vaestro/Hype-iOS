//
//  THLPopupNotificationInteractor.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLPopupNotificationDataManager;
@class THLPopupNotificationInteractor;

@protocol THLPopupNotificationInteractorDelegate <NSObject>

@end

@interface THLPopupNotificationInteractor : NSObject
@property (nonatomic, weak) id<THLPopupNotificationInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLPopupNotificationDataManager *dataManager;
- (instancetype)initWithDataManager:(THLPopupNotificationDataManager *)dataManager;

- (BFTask *)handleNotificationData:(NSDictionary *)pushInfo;
@end
