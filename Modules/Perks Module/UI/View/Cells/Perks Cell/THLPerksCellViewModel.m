//
//  THLPerksCellViewModel.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerksCellViewModel.h"
#import "THLPerkCellView.h"
#import "THLPerkStoreItemEntity.h"

@implementation THLPerksCellViewModel

- (instancetype)initWithPerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItemEntity {
    if (self = [super init]) {
        _perkStoreItemEntity = perkStoreItemEntity;
    }
    return self;
}

- (void)configureView:(id<THLPerkCellView>)cellView {
    [cellView setName:_perkStoreItemEntity.name];
    [cellView setDescription:_perkStoreItemEntity.description];
    [cellView setImage:_perkStoreItemEntity.image];
    [cellView setCredits:_perkStoreItemEntity.credits];
}
@end
