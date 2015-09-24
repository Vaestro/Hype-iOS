//
//  THLChooseHostInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEvent;
@class THLPromotion;
@class THLChooseHostInteractor;
@protocol THLChooseHostInteractorDelegate <NSObject>
- (void)interactor:(THLChooseHostInteractor *)interactor
 didFindPromotions:(NSArray *)promotions
		  forEvent:(THLEvent *)event
			 error:(NSError *)error;
@end

@class THLChooseHostDataManager;
@interface THLChooseHostInteractor : NSObject
@property (nonatomic, weak) id<THLChooseHostInteractorDelegate> delegate;

@property (nonatomic, readonly) THLChooseHostDataManager *dataManager;
- (instancetype)initWithDataManager:(THLChooseHostDataManager *)dataManager;

- (void)findPromotionsForEvent:(THLEvent *)event;
@end
