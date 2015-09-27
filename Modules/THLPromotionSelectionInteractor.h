//
//  THLPromotionSelectionInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEventEntity;
@class THLPromotionEntity;
@class THLPromotionSelectionInteractor;
@class THLPromotionSelectionDataManager;
 
@protocol THLPromotionSelectionInteractorDelegate <NSObject>
- (void)interactor:(THLPromotionSelectionInteractor *)interactor
  didGetPromotions:(NSArray<THLPromotionEntity*> *)promotions
		  forEvent:(THLEventEntity *)eventEntity
			 error:(NSError *)error;
@end

@interface THLPromotionSelectionInteractor : NSObject
@property (nonatomic, weak) id<THLPromotionSelectionInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLPromotionSelectionDataManager *dataManager;
- (instancetype)initWithDataManager:(THLPromotionSelectionDataManager *)dataManager;

- (void)getPromotionsForEvent:(THLEventEntity *)eventEntity;
@end
