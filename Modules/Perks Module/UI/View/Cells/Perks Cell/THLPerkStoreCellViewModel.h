//
//  THLPerkStoreCellViewModel.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkStoreCellView.h"

@protocol THLPerkStoreCellView;
@class THLPerkStoreItemEntity;

@interface THLPerkStoreCellViewModel : NSObject
@property (nonatomic, readonly) THLPerkStoreItemEntity *perkStoreItemEntity;

- (instancetype)initWithPerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItem;
- (void)configureView:(id<THLPerkStoreCellView>)view;
@end
