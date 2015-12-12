//
//  THLPerkStoreItemEntity.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "THLPerkStoreItemEntity.h"

@interface THLPerkStoreItemEntity : THLEntity
@property (nonatomic, copy) NSString *name;
@property (strong, readwrite) NSString *itemDescription;
@property (nonatomic, copy) NSURL *image;
@property (nonatomic) int credits;
@end
