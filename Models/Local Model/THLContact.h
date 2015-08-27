//
//  THLContact.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLUser.h"

@interface THLContact : THLUser
@property (nonatomic) BOOL isLocal;
@property (nonatomic) BOOL isRemote;
@end
