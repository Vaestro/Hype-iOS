//
//  THLEntity+DataStore.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

@interface THLEntity (DataStore)
@property (nonatomic, copy, readonly) NSString *key;
@end
