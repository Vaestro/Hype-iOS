//
//  THLPerkStoreCellViewModel.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreCellViewModel.h"
#import "THLPerkStoreCellView.h"
#import "THLPerkStoreItemEntity.h"

@implementation THLPerkStoreCellViewModel

- (instancetype)initWithPerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItemEntity {
    if (self = [super init]) {
        _perkStoreItemEntity = perkStoreItemEntity;
    }
    return self;
}

- (void)configureView:(id<THLPerkStoreCellView>)cellView {
    [cellView setName:_perkStoreItemEntity.name];
    [cellView setInfo:_perkStoreItemEntity.info];
    [cellView setImage:_perkStoreItemEntity.image];
    [cellView setCredits:_perkStoreItemEntity.credits];
}
@end
