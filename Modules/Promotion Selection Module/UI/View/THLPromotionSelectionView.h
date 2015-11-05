//
//  THLPromotionSelectionView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@protocol THLPromotionSelectionView <NSObject>
@property (nonatomic, strong) RACCommand *chooseHostCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) NSArray *viewModels;

@property (nonatomic, readonly) NSInteger selectedIndex;
@end
