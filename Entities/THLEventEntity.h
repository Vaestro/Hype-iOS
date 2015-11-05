//
//  THLEventEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "THLLocationEntity.h"


@interface THLEventEntity : THLEntity
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) THLLocationEntity *location;
@property (nonatomic) float maleCover;
@property (nonatomic) float femaleCover;
@end
