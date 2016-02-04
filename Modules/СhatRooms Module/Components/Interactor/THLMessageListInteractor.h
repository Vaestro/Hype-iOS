//
//  THLMessageListInteractor.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLMessageListDataManager;
@class THLMessageListInteractor;

@protocol THLMessageListInteractorDelegate <NSObject>
- (void)interactor:(THLMessageListInteractor *)interactor didUpdateEvents:(NSError *)error;
@end

@interface THLMessageListInteractor : NSObject

@property (nonatomic, weak) id<THLMessageListInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLMessageListDataManager *dataManager;
- (instancetype)initWithDataManager:(THLMessageListDataManager *)dataManager;


@end
