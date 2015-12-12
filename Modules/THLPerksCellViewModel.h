//
//  THLPerksCellViewModel.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkCellView.h"

@protocol THLPerkCellView;
@class THLPerkStoreItemEntity;

@interface THLPerksCellViewModel : NSObject
@property (nonatomic, readonly) THLPerkStoreItemEntity *perkStoreItemEntity;

- (instancetype)initWithPerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItem;
- (void)configureView:(id<THLPerkCellView>)view;
@end
