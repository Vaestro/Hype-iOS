//
//  THLEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLEntity : NSObject <NSCoding>
@property (nonatomic, copy) NSString *objectId;

/**
 *  Updates the entity with another entity of newer information. Returns YES if any fields were 
 *	changed, otherwise returns NO.
 */
//- (BOOL)updateWith:(THLEntity *)newEntity;
- (BOOL)shouldUpdateWith:(THLEntity *)newEntity;
- (BOOL)isEquivalentTo:(THLEntity *)cmpEntity;

@end
