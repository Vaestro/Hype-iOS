//
//  THLSearchResultsViewDataSourceHandler.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEntity;
typedef void (^THLSearchResultsViewDataSourceHandlerBlock)(NSMutableDictionary *dict, NSString *collection, id object);

@interface THLSearchResultsViewDataSourceHandler : NSObject
@property (nonatomic, copy, readonly) THLSearchResultsViewDataSourceHandlerBlock handlerBlock;

+ (instancetype)withBlock:(THLSearchResultsViewDataSourceHandlerBlock)block;
@end

